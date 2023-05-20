//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import Foundation

public enum SecurityType {
    case safe
    case unsafe
}

public struct StorageKey {
    public let value: String

    public init(_ value: String) {
        self.value = value
    }
}

public final class StorageItemWrapper<T: Codable> {
    public var value: T {
        didSet {
            onUpdate(value)
        }
    }

    public let type: SecurityType
    private let onUpdate: (T) -> Void

    fileprivate init(value: T, type: SecurityType, onUpdate: @escaping (T) -> Void) {
        self.value = value
        self.type = type
        self.onUpdate = onUpdate
    }
}

public final class Storage {
    private let safeStorage: any StorageProvider
    private let unsafeStorage: any StorageProvider

    public init() {
        self.safeStorage = KeychainStorage()
        self.unsafeStorage = DefaultsStorage(userDefaults: UserDefaults.standard)
    }

    public func store<T: Encodable>(_ object: T, withKey key: StorageKey, type: SecurityType = .`unsafe`) throws {
        try resolveStorage(for: type).store(object, withKey: key.value)
    }

    public func store<T: Encodable>(
        _ object: T?,
        withKey key: StorageKey,
        type: SecurityType = .`unsafe`
    ) throws -> StorageItemWrapper<T?> {
        let wrapper = StorageItemWrapper<T?>(value: nil, type: type) { [self] newValue in
            guard let newValue else {
                return
            }
            try? self.resolveStorage(for: type).store(newValue, withKey: key.value)
        }
        wrapper.value = object
        return wrapper
    }

    public func retrieve<T: Decodable>(with key: StorageKey, type: SecurityType = .`unsafe`) throws -> T? {
        try resolveStorage(for: type).retrieve(with: key.value)
    }

    public func retrieve<T: Decodable>(
        with key: StorageKey,
        defaultValue: T,
        constrainTypeWith type: SecurityType = .`unsafe`
    ) -> StorageItemWrapper<T> {
        let onUpdate: (T) -> Void = { [self] newValue in
            try? self.resolveStorage(for: type).store(newValue, withKey: key.value)
        }

        guard let object: T = try? resolveStorage(for: type).retrieve(with: key.value) else {
            return StorageItemWrapper(value: defaultValue, type: type, onUpdate: onUpdate)
        }

        return StorageItemWrapper(
            value: object,
            type: type,
            onUpdate: onUpdate
        )
    }

    public func remove(with key: StorageKey) {
        safeStorage.remove(for: key.value)
        unsafeStorage.remove(for: key.value)
    }

    private func resolveStorage(for type: SecurityType) -> any StorageProvider {
        type == .safe ? safeStorage : unsafeStorage
    }
}
