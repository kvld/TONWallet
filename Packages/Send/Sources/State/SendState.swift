//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import Foundation
import Combine
import TON
import CommonServices

public struct SendState {
    public var address: Address?
    public var domain: String?
    public var isLoading: Bool = false
    public var balance: Nanogram?
    public var amount: Nanogram?
    public var sendFullAmount = false
    public var hasInsufficientFunds = false
    public var fee: Nanogram?
    public var comment: String?
    public var history: [HistoryEntry] = []
    public var error: Error?

    public struct Error {
        public let title: String
        public let error: String
    }

    public struct HistoryEntry {
        public let address: String
        public let domain: String?
        public let date: String
        fileprivate let _address: Address
    }

    static func makeInitial(
        with predefinedParams: PredefinedStateParameters,
        history: [HistoryEntry]
    ) -> SendState {
        .init(
            address: predefinedParams.address.flatMap { .init($0) },
            amount: predefinedParams.amount.flatMap { .init(max(0, $0)) },
            comment: predefinedParams.comment,
            history: history
        )
    }
}

@MainActor
public protocol SendViewModelOutput: AnyObject {
    func showAmountInput()
    func showConfirmInput()
    func showTransactionWaiting()
    func showTransactionCompleted()
    func showPasscodeConfirmation(passcode: String, onSuccess: @escaping () -> Void)
    func showScanner(onSuccess: @escaping (String) -> Void)
}

public struct PredefinedStateParameters {
    public let address: String?
    public let amount: Int64?
    public let comment: String?

    public init(
        address: String? = nil,
        amount: Int64? = nil,
        comment: String? = nil
    ) {
        self.address = address
        self.amount = amount
        self.comment = comment
    }
}

public final class SendViewModel: ObservableObject {
    private static var historyMaxCount: Int { 5 }

    private let tonService: TONService
    private let configService: ConfigService
    private let biometricService: BiometricService
    private let deeplinkService: DeeplinkService
    private let historyService: SendHistoryService
    private let sharedUpdateService: SharedUpdateService

    @Published public var state: SendState

    public weak var output: SendViewModelOutput?

    public init(
        predefinedParameters: PredefinedStateParameters = .init(),
        tonService: TONService,
        configService: ConfigService,
        biometricService: BiometricService,
        deeplinkService: DeeplinkService,
        historyService: SendHistoryService,
        sharedUpdateService: SharedUpdateService
    ) {
        self.tonService = tonService

        self.state = .makeInitial(
            with: predefinedParameters,
            history: historyService.getHistory().prefix(Self.historyMaxCount).map(\.viewModel)
        )

        self.configService = configService
        self.biometricService = biometricService
        self.deeplinkService = deeplinkService
        self.historyService = historyService
        self.sharedUpdateService = sharedUpdateService
    }
}

extension SendViewModel {
    @MainActor
    public func submit(address: String) async {
        guard !address.isEmpty, !state.isLoading,
              let currentAddress = configService.config.lastUsedWallet?.address else {
            return
        }

        state.isLoading = true
        defer {
            state.isLoading = false
        }

        if address.hasSuffix(".ton") {
            let resolvedAddress = try? await Task {
                try await tonService.resolveDNS(domain: address)
            }.value

            guard let resolvedAddress else {
                return
            }

            state.address = resolvedAddress
            state.domain = address
        } else {
            let isAddressValid = (try? await tonService.isAddressValid(address)) ?? false
            if !isAddressValid {
                state.error = .init(title: "Invalid address", error: "Address entered does not belong to TON")
                return
            }

            state.address = .init(address)
        }

        do {
            let walletState = try await Task {
                try await tonService.fetchWalletState(address: currentAddress)
            }.value

            state.balance = walletState.balance

            output?.showAmountInput()
        } catch {
            state.error = .init(title: "Sending error", error: "Wallet is unavailable. Try again later")
        }
    }

    @MainActor
    public func updateAmount(with amount: String) {
        guard let value = amount.asDouble else {
            state.hasInsufficientFunds = false
            return
        }

        let nanos = Int64(value * 1_000_000_000)

        state.amount = .init(nanos)

        if let balance = state.balance?.value, nanos > balance {
            state.hasInsufficientFunds = true
        } else {
            state.hasInsufficientFunds = false
        }
    }

    @MainActor
    public func updateAmount(useFullBalance: Bool) {
        state.sendFullAmount = useFullBalance
    }

    @MainActor
    public func submit(amount: String) async {
        guard !state.hasInsufficientFunds, !state.isLoading, let value = amount.asDouble,
              let walletInfo = configService.config.lastUsedWallet,
              let destination = state.address else {
            return
        }

        state.isLoading = true
        defer {
            state.isLoading = false
        }

        let nanos = Int64(value * 1_000_000_000)
        let amount = Nanogram(nanos)

        state.amount = amount

        do {
            let queryID = try await tonService.initQuery(
                walletInfo: walletInfo,
                destination: destination,
                amount: amount == state.balance ? .init(amount.value - 1) : amount // strange hack to prevent NOT_ENOUGH_FUNDS
            )

            let fee = try await tonService.getEstimatedFee(for: queryID)

            state.fee = fee

            output?.showConfirmInput()
        } catch {
            state.error = .init(title: "Sending error", error: "Unable to calculate transaction fee")
        }
    }

    @MainActor
    public func confirmTransaction(comment: String) async {
        guard !state.isLoading else {
            return
        }

        state.comment = comment.isEmpty ? nil : comment

        let credentials = configService.config.securityConfirmation

        if biometricService.isSupportBiometric, credentials.isBiometricEnabled {
            let result = await biometricService.evaluate()
            if !result {
                output?.showPasscodeConfirmation(passcode: credentials.passcode) { [weak self] in
                    Task { await self?.sendTransaction() }
                }
            } else {
                await sendTransaction()
            }
        } else {
            output?.showPasscodeConfirmation(passcode: credentials.passcode) { [weak self] in
                Task { await self?.sendTransaction() }
            }
        }
    }

    @MainActor
    public func showWaitingState() async {
        guard let walletInfo = configService.config.lastUsedWallet else {
            return
        }

        output?.showTransactionWaiting()

        _ = try? await tonService.pollForNewTransaction(sourceAddress: walletInfo.address)

        sharedUpdateService.markAsTransactionListUpdateNeeded()

        output?.showTransactionCompleted()
    }

    @MainActor
    public func scanForTransferLink() {
        output?.showScanner { [weak self] result in
            guard let self,
                let url = URL(string: result),
                case let .transfer(address, amount, comment) = self.deeplinkService.handleDeeplink(for: url) else {
                return
            }

            self.state = .makeInitial(
                with: .init(address: address, amount: amount, comment: comment),
                history: self.historyService.getHistory().prefix(Self.historyMaxCount).map(\.viewModel)
            )
        }
    }

    @MainActor
    public func clearHistory() {
        historyService.clear()
        state.history = []
    }

    @MainActor
    public func fillWithHistoryEntry(with idx: Int) {
        let entry = state.history[idx]

        self.state = .makeInitial(
            with: .init(address: entry._address.value),
            history: self.historyService.getHistory().prefix(Self.historyMaxCount).map(\.viewModel)
        )
    }

    // MARK: - Private

    @MainActor
    private func sendTransaction() async {
        guard !state.isLoading, let amount = state.amount, let destination = state.address,
              let walletInfo = configService.config.lastUsedWallet else {
            return
        }

        state.isLoading = true

        do {
            let queryID = try await tonService.initQuery(
                walletInfo: walletInfo,
                destination: destination,
                amount: amount,
                message: state.comment
            )

            try await tonService.sendQuery(with: queryID)

            historyService.add(entry: .init(address: destination, domain: state.domain, date: .init()))

            state.isLoading = false

            await showWaitingState()
        } catch {
            state.error = .init(title: "Sending error", error: "Try again later")
            state.isLoading = false
        }
    }
}

extension String {
    fileprivate var asDouble: Double? {
        Double(replacingOccurrences(of: ",", with: "."))
    }
}

extension SendHistoryEntry {
    fileprivate var viewModel: SendState.HistoryEntry {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.locale = .init(identifier: "en_US")

        return .init(
            address: address.shortened(partLength: 4),
            domain: domain,
            date: formatter.string(from: date),
            _address: address
        )
    }
}
