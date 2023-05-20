//
//  Created by Vladislav Kiriukhin on 24.04.2023.
//

import Foundation
import Storage
import Combine

public struct Config: Codable {
    public var lastUsedWalletID: UUID?
    public var wallets: Set<WalletInfo>
    public var fiatCurrency: FiatCurrency

    public var lastUsedWallet: WalletInfo? {
        wallets.first(where: { $0.uuid == lastUsedWalletID })
    }

    public enum FiatCurrency: String, Codable {
        case usd = "USD"
        case eur = "EUR"
        case gbp = "GBP"
        case rub = "RUB"
        case aed = "AED"
    }

    public static var initial: Config {
        .init(wallets: [], fiatCurrency: .usd)
    }
}

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

public final class ConfigService {
    private let config: StorageItemWrapper<Config>

    private var _walletFetchState = CurrentValueSubject<WalletFetchState, Never>(.unknown)

    public init(storage: Storage) {
        self.config = storage.retrieve(with: .config, defaultValue: .initial, constrainTypeWith: .safe)

        loadLastUsedWallet()
    }

    private func loadLastUsedWallet() {
        _walletFetchState.send(.fetched(config.value.lastUsedWallet))
    }
}

extension ConfigService {
    public var walletFetchState: AnyPublisher<WalletFetchState, Never> {
        _walletFetchState.eraseToAnyPublisher()
    }

    public var lastKnownWallet: WalletFetchState {
        _walletFetchState.value
    }

    public func updateWallet(with walletInfo: WalletInfo) throws {
        let uuid = walletInfo.uuid

        config.value.wallets.insert(walletInfo)
        config.value.lastUsedWalletID = uuid

        _walletFetchState.send(.fetched(walletInfo))
    }
}

extension StorageKey {
    static var config: StorageKey { .init("config") }
}
