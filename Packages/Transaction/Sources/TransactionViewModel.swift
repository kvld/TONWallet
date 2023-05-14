//
//  Created by Vladislav Kiriukhin on 14.05.2023.
//

import SwiftUI
import TON

final class TransactionViewModel: ObservableObject {
    private var fullTransactionID: String

    weak var output: TransactionModuleOutput?

    @Published var amountInteger: String
    @Published var amountFractional: String?
    @Published var fee: String
    @Published var date: String
    @Published var message: String?
    @Published var isIncome: Bool
    @Published var address: String
    @Published var transactionID: String

    init(transaction: TON.Transaction) {
        amountInteger = transaction.amount.formatted.integer
        amountFractional = transaction.amount.formatted.formattedFractionalOrEmpty.nilIfEmpty
        fee = transaction.fee.formatted.formatted

        date = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .short
            formatter.locale = .init(identifier: "en_US")
            return formatter.string(from: transaction.date)
        }()

        message = transaction.message

        isIncome = transaction.isIncome
        address = transaction.isIncome ? transaction.sender.shortened() : transaction.receiver.shortened()
        transactionID = transaction.id.hash.base64EncodedString().urlSafeBase64().shortenedTransaction()
        fullTransactionID = transaction.id.hash.base64EncodedString().urlSafeBase64()
    }

    @MainActor
    func showTransactionInExplorer() {
        output?.showTransactionInExplorer(id: fullTransactionID)
    }
}

extension String {
    fileprivate var nilIfEmpty: String? {
        isEmpty ? nil : self
    }

    fileprivate func urlSafeBase64() -> String {
        replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: "+", with: "-")
    }

    fileprivate func shortenedTransaction() -> String {
        String(prefix(6)) + "…" + String(suffix(6))
    }
}
