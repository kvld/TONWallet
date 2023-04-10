//
//  Created by Vladislav Kiriukhin on 09.04.2023.
//

import Foundation

public protocol TLType: Codable { }

public protocol TLObject: TLType {
    static var _type: String { get }
}

public protocol TLFunction: TLObject {
    associatedtype ReturnType: TLType
}

public protocol TDEnum: TLType { }

enum TLTypedCodingKey: String, CodingKey {
    case _type = "@type"
}

public struct TLTypedUnknownTypeError: Swift.Error { }

public struct TLInt64: Codable {
    private(set) var value: Swift.Int64

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        let value = try container.decode(String.self)
        guard let intValue = Swift.Int64(value) else {
            throw Error.badRepresentation
        }

        self.value = intValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.value)
    }

    enum Error: Swift.Error {
        case badRepresentation
    }
}
