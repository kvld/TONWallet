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
        let isLoading: Bool
        let balance: FormattedGram
        let address: (full: String, short: String)
        let transactions: [TransactionListModel]
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

final class MainViewModel: ObservableObject {
    weak var output: MainModuleOutput?

    private var isInitialized = false
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
                    Task {
                        await self.loadTransactionsAndBalance(walletInfo: walletInfo)
                    }
                } else {
                    self.output?.showWizard()
                }
            }
            .store(in: &cancellables)
    }

    @MainActor
    func loadTransactionsAndBalance(walletInfo: WalletInfo) async {
        state = .loading

        do {
            let walletState = try await Task {
                let testAddress = Address("EQBYivdc0GAk-nnczaMnYNuSjpeXu2nJS3DZ4KqLjosX5sVC")
                return try await tonService.fetchWalletState(address: testAddress)
            }.value

            let transactions = try await Task {
                let testAddress = Address("EQBYivdc0GAk-nnczaMnYNuSjpeXu2nJS3DZ4KqLjosX5sVC")
                return try await tonService.fetchTransactions(
                    address: testAddress,
                    fromTransaction: walletState.lastTransactionID
                )
            }.value

            let model = MainViewState.Model(
                isLoading: false,
                balance: walletState.balance.formatted,
                address: (walletInfo.address.value, walletInfo.address.shortened()),
                transactions: MainViewState.TransactionListModel.makeList(
                    from: transactions.transactions,
                    myAddress: walletInfo.address
                )
            )

            state = .idle(model)
        } catch {
            print("[ERROR]", error)
            // TODO: error
        }
    }
}

extension MainViewState.TransactionListModel {
    static func makeList(from transactions: [TON.Transaction], myAddress: Address) -> [MainViewState.TransactionListModel] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "en_US")
        dateFormatter.dateFormat = "MMMM dd"

        let timeFormatter = DateFormatter()
        timeFormatter.locale = .init(identifier: "en_US")
        timeFormatter.dateFormat = "HH:mm"

        var date: String?
        var items: [MainViewState.TransactionListModel] = []

        for transaction in transactions {
            let transactionDate = dateFormatter.string(from: transaction.date)

            if date != transactionDate {
                items.append(.date(transactionDate))
                date = transactionDate
            }

            let isIncome = transaction.receiver == myAddress
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
