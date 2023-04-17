import Foundation

struct BoCSchemeFormatError: Error {
    let message: String
}

struct BoCSerializationError: Error {
    let message: String
}

extension Cell {
    fileprivate func serialize(cellsIndex: [Data: Int], referenceWidth: Int) throws -> Data {
        var representation = Data()

        representation.append(contentsOf: try getDataWithDescriptors())

        for ref in refs {
            let hash = try ref.getHash()

            guard let refIndex = cellsIndex[hash] else {
                throw BoCSerializationError(message: "Reference not found in traverse tree")
            }

            var refIndexHex = String(format: "%02X", refIndex)
            if !refIndexHex.count.isMultiple(of: 2) {
                refIndexHex = "0" + refIndexHex
            }

            guard let reference = Data(hexString: refIndexHex) else {
                throw BoCSerializationError(message: "Invalid reference BoC hex representation")
            }

            representation.append(reference)
        }

        return representation
    }
}

enum BoCSerializationHelper {
    static var reachBoCMagicPrefix: Data {
        Data([0xb5, 0xee, 0x9c, 0x72])
    }

    static var leanBoCMagicPrefix: Data {
        Data([0x68, 0xff, 0x65, 0xf3])
    }

    static var leanBoCMagicPrefixCRC: Data {
        Data([0xac, 0xc3, 0xa7, 0x28])
    }

    // MARK: - Deserialize

    private struct ParseBoCHeaderResult {
        let hasIdx: UInt8
        let hasCRC32: UInt8
        let hasCacheBits: UInt8
        let flags: UInt8
        let sizeBytes: UInt8
        let offsetBytes: UInt8
        let cellsNums: UInt
        let rootsNum: UInt
        let absentNum: UInt
        let totCellsSize: UInt
        let rootList: [UInt]
        let index: [UInt]
        let cellsData: Data
    }

    static func deserialize(data: Data) throws -> [Cell] {
        let header = try parseBoCHeader(data: data)

        var cellsData = header.cellsData
        var cells: [(Cell, [UInt])] = []

        for _ in 0..<header.cellsNums {
            let (cell, refs) = try deserializeCellData(data: &cellsData, refSize: header.sizeBytes)
            cells.append((cell, refs))
        }

        for i in 0..<cells.count {
            let cell = cells[i].0
            try cell.set(refs: cells[i].1.map { cells[Int($0)].0 })
        }

        var rootCells: [Cell] = []
        for idx in header.rootList {
            rootCells.append(cells[Int(idx)].0)
        }

        return rootCells
    }

    private static func deserializeCellData(
        data: inout Data,
        refSize: UInt8
    ) throws -> (cell: Cell, refs: [UInt]) {
        if data.count < 2 {
            throw BoCSerializationError(message: "Not enough bytes to encode cell descriptors")
        }

        let refSize = Int(refSize)

        let descriptor = data.dropFirstAndReturn(2)

        let d1 = descriptor[0]
        let d2 = descriptor[1]

        // d1 = 0b00000_[x](isExotic)_[xxx](refsCount)
        // d2 = 0b[xxxxxxxx](dataSize)
        let isExotic = d1 & (1 << 3)
        let refsCount = d1 % (1 << 3)

        if refsCount > 7 {
            throw InvalidCellFormatError(message: "Cell should contain less than 8 refs, given \(refsCount)")
        }

        let dataSize = Int(d2) / 2 + (d2 % 2 != 0 ? 1 : 0)
        let fullfilledBytes = d2 % 2 == 0

        if data.count < dataSize + Int(refsCount) * refSize {
            throw BoCSerializationError(message: "Not enough bytes to encode cell data")
        }

        let value = data.dropFirstAndReturn(dataSize)
        let bits = try BitString(topUppedBytes: value, fullfilledBytes: fullfilledBytes)

        var refs: [UInt] = []
        for _ in 0..<refsCount {
            let ref = data.dropFirstAndReturn(refSize).asUInt
            refs.append(ref)
        }

        let cell = Cell(bits: bits, isExotic: isExotic > 0)

        return (cell, refs)
    }

    private static func parseBoCHeader(data: Data) throws -> ParseBoCHeaderResult {
        var data = data
        if data.count < 5 {
            throw BoCSerializationError(message: "Not enough bytes for magic prefix")
        }

        let inputData = data

        let prefix = data.dropFirstAndReturn(4)

        let hasIdx: UInt8
        let hasCRC32: UInt8
        let hasCacheBits: UInt8
        let flags: UInt8
        let sizeBytes: UInt8

        let flagsByte = data.dropFirstAndReturn(1)[0]

        if prefix == reachBoCMagicPrefix {
            hasIdx = flagsByte & 128
            hasCRC32 = flagsByte & 64
            hasCacheBits = flagsByte & 32
            flags = (flagsByte & 16) << 1 + (flagsByte & 8)
            sizeBytes = flagsByte % 8
        } else if prefix == leanBoCMagicPrefix {
            hasIdx = 1
            hasCRC32 = 0
            hasCacheBits = 0
            flags = 0
            sizeBytes = flagsByte
        } else if prefix == leanBoCMagicPrefixCRC {
            hasIdx = 1
            hasCRC32 = 1
            hasCacheBits = 0
            flags = 0
            sizeBytes = flagsByte
        } else {
            throw BoCSerializationError(message: "Unknown BoC prefix")
        }

        if data.count < 5 * sizeBytes + 1 {
            throw BoCSerializationError(message: "Not enough bytes for encoding cells counters")
        }

        let offsetBytes = data.dropFirstAndReturn(1)[0]
        let cellsNums = data.dropFirstAndReturn(Int(sizeBytes)).asUInt
        let rootsNum = data.dropFirstAndReturn(Int(sizeBytes)).asUInt
        let absentNum = data.dropFirstAndReturn(Int(sizeBytes)).asUInt
        let totCellsSize = data.dropFirstAndReturn(Int(offsetBytes)).asUInt

        if data.count < rootsNum * UInt(sizeBytes) {
            throw BoCSerializationError(message: "Not enough bytes for encoding root cells hashes")
        }

        var rootList: [UInt] = []
        for _ in 0..<rootsNum {
            rootList.append(data.dropFirstAndReturn(Int(sizeBytes)).asUInt)
        }

        var index: [UInt] = []
        if hasIdx > 0 {
            if data.count < UInt(offsetBytes) * cellsNums {
                throw BoCSerializationError(message: "Not enough bytes for index encoding")
            }

            for _ in 0..<cellsNums {
                index.append(data.dropFirstAndReturn(Int(offsetBytes)).asUInt)
            }
        }

        if data.count < totCellsSize {
            throw BoCSerializationError(message: "Not enough bytes for cells data")
        }

        let cellsData = data.dropFirstAndReturn(Int(totCellsSize))
        if hasCRC32 > 0 {
            if data.count < 4 {
                throw BoCSerializationError(message: "Not enough bytes for crc32c hashsum")
            }

            let crc32cBytes = inputData.dropLast(4).calculateCRC2C()

            let bocHashsum = data.dropFirstAndReturn(4)

            if data.count > 0 {
                throw BoCSerializationError(message: "Too much bytes in BoC serialization: \(data.count) left")
            }

            if crc32cBytes != bocHashsum {
                throw BoCSerializationError(
                    message: "CRC32C hashsum mismatch. Calculated sum \(crc32cBytes.hexString) "
                        + "vs. boc sum \(bocHashsum.hexString)"
                )
            }
        }

        if data.count > 0 {
            throw BoCSerializationError(message: "Too much bytes in BoC serialization: \(data.count) left")
        }

        return .init(
            hasIdx: hasIdx,
            hasCRC32: hasCRC32,
            hasCacheBits: hasCacheBits,
            flags: flags,
            sizeBytes: sizeBytes,
            offsetBytes: offsetBytes,
            cellsNums: cellsNums,
            rootsNum: rootsNum,
            absentNum: absentNum,
            totCellsSize: totCellsSize,
            rootList: rootList,
            index: index,
            cellsData: cellsData
        )
    }

    // MARK: - Serialize

    public static func serialize(
        cell: Cell,
        hasIdx: Bool = true,
        hasCRC32: Bool = true,
        hasCacheBits: Bool = false,
        flags: UInt8 = 0
    ) throws -> Data {
        let graph = try CellGraph(from: [cell])
        let order = graph.order

        let refSize = order.count.nonZeroBitsLength.minimalBytesCount

        var fullSize = 0
        var cellDataOffsets: [Int] = []

        for hash in graph.orderHashes {
            guard let cell = graph.cells[hash] else {
                assertionFailure("Unknown hash")
                throw BoCSerializationError(message: "Unknown hash in cells graph")
            }

            cellDataOffsets.append(fullSize)
            fullSize += try cell.serialize(cellsIndex: order, referenceWidth: refSize.int).count
        }

        let offsetSize = fullSize.nonZeroBitsLength.minimalBytesCount

        var bits = BitString()

        try bits.append(reachBoCMagicPrefix) // 4 bytes: 0xb5ee9c72

        // 1 byte
        try bits.append(hasIdx) // has_idx:(## 1)
        try bits.append(hasCRC32) // has_crc32c:(## 1)
        try bits.append(hasCacheBits) // has_cache_bits:(## 1)
        try bits.append(flags, width: 2) // flags:(## 2) { flags = 0 }

        if refSize > 4 {
            throw BoCSchemeFormatError(
                message: "Reference size should be < 4, given \(refSize) for size \(order.count.bits.count)"
            )
        }
        try bits.append(refSize, width: 3) // size:(## 3) { size <= 4 }

        // 1 byte
        if offsetSize > 8 {
            throw BoCSchemeFormatError(
                message: "Offset size should be <= 8, given \(offsetSize) for size \(fullSize.bits.count)"
            )
        }
        try bits.append(UInt8(offsetSize)) // off_bytes:(## 8) { off_bytes <= 8 }

        // 8x bytes
        try bits.append(order.count, width: refSize * 8) // cells:(##(size * 8))

        // 8x bytes
        try bits.append(1, width: refSize * 8) // roots:(##(size * 8)) { roots >= 1 }

        // 8x bytes
        try bits.append(0, width: refSize * 8) // absent:(##(size * 8)) { roots + absent <= cells }

        // 8x bytes
        try bits.append(fullSize, width: offsetSize * 8) // tot_cells_size:(##(off_bytes * 8))

        // 8x bytes
        // only one root cell now
        try bits.append(0, width: refSize * 8) // root_list:(roots * ##(size * 8))

        // index:has_idx?(cells * ##(off_bytes * 8))
        if hasIdx {
            for offset in cellDataOffsets {
                try bits.append(offset, width: offsetSize * 8)
            }
        }

        // cell_data:(tot_cells_size * [ uint8 ])
        for hash in graph.orderHashes {
            guard let cell = graph.cells[hash] else {
                assertionFailure("Unknown hash")
                throw BoCSerializationError(message: "Unknown hash in cells graph")
            }

            let serializedCell = try cell.serialize(cellsIndex: order, referenceWidth: refSize.int)
            try bits.append(serializedCell)
        }

        var toppedUpData = try bits.convertToTopUppedBytes()

        // crc32c:has_crc32c?uint32
        if hasCRC32 {
            let crc = toppedUpData.calculateCRC2C()
            toppedUpData.append(crc)
        }

        return toppedUpData
    }
}

final class CellGraph {
    private var usedCell: [Data: Bool] = [:]
    private var _order: [Data] = []

    /// Map hash -> cell
    private(set) var cells: [Data: Cell] = [:]

    /// Cell's hashes in order of topological sort
    var orderHashes: [Data] { _order.reversed() }

    /// Order of topological sorting
    var order: [Data: Int] {
        var indexMap: [Data: Int] = [:]
        for (idx, hash) in _order.reversed().enumerated() {
            indexMap[hash] = idx
        }
        return indexMap
    }

    init(from cells: [Cell]) throws {
        try cells.forEach { usedCell[try $0.getHash()] = false }

        for cell in cells {
            let hash = try cell.getHash()

            if usedCell[hash, default: false] {
                _order = _order.filter { $0 != hash }
            }

            try dfs(cell)
        }
    }

    private func dfs(_ cell: Cell) throws {
        let hash = try cell.getHash()

        usedCell[hash] = true
        cells[hash] = cell

        for ref in cell.refs {
            let refHash = try ref.getHash()

            if usedCell[refHash, default: false] {
                _order = _order.filter { $0 != refHash }
            }

            try dfs(ref)
        }

        _order.append(hash)
    }
}
