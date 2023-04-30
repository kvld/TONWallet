//
//  Created by Vladislav Kiriukhin on 24.03.2023.
//

import Foundation
import Main
import SwiftUI
import WizardState
import TON

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

        let tonService = TONService(
            storage: .init(),
            configURL: URL(string: "https://ton.org/testnet-global.config.json")!
        )
        let walletInfoService = WalletInfoService(storage: .init())

        let viewModel = WizardViewModel(tonService: tonService, walletInfoService: walletInfoService)

        let router = WizardRouter(viewModel: viewModel, parentNavigationRouter: parentNavigationRouter)
        parentNavigationRouter.present(router: router)
    }

    public func showReceive(walletInfo: WalletInfo) {
        guard let parentNavigationRouter else {
            return
        }


        let router = ReceiveRouter(parentNavigationRouter: parentNavigationRouter, walletInfo: walletInfo)
        parentNavigationRouter.present(router: router)
    }
}
