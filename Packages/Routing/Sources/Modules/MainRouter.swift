//
//  Created by Vladislav Kiriukhin on 24.03.2023.
//

import Foundation
import Main
import SwiftUI
import WizardState
import SendState
import TON
import CommonServices

public final class MainRouter: HostingRouter<AnyView, MainModule> {
    private weak var parentNavigationRouter: NavigationRouter?

    public init(parentNavigationRouter: NavigationRouter) {
        self.parentNavigationRouter = parentNavigationRouter

        let module = MainModule()
        super.init(view: module.view, module: module)

        module.output = self
    }
}

extension MainRouter: MainModuleOutput {
    public func showWizard() {
        guard let parentNavigationRouter else {
            return
        }

        let router = WizardRouter(parentNavigationRouter: parentNavigationRouter)
        parentNavigationRouter.present(router: router)
    }

    public func showReceive(walletInfo: WalletInfo) {
        guard let parentNavigationRouter else {
            return
        }

        let router = ReceiveRouter(parentNavigationRouter: parentNavigationRouter, walletInfo: walletInfo)
        parentNavigationRouter.present(router: router)
    }

    public func showSend() {
        guard let parentNavigationRouter else {
            return
        }

        let router = SendRouter(parentNavigationRouter: parentNavigationRouter)
        parentNavigationRouter.present(router: router)
    }

    public func showTransaction(_ transaction: TON.Transaction) {
        guard let parentNavigationRouter else {
            return
        }

        let router = TransactionRouter(transaction: transaction, parentNavigationRouter: parentNavigationRouter)
        parentNavigationRouter.present(router: router)
    }

    public func showScanner() {
        guard let parentNavigationRouter else {
            return
        }

        let router = QRScannerRouter(parentNavigationRouter: parentNavigationRouter) {
            if let url = URL(string: $0), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        parentNavigationRouter.present(router: router)
    }

    public func showSettings() {
        guard let parentNavigationRouter else {
            return
        }

        let navigationRouter = NavigationRouter { controller in
            controller.navigationBar.isHidden = true
        }

        let router = SettingsRouter(navigationRouter: navigationRouter, parentNavigationRouter: parentNavigationRouter)

        navigationRouter.embed(router: router)
        parentNavigationRouter.present(router: navigationRouter)
    }
}
