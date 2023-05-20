//
//  Created by Vladislav Kiriukhin on 14.05.2023.
//

import Foundation
import SwiftUI
import TON
import Transaction

final class TransactionRouter: SheetHostingRouter<AnyView, TransactionModule> {
    init(transaction: TON.Transaction) {
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
}
