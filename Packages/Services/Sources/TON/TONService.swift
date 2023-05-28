//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import Foundation
import TONClient
import TONSchema
import Combine
import Storage
import BOC
import CryptoKit

public final class TONService {
    public typealias QueryHashType = Bytes

    private var _client: TONClient
    private var _configInfo = CurrentValueSubject<OptionsConfigInfo?, Never>(nil)

    private var cachedDNSRootAddress: Address?
    private var cachedConfig: String?

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
        storage: Storage,
        configURL: URL
    ) {
        self._client = .init()
        self.configURL = configURL

        Task {
            try await loadConfig()
        }
    }

    private func loadConfig() async throws {
        let config: String
        if let cachedConfig {
            config = cachedConfig
        } else {
            let configData = try await URLSession.shared.data(from: configURL).0

            guard let _config = String(data: configData, encoding: .utf8) else {
                assertionFailure("Invalid config data")
                return
            }

            config = _config
            cachedConfig = config
        }

        let keystoreDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        let initRequest = Init(
            options: .init(
                config: .init(
                    config: config,
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
    public func reloadConfig() async throws {
        _client = .init()
        try await loadConfig()
    }

    public func createWallet() async throws -> WalletInfo {
        let createKeyRequest = CreateNewKey(
            localPassword: .init(),
            mnemonicPassword: .init(),
            randomExtraSeed: .init()
        )

        let key = try await client.execute(createKeyRequest)
        let inputKey: InputKey = .inputKeyRegular(.init(key: key, localPassword: .init()))

        let exportedKey = try await client.execute(ExportKey(inputKey: inputKey))
        let privateKey = try await client.execute(ExportUnencryptedKey(inputKey: inputKey))

        let publicKey = PublicKey(encryptedKey: key.publicKey)

        let wallet = try await WalletFactory.makeWallet(
            workchain: 0,
            walletID: Int(configInfo.defaultWalletId.value),
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

        return try await .init(
            uuid: .init(),
            type: .default,
            walletID: Int(configInfo.defaultWalletId.value),
            address: .init(address.accountAddress),
            credentials: .init(
                privateKey: privateKey.data,
                secretKey: key.secret,
                publicKey: publicKey,
                mnemonicWords: exportedKey.wordList
            )
        )
    }

    public func importWallet(mnemonicWords: [String], walletType: WalletType = .default) async throws -> WalletInfo {
        let exportedKey = ExportedKey(wordList: mnemonicWords)
        let key = try await client.execute(
            ImportKey(localPassword: .init(), mnemonicPassword: .init(), exportedKey: exportedKey)
        )

        let inputKey: InputKey = .inputKeyRegular(.init(key: key, localPassword: .init()))

        let privateKey = try await client.execute(ExportUnencryptedKey(inputKey: inputKey))

        let publicKey = PublicKey(encryptedKey: key.publicKey)

        let wallet = try await WalletFactory.makeWallet(
            type: walletType,
            workchain: 0,
            walletID: Int(configInfo.defaultWalletId.value),
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

        return try await .init(
            uuid: .init(),
            type: walletType,
            walletID: Int(configInfo.defaultWalletId.value),
            address: .init(address.accountAddress),
            credentials: .init(
                privateKey: privateKey.data,
                secretKey: key.secret,
                publicKey: publicKey,
                mnemonicWords: exportedKey.wordList
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

        return .init(balance: .init(max(0, stateResponse.balance.value)), lastTransactionID: lastTransaction)
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

        let lastTransaction: TransactionID? = response.previousTransactionId.lt.value == 0
            ? nil
            : .init(lt: response.previousTransactionId.lt.value, hash: response.previousTransactionId.hash)

        let transactions = response.transactions.map { tr -> Transaction in
            let msg = tr.outMsgs.first ?? tr.inMsg

            var message: String?

            switch msg.msgData {
            case let .msgDataDecryptedText(text):
                message = !text.text.isEmpty ? String(data: text.text, encoding: .utf8) : nil
            case let .msgDataText(text):
                message = !text.text.isEmpty ? String(data: text.text, encoding: .utf8) : nil
            default:
                message = nil
            }

            return Transaction(
                id: .init(lt: tr.transactionId.lt.value, hash: tr.transactionId.hash),
                sender: .init(msg.source.accountAddress),
                receiver: .init(msg.destination.accountAddress),
                amount: .init(msg.value.value),
                fee: .init(tr.fee.value),
                date: .init(timeIntervalSince1970: TimeInterval(tr.utime)),
                message: message,
                isIncome: address.value == msg.destination.accountAddress
            )
        }

        return (transactions, lastTransaction)
    }

    public func resolveDNS(domain: String) async throws -> Address? {
        if cachedDNSRootAddress == nil {
            let configInfo = try await client.execute(GetConfigParam(mode: 0, param: 4))
            let configCell = try Cell(boc: configInfo.config.bytes)

            let packAddressRequest = try PackAccountAddress(
                accountAddress: .init(
                    workchainId: -1,
                    bounceable: true,
                    testnet: false,
                    addr: Data(hexString: configCell.bits.convertToHexString()) ?? .init()
                )
            )
            let rootDNSAddress = try await client.execute(packAddressRequest)
            cachedDNSRootAddress = .init(rootDNSAddress.accountAddress)
        }

        guard let cachedDNSRootAddress else {
            return nil
        }

        var sha = SHA256()
        sha.update(data: "wallet".data(using: .utf8).unsafelyUnwrapped)

        let resolveRequest = DnsResolve(
            accountAddress: .init(accountAddress: cachedDNSRootAddress.value),
            name: domain,
            category: Data(sha.finalize()).base64EncodedString(),
            ttl: 10
        )

        do {
            let resolvedName = try await client.execute(resolveRequest)

            for entry in resolvedName.entries {
                if case let .dnsEntryDataSmcAddress(address) = entry.entry {
                    return .init(address.smcAddress.accountAddress)
                }
            }

            return nil
        } catch {
            // get method failed -> there is no address
            return nil
        }
    }

    public func initQuery(
        walletInfo: WalletInfo,
        destination: Address,
        amount: Nanogram,
        sendMode: Int32 = 3,
        message: String? = nil
    ) async throws -> Swift.Int64 {
        let rawAccount = try await client.execute(
            RawGetAccountState(accountAddress: .init(accountAddress: walletInfo.address.value))
        )

        let code: Bytes
        let data: Bytes
        if rawAccount.code.isEmpty || rawAccount.data.isEmpty {
            let wallet = WalletFactory.makeWallet(
                type: walletInfo.type,
                workchain: 0,
                walletID: walletInfo.walletID,
                publicKey: walletInfo.credentials.publicKey
            )

            code = try wallet.code.serializeAsBoC(hasCRC32: true)
            data = try wallet.data.serializeAsBoC(hasCRC32: true)
        } else {
            code = rawAccount.code
            data = rawAccount.data
        }

        let initialAccountState = RawInitialAccountState(code: code, data: data)
        let message = message.flatMap { $0.data(using: .utf8) } ?? .init()

        let query = CreateQuery(
            privateKey: .inputKeyRegular(
                .init(
                    key: .init(
                        publicKey: walletInfo.credentials.publicKey.encryptedKey,
                        secret: walletInfo.credentials.secretKey
                    ),
                    localPassword: .init()
                )
            ),
            address: .init(accountAddress: walletInfo.address.value),
            timeout: 300,
            action: .actionMsg(
                .init(
                    messages: [
                        .init(
                            destination: .init(accountAddress: destination.value),
                            publicKey: walletInfo.credentials.publicKey.encryptedKey,
                            amount: .init(amount.value),
                            data: .msgDataText(.init(text: message)),
                            sendMode: sendMode
                        )
                    ],
                    allowSendToUninited: true
                )
            ),
            initialAccountState: .rawInitialAccountState(initialAccountState)
        )

        let queryInfo = try await client.execute(query)

        return queryInfo.id
    }

    public func getEstimatedFee(for queryID: Swift.Int64) async throws -> Nanogram {
        let feesRequest = QueryEstimateFees(id: queryID, ignoreChksig: true)
        let result = try await client.execute(feesRequest)

        let sum: Swift.Int64 = result.sourceFees.storageFee
            + result.sourceFees.fwdFee
            + result.sourceFees.gasFee
            + result.sourceFees.inFwdFee

        return .init(sum)
    }

    public func sendQuery(with queryID: Swift.Int64) async throws {
        let sendMessage = QuerySend(id: queryID)
        _ = try await client.execute(sendMessage)
    }

    public func pollForNewTransaction(
        sourceAddress: Address,
        timeout: TimeInterval = 60.0
    ) async throws -> Bool {
        let deadline = Date(timeIntervalSinceNow: timeout)

        let lastTransactionHash = try await client.execute(
            GetAccountState(accountAddress: .init(accountAddress: sourceAddress.value))
        ).lastTransactionId.hash

        while true {
            if deadline < Date() {
                return false
            }

            let stateRequest = GetAccountState(accountAddress: .init(accountAddress: sourceAddress.value))
            let state = try await client.execute(stateRequest)

            if state.lastTransactionId.hash != lastTransactionHash {
                return true
            }

            try await Task.sleep(nanoseconds: 3 * 1_000_000_000)

            try Task.checkCancellation()
        }
    }

    public func getMnemonicSuggestions(prefix: String) async throws -> [String] {
        let response = try await client.execute(GetBip39Hints(prefix: prefix))
        return response.words
    }

    public func isAddressValid(_ address: String) async throws -> Bool {
        do {
            _ = try await client.execute(UnpackAccountAddress(accountAddress: address))
            return true
        } catch {
            if let error = error as? TONSchema.Error, error.message.contains("INVALID_ACCOUNT_ADDRESS") {
                return false
            }

            throw error
        }

    }
}
