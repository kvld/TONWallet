//
//  Created by Vladislav Kiriukhin on 29.04.2023.
//

import Foundation

public struct Address: Codable, Equatable {
    public let value: String

    public init(_ value: String) {
        self.value = value
    }
}

extension Address {
    public func shortened(partLength: Int = 4, separator: String = "…") -> String {
        String(value.prefix(partLength)) + separator + String(value.suffix(partLength))
    }

    public var transferLink: String {
        "ton://transfer/\(value)"
    }
}
