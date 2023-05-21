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
        guard url.scheme == "ton" else {
            return
        }

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return
        }

        switch components.host {
        case "transfer":
            handleTransfer(components: components)
        default:
            break
        }
    }

    @MainActor
    private func handleTransfer(components: URLComponents) {
        guard let presentingRouter else {
            return
        }

        let predefinedParameters = PredefinedStateParameters(
            address: components.path.first == "/" ? String(components.path.dropFirst()) : components.path,
            amount: components.queryItems?.first(where: { $0.name == "amount" })?.value.flatMap { Int64($0) },
            comment: components.queryItems?.first(where: { $0.name == "text" })?.value?.removingPercentEncoding
        )

        let viewModel = SendViewModel(
            predefinedParameters: predefinedParameters,
            tonService: resolve(),
            configService: resolve(),
            biometricService: resolve()
        )

        let router = SendRouter(viewModel: viewModel, parentNavigationRouter: presentingRouter)
        presentingRouter.present(router: router, overModal: true)
    }
}
