//
//  Created by Vladislav Kiriukhin on 14.05.2023.
//

import Foundation
import SwiftUI
import SwiftUIHelpers
import TON

public protocol TransactionModuleOutput: AnyObject {
    func showTransactionInExplorer(id: String)
    func sendToAddress(address: Address, amount: Nanogram?)
}

public final class TransactionModule {
    public let view: AnyView
    private let viewModel: TransactionViewModel

    public var output: TransactionModuleOutput? {
        get {
            viewModel.output
        }
        set {
            viewModel.output = newValue
        }
    }
    
    public init(transaction: TON.Transaction, onClose: @escaping () -> Void) {
        let viewModel = TransactionViewModel(transaction: transaction)
        self.view = TransactionView(viewModel: viewModel, onClose: onClose).eraseToAnyView()
        self.viewModel = viewModel
    }
}
