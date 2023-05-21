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
    public var hasInsufficientFunds = false
    public var fee: Nanogram?
    public var comment: String?

    static func makeInitial(with predefinedParams: PredefinedStateParameters) -> SendState {
        .init(
            address: predefinedParams.address.flatMap { .init($0) },
            amount: predefinedParams.amount.flatMap { .init(max(0, $0)) },
            comment: predefinedParams.comment
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
    private let tonService: TONService
    private let configService: ConfigService
    private let biometricService: BiometricService
    private let deeplinkService: DeeplinkService

    @Published public var state: SendState

    public weak var output: SendViewModelOutput?

    public init(
        predefinedParameters: PredefinedStateParameters = .init(),
        tonService: TONService,
        configService: ConfigService,
        biometricService: BiometricService,
        deeplinkService: DeeplinkService
    ) {
        self.tonService = tonService
        self.state = .makeInitial(with: predefinedParameters)
        self.configService = configService
        self.biometricService = biometricService
        self.deeplinkService = deeplinkService
    }
}

extension SendViewModel {
    @MainActor
    public func submit(address: String) async {
        guard !address.isEmpty, !state.isLoading,
              let currentAddress = configService.lastKnownWallet.walletInfo?.address else {
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
            state.address = .init(address)
        }

        let walletState = try! await Task {
            try await tonService.fetchWalletState(address: currentAddress)
        }.value

        state.balance = walletState.balance

        output?.showAmountInput()
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
    public func submit(amount: String) async {
        guard !state.hasInsufficientFunds, !state.isLoading, let value = amount.asDouble,
              let walletInfo = configService.lastKnownWallet.walletInfo,
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

        let queryID = try! await tonService.initQuery(walletInfo: walletInfo, destination: destination, amount: amount)
        let fee = try! await tonService.getEstimatedFee(for: queryID)

        state.fee = fee

        output?.showConfirmInput()
    }

    @MainActor
    public func confirmTransaction(comment: String) async {
        guard !state.isLoading else {
            return
        }

        state.comment = comment.isEmpty ? nil : comment

        let credentials = configService.config.value.securityConfirmation

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
        guard let walletInfo = configService.lastKnownWallet.walletInfo else {
            return
        }

        output?.showTransactionWaiting()

        _ = try! await tonService.pollForNewTransaction(sourceAddress: walletInfo.address)

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

            self.state = .makeInitial(with: .init(address: address, amount: amount, comment: comment))
        }
    }

    // MARK: - Private

    @MainActor
    private func sendTransaction() async {
        guard !state.isLoading, let amount = state.amount, let destination = state.address,
              let walletInfo = configService.lastKnownWallet.walletInfo else {
            return
        }

        state.isLoading = true

        let queryID = try! await tonService.initQuery(
            walletInfo: walletInfo,
            destination: destination,
            amount: amount,
            message: state.comment
        )

        try! await tonService.sendQuery(with: queryID)

        state.isLoading = false

        await showWaitingState()
    }
}

extension String {
    fileprivate var asDouble: Double? {
        Double(replacingOccurrences(of: ",", with: "."))
    }
}
