//
//  Created by Vladislav Kiriukhin on 24.04.2023.
//

import Foundation
import Storage
import Combine

public enum WalletFetchState {
    case unknown
    case fetched(WalletInfo?)

    public var isUnknown: Bool {
        switch self {
        case .fetched:
            return false
        case .unknown:
            return true
        }
    }

    public var walletInfo: WalletInfo? {
        switch self {
        case let .fetched(value):
            return value
        case .unknown:
            return nil
        }
    }
}

public final class WalletInfoService {
    private let storage: Storage

    private var _walletFetchState = CurrentValueSubject<WalletFetchState, Never>(.unknown)

    public init(storage: Storage) {
        self.storage = storage

        loadLastUsedWallet()
    }

    private func loadLastUsedWallet() {
        guard let lastUsedUUID: UUID = try? storage.retrieve(with: .lastUsedWalletUUID) else {
            _walletFetchState.send(.fetched(nil))
            return
        }

        guard let walletInfo: WalletInfo = try? storage.retrieve(
            with: .walletInfo(uuid: lastUsedUUID),
            type: .safe
        ) else {
            _walletFetchState.send(.fetched(nil))
            return
        }

        _walletFetchState.send(.fetched(walletInfo))
    }
}

extension WalletInfoService {
    public var walletFetchState: AnyPublisher<WalletFetchState, Never> {
        _walletFetchState.eraseToAnyPublisher()
    }

    public var lastKnownWallet: WalletFetchState {
        _walletFetchState.value
    }

    public func updateWallet(with walletInfo: WalletInfo) throws {
        let uuid = walletInfo.uuid

        try storage.store(walletInfo, withKey: .walletInfo(uuid: uuid), type: .safe)
        try storage.store(uuid, withKey: .lastUsedWalletUUID)

        _walletFetchState.send(.fetched(walletInfo))
    }
}

extension StorageKey {
    static var lastUsedWalletUUID: StorageKey { .init("lastUsedWalletUUID") }

    static func walletInfo(uuid: UUID) -> StorageKey { .init("walletInfo[\(uuid.uuidString)]") }
}
