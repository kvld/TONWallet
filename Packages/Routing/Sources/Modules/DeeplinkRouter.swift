//
//  Created by Vladislav Kiriukhin on 21.05.2023.
//

import Foundation
import TON
import CommonServices
import SendState

public final class DeeplinkRouter {
    private weak var presentingRouter: NavigationRouter?

    public init(presentingRouter: NavigationRouter) {
        self.presentingRouter = presentingRouter
    }

    @MainActor
    public func handleDeeplink(for url: URL) {
        let service: DeeplinkService = resolve()

        switch service.handleDeeplink(for: url) {
        case .none:
            return
        case let .transfer(address, amount, comment):
            handleTransfer(address: address, amount: amount, comment: comment)
        }
    }

    @MainActor
    private func handleTransfer(address: String?, amount: Int64?, comment: String?) {
        guard let presentingRouter else {
            return
        }

        let predefinedParameters = PredefinedStateParameters(
            address: address,
            amount: amount,
            comment: comment
        )

        let router = SendRouter(predefinedParameters: predefinedParameters, parentNavigationRouter: presentingRouter)
        presentingRouter.present(router: router, overModal: true)
    }
}
