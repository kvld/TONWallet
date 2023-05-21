//
//  Created by Vladislav Kiriukhin on 24.04.2023.
//

import Foundation
import Storage
import Combine
import TON

public enum Currency: String, CaseIterable, Hashable, Codable {
    case usd = "USD"
    case eur = "EUR"
    case rub = "RUB"
    case aed = "AED"
    case gbp = "GBP"
}

public struct Config: Codable {
    internal(set) public var lastUsedWalletID: UUID?
    internal(set) public var wallets: Set<WalletInfo>
    internal(set) public var fiatCurrency: Currency
    internal(set) public var securityConfirmation: SecurityConfirmation

    public var lastUsedWallet: WalletInfo? {
        wallets.first(where: { $0.uuid == lastUsedWalletID })
    }

    public struct SecurityConfirmation: Codable {
        internal(set) public var passcode: String
        internal(set) public var isBiometricEnabled: Bool
    }

    public static var initial: Config {
        .init(wallets: [], fiatCurrency: .usd, securityConfirmation: .init(passcode: "", isBiometricEnabled: false))
    }
}

public final class ConfigService {
    private let _config: StorageItemWrapper<Config>

    internal(set) public var config: Config {
        get {
            _config.value
        }
        set {
            _config.value = newValue
            configSubject.send(newValue)
        }
    }

    private let configSubject: CurrentValueSubject<Config, Never>

    public init(storage: Storage) {
        let wrapper: StorageItemWrapper<Config> = storage
            .retrieve(with: .config, defaultValue: .initial, constrainTypeWith: .safe)

        self._config = wrapper
        self.configSubject = .init(wrapper.value)
    }
}

extension ConfigService {
    public var configPublisher: AnyPublisher<Config, Never> {
        configSubject.prepend(config).eraseToAnyPublisher()
    }

    public func getWallet(with type: WalletType) -> WalletInfo? {
        config.wallets.first(where: { $0.type == type })
    }

    public func updateWallet(with walletInfo: WalletInfo) {
        let uuid = walletInfo.uuid

        config.wallets.insert(walletInfo)
        config.lastUsedWalletID = uuid
    }

    public func updateSecurityInformation(passcode: String? = nil, isBiometricEnabled: Bool? = nil) {
        if let passcode {
            config.securityConfirmation.passcode = passcode
        }

        if let isBiometricEnabled {
            config.securityConfirmation.isBiometricEnabled = isBiometricEnabled
        }
    }

    public func updateCurrency(fiatCurrency: Currency) {
        config.fiatCurrency = fiatCurrency
    }

    public func removeAllData() {
        config = .initial
    }
}

extension StorageKey {
    static var config: StorageKey { .init("config") }
}
