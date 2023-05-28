//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import SwiftUI
import TON
import TONClient
import CommonServices
import Combine

enum MainViewState {
    case preparing(didPresentWizard: Bool)
    case loading
    case idle(Model)

    struct Model {
        var isLoading: Bool
        var canLoadMore: Bool
        let balance: FormattedGram
        let address: (full: String, short: String)
        var transactions: [TransactionListModel]
        var fiatBalance: FiatBalance?

        func with(mutation: (inout Model) -> Void) -> Model {
            var new = self
            mutation(&new)
            return new
        }
    }

    struct FiatBalance {
        let value: String
    }

    enum TransactionListModel: Identifiable {
        case date(String)
        case transaction(Info)

        struct Info {
            let id: String
            let isIncome: Bool
            let amount: FormattedGram
            let address: String
            let fee: FormattedGram
            let time: String
            let message: String?
            fileprivate let _rawTransaction: TON.Transaction
        }

        var id: String {
            switch self {
            case let .date(date):
                return "date_\(date)"
            case let .transaction(model):
                return "transaction_\(model.id)"
            }
        }
    }
}

struct PaginationState {
    var isInLoading: Bool
    var lastTransactionID: TransactionID?
}

final class MainViewModel: ObservableObject {
    weak var output: MainModuleOutput?

    private var isInitialized = false
    private var paginationState = PaginationState(isInLoading: false)
    private var walletInfo: WalletInfo?
    private var activeCurrency: Currency?
    private var cancellables = Set<AnyCancellable>()

    private let configService: ConfigService
    private let tonService: TONService
    private let conversionRateService: ConversionRateService

    @Published var state: MainViewState = .preparing(didPresentWizard: false)

    init(
        configService: ConfigService,
        tonService: TONService,
        conversionRateService: ConversionRateService,
        sharedUpdateService: SharedUpdateService
    ) {
        self.configService = configService
        self.tonService = tonService
        self.conversionRateService = conversionRateService

        bindForUpdate(sharedUpdateService: sharedUpdateService)
    }

    private func bindForUpdate(sharedUpdateService: SharedUpdateService) {
        sharedUpdateService.transactionListUpdateNeeded.sink { [weak self] _ in
            Task { [weak self] in
                await self?.loadTransactionsAndBalance()
            }
        }.store(in: &cancellables)
    }
}

extension MainViewModel {
    func showReceive() {
        guard let walletInfo else {
            return
        }

        output?.showReceive(walletInfo: walletInfo)
    }

    func showSend() {
        output?.showSend()
    }
}

extension MainViewModel {
    func loadInitial() {
        guard !isInitialized else {
            return
        }

        isInitialized = true

        configService.configPublisher
            .sink { [weak self] config in
                guard let self else {
                    return
                }

                let needUpdate = self.walletInfo?.uuid != config.lastUsedWalletID
                    || self.activeCurrency != config.fiatCurrency

                if let walletInfo = config.lastUsedWallet, needUpdate {
                    self.walletInfo = walletInfo
                    self.activeCurrency = config.fiatCurrency

                    Task {
                        await self.loadTransactionsAndBalance()
                    }
                } else if config.lastUsedWalletID == nil, needUpdate {
                    if case let .preparing(didPresentWizard) = self.state, didPresentWizard {
                        return
                    }

                    self.state = .preparing(didPresentWizard: true)
                    self.output?.showWizard()
                }
            }
            .store(in: &cancellables)
    }

    @MainActor
    func loadTransactionsAndBalance() async {
        guard let walletInfo else { return }

        switch state {
        case .preparing, .loading:
            state = .loading
        case .idle:
            try? await Task.sleep(nanoseconds: 5 * 100_000_000) // for fast refresh, but need debounce
        }

        let rates = try? await Task {
            try await conversionRateService.getRates()
        }.value

        do {
            let walletState = try await Task {
                try await tonService.fetchWalletState(address: walletInfo.address)
            }.value

            let transactions = try await Task {
                return try await tonService.fetchTransactions(
                    address: walletInfo.address,
                    fromTransaction: walletState.lastTransactionID
                )
            }.value

            let fiatBalance: MainViewState.FiatBalance?
            if let activeCurrency {
                fiatBalance = rates?[activeCurrency]
                    .flatMap { walletState.balance.convert(with: $0) }
                    .flatMap { MainViewState.FiatBalance.make(from: $0, currency: activeCurrency) }
            } else {
                fiatBalance = nil
            }

            let model = MainViewState.Model(
                isLoading: false,
                canLoadMore: transactions.lastTransaction != nil,
                balance: walletState.balance.formatted,
                address: (walletInfo.address.value, walletInfo.address.shortened()),
                transactions: MainViewState.TransactionListModel.makeList(
                    from: transactions.transactions,
                    myAddress: walletInfo.address
                ),
                fiatBalance: fiatBalance
            )

            state = .idle(model)
            paginationState = .init(isInLoading: false, lastTransactionID: transactions.lastTransaction)
        } catch {
            if error is TONClient.InvalidLiteServerError {
                try? await tonService.reloadConfig()
                await loadTransactionsAndBalance()
            }
            
            print("[Transactions load error]", error)
        }
    }

    @MainActor
    func refresh() async {
        guard !paginationState.isInLoading, case let .idle(model) = state, !model.isLoading else {
            return
        }

        await loadTransactionsAndBalance()
    }

    @MainActor
    func loadMoreTransactions() async {
        guard let lastTransaction = paginationState.lastTransactionID, let walletInfo else {
            return
        }

        paginationState.isInLoading = true
        defer {
            paginationState.isInLoading = false
        }

        do {
            let result: (TransactionID?, MainViewState)? = try await Task {
                let transactions = try await tonService.fetchTransactions(
                    address: walletInfo.address,
                    fromTransaction: lastTransaction
                )

                let newTransactions = MainViewState.TransactionListModel.makeList(
                    from: transactions.transactions,
                    myAddress: walletInfo.address
                )

                if case let .idle(model) = state {
                    var uniqueDateSeparators = Set<String>()
                    let allTransactions = (model.transactions + newTransactions).filter { transaction in
                        switch transaction {
                        case let .date(date):
                            if uniqueDateSeparators.contains(date) {
                                return false
                            }
                            uniqueDateSeparators.insert(date)
                            return true
                        default:
                            return true
                        }
                    }

                    let newModel = model.with {
                        $0.transactions = allTransactions
                        $0.canLoadMore = transactions.lastTransaction != nil
                    }
                    return (transactions.lastTransaction, MainViewState.idle(newModel))
                }

                return nil
            }.value

            if let result {
                paginationState.lastTransactionID = result.0
                state = result.1
            }
        } catch {
            if error is TONClient.InvalidLiteServerError {
                try? await tonService.reloadConfig()
                await loadMoreTransactions()
            }

            print("[Transactions load error]", error)
        }
    }

    @MainActor
    func showTransactionDetail(id: String) {
        guard case let .idle(model) = state else {
            return
        }

        guard let item = model.transactions.first(where: { $0.id == id }),
              case let .transaction(transaction) = item else {
            return
        }

        output?.showTransaction(transaction._rawTransaction)
    }

    @MainActor
    func showScanner() {
        output?.showScanner()
    }

    @MainActor
    func showSettings() {
        output?.showSettings()
    }
}

extension MainViewState.FiatBalance {
    static func make(from value: Double, currency: Currency) -> MainViewState.FiatBalance? {
        if value.isEqual(to: 0.0) {
            return nil
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency.rawValue
        formatter.maximumFractionDigits = 2

        return .init(value: formatter.string(from: value as NSNumber) ?? "\(value) \(currency.rawValue)")
    }
}

extension MainViewState.TransactionListModel {
    static func makeList(
        from transactions: [TON.Transaction],
        myAddress: Address
    ) -> [MainViewState.TransactionListModel] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "en_US")
        dateFormatter.dateFormat = "MMMM dd"

        let timeFormatter = DateFormatter()
        timeFormatter.locale = .init(identifier: "en_US")
        timeFormatter.dateFormat = "h:mm a"

        var date: String?
        var items: [MainViewState.TransactionListModel] = []

        for transaction in transactions {
            let isIncome = transaction.isIncome
            if (isIncome && transaction.sender.value.isEmpty) || (!isIncome && transaction.receiver.value.isEmpty) {
                continue
            }

            let transactionDate = dateFormatter.string(from: transaction.date)

            if date != transactionDate {
                items.append(.date(transactionDate))
                date = transactionDate
            }

            let address = isIncome
                ? transaction.sender.shortened(partLength: 5)
                : transaction.receiver.shortened(partLength: 5)

            let item = MainViewState.TransactionListModel.Info(
                id: "\(transaction.id.lt)",
                isIncome: isIncome,
                amount: transaction.amount.formatted,
                address: address,
                fee: transaction.fee.formatted,
                time: timeFormatter.string(from: transaction.date),
                message: transaction.message,
                _rawTransaction: transaction
            )

            items.append(.transaction(item))
        }

        return items
    }
}

extension String {
    fileprivate var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}
