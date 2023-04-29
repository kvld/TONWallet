//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import Foundation
import Mnemonic
import TONClient
import TONSchema
import Combine
import Storage

public final class TONService {
    private let _client: TONClient
    private var _configInfo = CurrentValueSubject<OptionsConfigInfo?, Never>(nil)

    private let cachedState: StorageItemWrapper<CachedState>?

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
        storage: Storage,
        configURL: URL
    ) {
        self._client = client
        self.configURL = configURL

        self.cachedState = storage.retrieve(
            with: .cachedState,
            defaultValue: .default,
            constrainTypeWith: .unsafe
        )

        Task {
            try await loadConfig()
        }
    }

    private func loadConfig() async throws {
        let configData = try await URLSession.shared.data(from: configURL).0

        let keystoreDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        let initRequest = Init(
            options: .init(
                config: .init(
                    config: String(data: configData, encoding: .utf8)!,
                    blockchainName: "",
                    useCallbacksForNetwork: false,
                    ignoreCache: false
                ),
                keystoreType: {
                    if let keystoreDirectory {
                        return .keyStoreTypeDirectory(.init(directory: keystoreDirectory.path))
                    }
                    return .keyStoreTypeInMemory(.init())
                }()
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
            address: .init(address.accountAddress),
            keys: .init(
                privateKey: privateKey.data,
                secretKey: secretKey,
                publicKey: publicKey,
                mnemonicWords: words
            )
        )
    }

    public func fetchWalletState(address: Address) async throws -> WalletState {
        let stateResponse: TONSchema.FullAccountState

        let stateRequest = GetAccountState(accountAddress: .init(accountAddress: address.value))

        stateResponse = try await client.execute(stateRequest)

        let lastTransaction: TransactionID = .init(
            lt: stateResponse.lastTransactionId.lt.value,
            hash: stateResponse.lastTransactionId.hash
        )

        cachedState?.value.lastKnownTransaction = lastTransaction
        return .init(balance: .init(stateResponse.balance.value), lastTransactionID: lastTransaction)
    }

    public func fetchTransactions(
        address: Address,
        fromTransaction: TransactionID
    ) async throws -> (transactions: [Transaction], lastTransaction: TransactionID?) {
        let transactionsRequest = RawGetTransactions(
            privateKey: .inputKeyFake(.init()),
            accountAddress: .init(accountAddress: address.value),
            fromTransactionId: .init(
                lt: .init(fromTransaction.lt),
                hash: fromTransaction.hash
            )
        )

        let response = try await client.execute(transactionsRequest)

        let lastTransaction: TransactionID? = response.transactions.isEmpty
            ? nil
            : .init(lt: response.previousTransactionId.lt.value, hash: response.previousTransactionId.hash)

        let transactions = response.transactions.compactMap { tr -> Transaction? in
            guard let msg = tr.outMsgs.first else {
                return nil
            }

            return Transaction(
                id: .init(lt: tr.transactionId.lt.value, hash: tr.transactionId.hash),
                sender: .init(msg.source.accountAddress),
                receiver: .init(msg.destination.accountAddress),
                amount: .init(msg.value.value),
                fee: .init(tr.fee.value),
                date: .init(timeIntervalSince1970: TimeInterval(tr.utime)),
                message: nil
            )
        }

        return (transactions, lastTransaction)
    }
}

extension StorageKey {
    static var cachedState: StorageKey { .init("cachedTONState") }
}
