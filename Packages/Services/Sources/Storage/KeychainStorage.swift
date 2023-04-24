//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import Foundation
import Security

final class KeychainStorage: StorageProvider {
    func store<T: Encodable>(_ object: T, withKey key: String) throws {
        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = .base64

        let data = try encoder.encode(object)

        let keychainQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(keychainQuery)
        SecItemAdd(keychainQuery, nil)
    }

    func remove(for key: String) {
        let keychainQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary

        SecItemDelete(keychainQuery)
    }

    func retrieve<T: Decodable>(with key: String) throws -> T? {
        let keychainQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var ref: CFTypeRef?
        let status = SecItemCopyMatching(keychainQuery, &ref)

        guard status == noErr, let _data = ref as? Data?, let data = _data else {
            return nil
        }

        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = .base64

        return try decoder.decode(T.self, from: data)
    }
}
