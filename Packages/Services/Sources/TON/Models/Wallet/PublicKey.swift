//
//  Created by Vladislav Kiriukhin on 09.05.2023.
//

import Foundation

public struct PublicKey: Codable, Equatable {
    public let encryptedKey: String

    public var key: Data {
        var encryptedKey = encryptedKey
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        if encryptedKey.count % 4 > 0 {
            encryptedKey += encryptedKey + String(repeating: "=", count: 4 - encryptedKey.count % 4)
        }

        guard let data = Data(base64Encoded: encryptedKey), data.count == 36 else {
            assertionFailure("Invalid base64")
            return .init()
        }

        return data[2..<34]
    }

    init(encryptedKey: String) {
        self.encryptedKey = encryptedKey
    }
}

func base64URLUnescaped(s: String) -> String {
    let replaced = s.replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")
    /// https://stackoverflow.com/questions/43499651/decode-base64url-to-base64-swift
    let padding = replaced.count % 4
    if padding > 0 {
        return replaced + String(repeating: "=", count: 4 - padding)
    } else {
        return replaced
    }
}
