//
//  Created by Vladislav Kiriukhin on 14.05.2023.
//

import SwiftUI
import TON

final class TransactionViewModel: ObservableObject {
    private let fullTransactionID: String
    private let amount: Nanogram
    private let fullAddress: Address

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
        amount = transaction.amount
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

        let _fullAddress = transaction.isIncome ? transaction.sender : transaction.receiver
        fullAddress = _fullAddress
        address = _fullAddress.shortened()

        transactionID = transaction.id.hash.base64EncodedString().urlSafeBase64().shortenedTransaction()
        fullTransactionID = transaction.id.hash.base64EncodedString().urlSafeBase64()
    }

    @MainActor
    func showTransactionInExplorer() {
        output?.showTransactionInExplorer(id: fullTransactionID)
    }

    @MainActor
    func sendToAddress() {
        output?.sendToAddress(address: fullAddress, amount: isIncome ? nil : amount)
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
