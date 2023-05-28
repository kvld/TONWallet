//
//  Created by Vladislav Kiriukhin on 30.04.2023.
//

import UIKit
import SendState
import SendAddress
import SendConfirm
import CommonServices

@MainActor
final class SendRouter: Router, SendViewModelOutput {
    private let _navigationRouter: NavigationRouter
    private weak var parentNavigationRouter: NavigationRouter?

    private let viewModel: SendViewModel

    var viewController: UIViewController {
        _navigationRouter.viewController
    }

    init(predefinedParameters: PredefinedStateParameters = .init(), parentNavigationRouter: NavigationRouter) {
        let viewModel = SendViewModel(
            predefinedParameters: predefinedParameters,
            tonService: resolve(),
            configService: resolve(),
            biometricService: resolve(),
            deeplinkService: resolve(),
            historyService: resolve(),
            sharedUpdateService: resolve()
        )

        let navigationRouter = NavigationRouter { controller in
            controller.navigationBar.isHidden = true
        }

        let sendInitialRouter = SendAddressRouter(viewModel: viewModel, parentNavigationRouter: parentNavigationRouter)

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
        guard let parentNavigationRouter else {
            return
        }

        let sendConfirmRouter = SendCompletionRouter(
            stage: .waiting,
            viewModel: viewModel,
            parentNavigationRouter: parentNavigationRouter
        )
        _navigationRouter.push(router: sendConfirmRouter)
    }

    func showTransactionCompleted() {
        guard let parentNavigationRouter else {
            return
        }

        let sendConfirmRouter = SendCompletionRouter(
            stage: .completed,
            viewModel: viewModel,
            parentNavigationRouter: parentNavigationRouter
        )
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

    func showScanner(onSuccess: @escaping (String) -> Void) {
        let router = QRScannerRouter(parentNavigationRouter: _navigationRouter) { result in
            onSuccess(result)
        }

        _navigationRouter.present(router: router, overModal: true)
    }
}
