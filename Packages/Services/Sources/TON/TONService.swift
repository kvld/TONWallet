//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import Foundation
import Mnemonic
import TONClient
import TONSchema
import Combine

public final class TONService {
    private let _client: TONClient
    private var _configInfo = CurrentValueSubject<OptionsConfigInfo?, Never>(nil)

    private let configURL: URL

    private var client: TONClient {
        get async throws {
            try await _configInfo
                .compactMap { $0 }
                .map { [_client] _ in _client }
                .eraseToAnyPublisher()
                .async
        }
    }

    private var configInfo: OptionsConfigInfo {
        get async throws {
            try await _configInfo
                .compactMap { $0 }
                .eraseToAnyPublisher()
                .async
        }
    }

    public init(
        client: TONClient = .init(),
        configURL: URL
    ) {
        self._client = client
        self.configURL = configURL

        Task {
            try await loadConfig()
        }

        Task {
            try await sync()
        }
    }

    private func sync() async throws {
        let sync = Sync()
        _ = try await client.execute(sync)
    }

    private func loadConfig() async throws {
        let configData = try await URLSession.shared.data(from: configURL).0

        let initRequest = Init(
            options: .init(
                config: .init(
                    config: String(data: configData, encoding: .utf8)!,
                    blockchainName: "",
                    useCallbacksForNetwork: false,
                    ignoreCache: false
                ),
                keystoreType: .keyStoreTypeInMemory(.init())
            )
        )

        let value = try await _client.execute(initRequest).configInfo
        _configInfo.send(value)
    }
}

extension TONService {
    public func createWallet() async throws -> WalletInfo {
        let generator = try MnemonicGenerator()

        let words = try await generator.generateMnemonic()
        let seed = try await generator.generateSeed(from: words)

        let (privateKey, secretKey) = try await generator.generateKeyPair(from: seed)
        let publicKey = try privateKey.publicKey

        let wallet = try await WalletFactory.makeWallet(
            workchain: 0,
            defaultWalletID: Int(configInfo.defaultWalletId.value),
            publicKey: publicKey
        )

        let initialAccountState = RawInitialAccountState(
            code: try wallet.code.serializeAsBoC(),
            data: try wallet.data.serializeAsBoC()
        )

        let accountAddressRequest = GetAccountAddress(
            initialAccountState: .rawInitialAccountState(initialAccountState),
            revision: 0,
            workchainId: 0
        )

        let address = try await client.execute(accountAddressRequest)

        return .init(
            uuid: .init(),
            address: address.accountAddress,
            keys: .init(
                privateKey: privateKey.data,
                secretKey: secretKey,
                publicKey: publicKey,
                mnemonicWords: words
            )
        )
    }
}
