//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import Foundation

final class DefaultsStorage: StorageProvider {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    func store<T: Encodable>(_ object: T, withKey key: String) throws {
        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = .base64

        let data = try encoder.encode(object)
        let base64String = data.base64EncodedString()

        userDefaults.set(base64String, forKey: key)
    }

    func retrieve<T: Decodable>(with key: String) throws -> T? {
        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = .base64

        guard let base64StringData = userDefaults.string(forKey: key)?.data(using: .utf8),
              let data = Data(base64Encoded: base64StringData) else {
            return nil
        }

        return try decoder.decode(T.self, from: data)
    }

    func remove(for key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
