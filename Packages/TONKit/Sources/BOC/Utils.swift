//
//  Created by Vladislav Kiriukhin on 15.04.2023.
//

import Foundation

extension BinaryInteger {
    var bits: [Bit] {
        var binaryRepresentation: [Bit] = .init(repeating: ._0, count: bitWidth)
        var internalNumber = self

        for i in 0..<bitWidth {
            binaryRepresentation[i] = (internalNumber & 1) > 0
            internalNumber >>= 1
        }

        return binaryRepresentation.reversed()
    }

    /// Size of integer without  leading zero bits
    var nonZeroBitsLength: UInt {
        if self == 0 {
            return 1
        }

        return UInt(bits.drop(while: { $0 == ._0 }).count)
    }

    /// How many bytes needed to represent a number
    var minimalBytesCount: UInt {
        let (q, r) = quotientAndRemainder(dividingBy: 8)
        return UInt(q + (r > 0 ? 1 : 0))
    }
}

extension Data {
    public init?(hexString: String) {
        guard hexString.count % 2 == 0 else {
            return nil
        }

        if hexString.isEmpty {
            self = .init()
            return
        }

        let bytesCount = hexString.count / 2
        var buffer = Data(capacity: bytesCount)

        var i = hexString.startIndex
        for _ in 0..<bytesCount {
            let endIndex = hexString.index(i, offsetBy: 2)
            let bytes = hexString[i..<endIndex]

            if let num = UInt8(bytes, radix: 16) {
                buffer.append(num)
            } else {
                return nil
            }

            i = endIndex
        }

        self = buffer
    }

    public var hexString: String {
        map { String(format: "%02hhx", $0) }.joined()
    }

    var asUInt: UInt {
        var result: UInt = 0
        for byte in self {
            result *= 256
            result += UInt(byte)
        }
        return result
    }

    mutating func dropFirstAndReturn(_ count: Int) -> Data {
        let data = Data(prefix(count))
        removeFirst(count)
        return data
    }
}

extension Data {
    func calculateCRC2C() -> Data {
        let poly: UInt32 = 0x82f63b78

        var crc: UInt32 = ~0

        for byte in self {
            crc ^= UInt32(byte)
            crc = crc & 1 > 0 ? (crc >> 1) ^ poly : crc >> 1
            crc = crc & 1 > 0 ? (crc >> 1) ^ poly : crc >> 1
            crc = crc & 1 > 0 ? (crc >> 1) ^ poly : crc >> 1
            crc = crc & 1 > 0 ? (crc >> 1) ^ poly : crc >> 1
            crc = crc & 1 > 0 ? (crc >> 1) ^ poly : crc >> 1
            crc = crc & 1 > 0 ? (crc >> 1) ^ poly : crc >> 1
            crc = crc & 1 > 0 ? (crc >> 1) ^ poly : crc >> 1
            crc = crc & 1 > 0 ? (crc >> 1) ^ poly : crc >> 1
        }

        var result = ~crc
        return Data(bytes: &result, count: MemoryLayout<UInt32>.size)
    }
}

extension UInt {
    var int: Int { Int(self) }
}
