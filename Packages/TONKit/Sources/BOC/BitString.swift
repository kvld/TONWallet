//
//  Created by Vladislav Kiriukhin on 15.04.2023.
//

import Foundation

// see https://github.com/toncenter/tonweb/blob/master/src/boc/BitString.js

public typealias Bit = Bool

extension Bit {
    public static var _0: Bit { false }
    public static var _1: Bit { true }
}

public struct BitStringOverflowError: Error { }

public struct BitStringIncorrectWidthError: Error {
    let message: String
}

public struct BitStringStringConversionError: Error { }
public struct BitStringIncorrentTopUppedError: Error { }

public struct BitString: Hashable {
    public static var maxLength: Int { 100_000 }

    private var bytes: Data
    private var cursor: UInt
    private var length: UInt

    public var freeBits: UInt {
        length - cursor
    }

    public var usedBits: UInt {
        cursor
    }

    public var usedBytes: UInt {
        usedBits.minimalBytesCount
    }

    public subscript(index: UInt) -> Bit {
        get throws {
            try get(index)
        }
    }

    public init(bits: [Bit]) throws {
        if bits.count > Self.maxLength {
            throw BitStringOverflowError()
        }

        var string = BitString(length: UInt(bits.count))
        try string.append(bits)

        self.bytes = string.bytes
        self.cursor = string.cursor
        self.length = string.length
    }

    public init(binaryString: String) throws {
        if binaryString.count > Self.maxLength {
            throw BitStringOverflowError()
        }

        var string = BitString(length: UInt(binaryString.count))
        for bit in binaryString {
            try string.append(bit == "1")
        }

        self.bytes = string.bytes
        self.cursor = string.cursor
        self.length = string.length
    }

    public init(topUppedBytes: Data, fullfilledBytes: Bool = true) throws {
        self.bytes = topUppedBytes
        self.cursor = UInt(topUppedBytes.count * 8)
        self.length = UInt(topUppedBytes.count * 8)

        if fullfilledBytes || length == 0 {
            return
        }

        var foundEndBit = false
        for _ in 0..<7 {
            cursor -= 1
            if try get(cursor) {
                foundEndBit = true
                try set(cursor, to: ._0)
                break
            }
        }

        if !foundEndBit {
            throw BitStringIncorrentTopUppedError()
        }
    }

    public init(length: UInt = 0) {
        self.bytes = Data(repeating: 0, count: length.minimalBytesCount.int)

        self.cursor = 0
        self.length = length
    }

    public func get(_ index: UInt) throws -> Bit {
        try checkRange(for: index)
        let bytesIndex = (index / 8) | 0
        return (bytes[bytesIndex.int] & (1 << (7 - (index % 8)))) > 0
    }

    public mutating func set(_ index: UInt, to: Bit) throws {
        try checkRange(for: index)

        let bytesIndex = (index / 8) | 0

        if to {
            bytes[bytesIndex.int] |= 1 << (7 - (index % 8))
        } else {
            bytes[bytesIndex.int] &= ~(1 << (7 - (index % 8)))
        }
    }

    public mutating func toggle(_ index: UInt) throws {
        let bit = try get(index)
        try set(index, to: !bit)
    }

    public func forEach(_ action: (Bit) throws -> Void) throws {
        for i in 0..<cursor {
            let bit = try get(i)
            try action(bit)
        }
    }

    public mutating func append(_ bit: Bit) throws {
        try unsafeAppend(bit)

        if length > Self.maxLength {
            throw BitStringOverflowError()
        }
    }

    public mutating func append<S: Sequence>(_ seq: S) throws where S.Element == Bit {
        for bit in seq {
            try append(bit)
        }
    }

    public mutating func append<B: BinaryInteger>(_ integer: B, width: UInt? = nil) throws {
        let bits = integer.bits

        if let width {
            // Original bits should be less or equal to given width
            if bits.count > width {
                // But if we can drop leading zeros in binary representation then it's ok
                let withoutLeadingZeroBits = bits.drop(while: { $0 == ._0 })
                if withoutLeadingZeroBits.count > width {
                    throw BitStringIncorrectWidthError(
                        message: "Unable to add value \(integer) " +
                        "(bits \(withoutLeadingZeroBits.map { $0 ? "1" : "0" }.joined())) with width = \(width)"
                    )
                }
            }

            var bitsWithGivenWidth = bits.suffix(width.int)
            if bits.count < width {
                bitsWithGivenWidth = Array(repeating: ._0, count: width.int - bits.count) + bitsWithGivenWidth
            }

            try append(bitsWithGivenWidth)
        } else {
            try append(integer.bits)
        }
    }

    public mutating func append(_ data: Data) throws {
        for byte in data {
            try append(byte)
        }
    }

    public mutating func append(_ string: String) throws {
        guard let data = string.data(using: .utf8) else {
            throw BitStringStringConversionError()
        }

        try append(data)
    }

    public mutating func append(_ bitString: BitString) throws {
        try bitString.forEach { try self.append($0) }
    }

    public func convertToTopUppedBytes() throws -> Data {
        var tmp = self

        var tu = usedBytes * 8 - cursor
        if tu > 0 {
            tu -= 1
            try tmp.unsafeAppend(._1)

            while tu > 0 {
                tu -= 1
                try tmp.unsafeAppend(._0)
            }
        }

        let bytes = tmp.bytes.prefix(tmp.usedBytes.int)
        return Data(bytes)
    }

    public func convertToHexString() throws -> String {
        if cursor % 4 == 0 {
            let string = Data(bytes.prefix(cursor.minimalBytesCount.int)).hexString.uppercased()
            return cursor % 8 == 0 ? string : String(string.dropLast())
        } else {
            var tmp = self
            try tmp.unsafeAppend(._1)
            while tmp.usedBits % 4 != 0 {
                try tmp.unsafeAppend(._0)
            }
            return try tmp.convertToHexString() + "_"
        }
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(bytes)
    }

    // MARK: - Private

    private mutating func unsafeAppend(_ bit: Bit) throws {
        if freeBits == 0 {
            length += 1

            if bytes.count * 8 <= length {
                bytes.append(0)
            }
        }

        try set(cursor, to: bit)
        cursor += 1
    }


    private func checkRange(for index: UInt) throws {
        if index >= length {
            throw BitStringOverflowError()
        }
    }
}
