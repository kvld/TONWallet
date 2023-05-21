//
//  Created by Vladislav Kiriukhin on 30.04.2023.
//

import UIKit
import SendState
import SendAddress
import SendConfirm

@MainActor
final class SendRouter: Router, SendViewModelOutput {
    private let _navigationRouter: NavigationRouter
    private weak var parentNavigationRouter: NavigationRouter?

    private let viewModel: SendViewModel

    var viewController: UIViewController {
        _navigationRouter.viewController
    }

    init(viewModel: SendViewModel, parentNavigationRouter: NavigationRouter) {
        let navigationRouter = NavigationRouter { controller in
            controller.navigationBar.isHidden = true
        }

        let sendInitialRouter = SendAddressRouter(viewModel: viewModel)

        navigationRouter.embed(router: sendInitialRouter)

        self._navigationRouter = navigationRouter
        self.parentNavigationRouter = parentNavigationRouter
        self.viewModel = viewModel

        viewModel.output = self
    }

    func showAmountInput() {
        let sendAmountRouter = SendAmountRouter(viewModel: viewModel)
        _navigationRouter.push(router: sendAmountRouter)
    }

    func showConfirmInput() {
        let sendConfirmRouter = SendConfirmRouter(viewModel: viewModel)
        _navigationRouter.push(router: sendConfirmRouter)
    }

    func showTransactionWaiting() {
        let sendConfirmRouter = SendCompletionRouter(stage: .waiting, viewModel: viewModel)
        _navigationRouter.push(router: sendConfirmRouter)
    }

    func showTransactionCompleted() {
        let sendConfirmRouter = SendCompletionRouter(stage: .completed, viewModel: viewModel)
        _navigationRouter.push(router: sendConfirmRouter)
    }

    func showPasscodeConfirmation(passcode: String, onSuccess: @escaping () -> Void) {
        guard let parentNavigationRouter else {
            return
        }

        let router = PasscodeRouter(
            passcode: passcode,
            navigationRouter: parentNavigationRouter
        ) { [weak parentNavigationRouter] in
            parentNavigationRouter?.dismissTopmost()
            onSuccess()
        }
        router.viewController.modalPresentationStyle = .overFullScreen
        parentNavigationRouter.present(router: router, overModal: true)
    }
}
