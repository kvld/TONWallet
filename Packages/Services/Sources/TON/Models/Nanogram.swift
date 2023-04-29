//
//  Created by Vladislav Kiriukhin on 29.04.2023.
//

import Foundation

public struct FormattedGram {
    public let integer: String
    public let fractional: String?

    public var formatted: String {
        "\(integer)" + formattedFractionalOrEmpty
    }

    public var formattedFractionalOrEmpty: String {
        fractional == nil ? "" : ".\(fractional!)"
    }
}

public struct Nanogram {
    public let value: Int64

    public init(_ value: Int64) {
        self.value = value
    }
}

extension Nanogram {
    public var sign: Int {
        value < 0 ? -1 : (value == 0 ? 0 : 1)
    }

    public var integer: Int {
        Int(abs(value)) / 1_000_000_000
    }

    public var fraction: Int {
        Int(abs(value)) - integer * 1_000_000_000
    }
}

extension Nanogram {
    public var formatted: FormattedGram {
        let fractional = formattedFraction(dropIfZero: true)
        return .init(integer: "\(integer)", fractional: fractional.isEmpty ? nil : fractional)
    }

    public func formattedFraction(digitsCount number: Int = 9, dropIfZero: Bool = false) -> String {
        var fraction = String(fraction)

        if fraction.count < 9 {
            fraction = String(repeating: "0", count: 9 - fraction.count) + fraction
        }

        if dropIfZero, fraction.allSatisfy({ $0 == "0" }) {
            return ""
        }

        fraction = String(fraction.reversed().drop(while: { $0 == "0" }))

        return String(fraction.reversed().prefix(number))
    }
}

