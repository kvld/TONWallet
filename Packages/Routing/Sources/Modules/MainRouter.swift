//
//  Created by Vladislav Kiriukhin on 24.03.2023.
//

import Foundation
import Main
import SwiftUI

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
}
