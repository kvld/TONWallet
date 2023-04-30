//
//  Created by Vladislav Kiriukhin on 30.04.2023.
//

import Foundation
import SwiftUI
import TON
import Receive

final class ReceiveRouter: HostingRouter<AnyView, ReceiveModule> {
    private weak var parentNavigationRouter: NavigationRouter?

    init(parentNavigationRouter: NavigationRouter, walletInfo: WalletInfo) {
        self.parentNavigationRouter = parentNavigationRouter

        let module = ReceiveModule(walletInfo: walletInfo)
        super.init(view: module.view, module: module)

        module.output = self
    }
}

extension ReceiveRouter: ReceiveModuleOutput {
    func share(url: URL) {
        let router = ShareRouter()
        router.url = url
        parentNavigationRouter?.present(router: router, overModal: true)
    }
}

private final class ShareRouter: Router {
    var url: URL?

    lazy var viewController: UIViewController = {
        UIActivityViewController(
            activityItems: url.flatMap { [$0] } ?? [],
            applicationActivities: nil
        )
    }()
}
