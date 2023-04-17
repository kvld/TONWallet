//
//  Created by Vladislav Kiriukhin on 15.04.2023.
//

import Foundation
import CryptoKit

// see: https://github.com/toncenter/tonweb/blob/master/src/boc/Cell.js

struct InvalidCellFormatError: Error {
    let message: String
}

public final class Cell {
    public var bits: BitString
    private(set) var refs: [Cell]
    private(set) var isExotic: Bool

    public var isExplicitlyStoredHashes: Bool {
        false
    }

    public init() {
        self.bits = BitString(length: 1023)
        self.refs = []
        self.isExotic = false
    }

    init(bits: BitString, isExotic: Bool = false) {
        self.bits = bits
        self.refs = []
        self.isExotic = isExotic
    }

    public init(boc: Data) throws {
        let rootCells = try BoCSerializationHelper.deserialize(data: boc)

        if rootCells.count != 1 {
            throw InvalidCellFormatError(message: "Should be only one root cell in BoC")
        }

        self.bits = rootCells[0].bits
        self.refs = rootCells[0].refs
        self.isExotic = rootCells[0].isExotic
    }

    public func serializeAsBoC(
        hasIdx: Bool = true,
        hasCRC32: Bool = true,
        hasCacheBits: Bool = false,
        flags: UInt8 = 0
    ) throws -> Data {
        try BoCSerializationHelper.serialize(
            cell: self,
            hasIdx: hasIdx,
            hasCRC32: hasCRC32,
            hasCacheBits: hasCacheBits,
            flags: flags
        )
    }

    public func attach(_ refs: Cell...) throws {
        if self.refs.count + refs.count > 7 {
            throw InvalidCellFormatError(message: "Cell should contains less than 8 refs")
        }

        refs.forEach { self.refs.append($0) }
    }

    public func set(refs: [Cell]) throws {
        if refs.count > 7 {
            throw InvalidCellFormatError(message: "Cell should contains less than 8 refs")
        }

        self.refs = refs
    }

    public func merge(with cell: Cell) throws {
        try bits.append(cell.bits)
        refs.append(contentsOf: cell.refs)
    }

    public func getMaxDepth() -> UInt {
        var maxDepth: UInt = 0

        if !refs.isEmpty {
            for ref in refs {
                maxDepth = max(maxDepth, ref.getMaxDepth())
            }
            maxDepth += 1
        }

        return maxDepth
    }

    func getRefsDescriptor() -> UInt8 {
        let refsCount = UInt8(refs.count)

        return (0 << 5) // 4 bits, always 0 now
            + ((isExotic ? 1 : 0) << 3) // 1 bit
            + refsCount // 3 bits
    }

    func getBitsDescriptor() -> UInt8 {
        var (q, r) = bits.usedBits.quotientAndRemainder(dividingBy: 4)
        if r > 0 {
            q |= 1
        }
        return UInt8(max(1, q))
    }

    func getDataWithDescriptors() throws -> Data {
        var data = Data([getRefsDescriptor()])
        data.append(getBitsDescriptor())
        data.append(contentsOf: try bits.convertToTopUppedBytes())
        return Data(data)
    }

    func serialize() throws -> Data {
        var repr = Data()

        repr.append(contentsOf: try getDataWithDescriptors())
        
        for ref in refs {
            repr.append(contentsOf: ref.getMaxDepthAsArray())
        }

        for ref in refs {
            repr.append(contentsOf: try ref.getHash())
        }

        return repr
    }

    public func getHash() throws -> Data {
        var fn = SHA256()
        fn.update(data: try serialize())
        return Data(fn.finalize())
    }

    public func getCurrentDescription() throws -> String {
        "x{" + (try bits.convertToHexString()) + "}"
    }

    public func getRecursiveDescription(indent: Int = 0) throws -> String {
        var string = String(repeating: " ", count: indent) + (try getCurrentDescription()) + "\n"
        for ref in refs {
            string += try ref.getRecursiveDescription(indent: indent + 1)
        }
        return string
    }

    // MARK: - Private

    private func getMaxDepthAsArray() -> Data {
        let (q, r) = getMaxDepth().quotientAndRemainder(dividingBy: 256)
        return .init([UInt8(q), UInt8(r)])
    }
}
