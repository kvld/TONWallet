//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import Foundation
import Combine
import TON

public struct SendState {
    public var address: Address?
    public var domain: String?
    public var isLoading: Bool = false
    public var balance: Nanogram?
    public var amount: Nanogram?
    public var hasInsufficientFunds = false
    public var fee: Nanogram?

    static var initial: SendState = .init()
}

@MainActor
public protocol SendViewModelOutput: AnyObject {
    func showAmountInput()
    func showConfirmInput()
    func showTransactionWaiting()
    func showTransactionCompleted()
}

public final class SendViewModel: ObservableObject {
    private let tonService: TONService
    private let walletInfoService: WalletInfoService

    @Published public var state: SendState

    public weak var output: SendViewModelOutput?

    public init(tonService: TONService, walletInfoService: WalletInfoService) {
        self.tonService = tonService
        self.state = .initial
        self.walletInfoService = walletInfoService
    }
}

extension SendViewModel {
    @MainActor
    public func submit(address: String) async {
        guard !address.isEmpty, !state.isLoading,
              let currentAddress = walletInfoService.lastKnownWallet.walletInfo?.address else {
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
        guard let value = Double(amount) else {
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
        guard !state.hasInsufficientFunds, !state.isLoading, let value = Double(amount),
              let walletInfo = walletInfoService.lastKnownWallet.walletInfo,
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
    public func confirmAndSendTransaction() async {
        guard !state.isLoading, let amount = state.amount, let destination = state.address,
              let walletInfo = walletInfoService.lastKnownWallet.walletInfo else {
            return
        }

        state.isLoading = true

        let queryID = try! await tonService.initQuery(walletInfo: walletInfo, destination: destination, amount: amount)

        try! await tonService.sendQuery(with: queryID)

        state.isLoading = false

        await showWaitingState()
    }

    @MainActor
    public func showWaitingState() async {
        guard let walletInfo = walletInfoService.lastKnownWallet.walletInfo else {
            return
        }

        output?.showTransactionWaiting()

        _ = try! await tonService.pollForNewTransaction(sourceAddress: walletInfo.address)

        output?.showTransactionCompleted()
    }
}
