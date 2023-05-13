//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import SwiftUI
import TON
import Combine

enum MainViewState {
    case preparing
    case loading
    case idle(Model)

    struct Model {
        var isLoading: Bool
        var canLoadMore: Bool
        let balance: FormattedGram
        let address: (full: String, short: String)
        var transactions: [TransactionListModel]

        func with(mutation: (inout Model) -> Void) -> Model {
            var new = self
            mutation(&new)
            return new
        }
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
    private var cancellables = Set<AnyCancellable>()

    private let walletInfoService: WalletInfoService
    private let tonService: TONService

    @Published var state: MainViewState = .preparing

    init(walletInfoService: WalletInfoService, tonService: TONService) {
        self.walletInfoService = walletInfoService
        self.tonService = tonService
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

        walletInfoService.walletFetchState
            .filter { !$0.isUnknown }
            .sink { [weak self] state in
                guard let self else {
                    return
                }

                if case .fetched(let walletInfo) = state, let walletInfo {
                    self.walletInfo = walletInfo

                    Task {
                        await self.loadTransactionsAndBalance()
                    }
                } else {
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

        do {
            let walletState = try await Task {
                return try await tonService.fetchWalletState(address: walletInfo.address)
            }.value

            let transactions = try await Task {
                return try await tonService.fetchTransactions(
                    address: walletInfo.address,
                    fromTransaction: walletState.lastTransactionID
                )
            }.value

            let model = MainViewState.Model(
                isLoading: false,
                canLoadMore: transactions.lastTransaction != nil,
                balance: walletState.balance.formatted,
                address: (walletInfo.address.value, walletInfo.address.shortened()),
                transactions: MainViewState.TransactionListModel.makeList(
                    from: transactions.transactions,
                    myAddress: walletInfo.address
                )
            )

            state = .idle(model)
            paginationState = .init(isInLoading: false, lastTransactionID: transactions.lastTransaction)
        } catch {
            print("[ERROR]", error)
            // TODO: error
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
            // todo: retry
        }
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
        timeFormatter.dateFormat = "HH:mm"

        var date: String?
        var items: [MainViewState.TransactionListModel] = []

        for transaction in transactions {
            let isIncome = transaction.receiver == myAddress
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
                message: transaction.message
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
