//
//  Created by Vladislav Kiriukhin on 14.05.2023.
//

import Foundation
import SwiftUI
import TON
import Transaction
import CommonServices
import SendState

final class TransactionRouter: SheetHostingRouter<AnyView, TransactionModule> {
    private weak var parentNavigationRouter: NavigationRouter?

    init(transaction: TON.Transaction, parentNavigationRouter: NavigationRouter) {
        self.parentNavigationRouter = parentNavigationRouter

        let module = TransactionModule(transaction: transaction)
        super.init(view: module.view, module: module)

        module.output = self
    }
}

extension TransactionRouter: TransactionModuleOutput {
    func showTransactionInExplorer(id: String) {
        if let url = URL(string: "https://tonscan.org/tx/\(id)") {
           UIApplication.shared.open(url)
        }
    }

    func sendToAddress(address: Address, amount: Nanogram?) {
        guard let parentNavigationRouter else {
            return
        }

        let predefinedParameters = PredefinedStateParameters(
            address: address.value,
            amount: amount?.value
        )

        let router = SendRouter(
            predefinedParameters: predefinedParameters,
            parentNavigationRouter: parentNavigationRouter
        )

        parentNavigationRouter.dismissTopmost { [weak parentNavigationRouter] in
            parentNavigationRouter?.present(router: router)
        }
    }
}
