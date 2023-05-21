//
//  Created by Vladislav Kiriukhin on 14.05.2023.
//

import Foundation
import SwiftUI
import TON
import Settings
import WizardMnemonic
import WizardPasscode
import CommonServices

final class SettingsRouter: HostingRouter<AnyView, SettingsModule> {
    private weak var navigationRouter: NavigationRouter?
    private weak var parentNavigationRouter: NavigationRouter?

    init(navigationRouter: NavigationRouter, parentNavigationRouter: NavigationRouter) {
        self.parentNavigationRouter = parentNavigationRouter
        self.navigationRouter = navigationRouter

        let module = SettingsModule(
            configService: resolve(),
            tonService: resolve(),
            biometricService: resolve(),
            onClose: { [weak parentNavigationRouter] in
                parentNavigationRouter?.dismissTopmost()
            }
        )
        super.init(view: module.view, module: module)

        module.output = self
    }
}

extension SettingsRouter: SettingsModuleOutput {
    func showMnemonicWords(words: [String]) {
        let viewModel = RecoveryMnemonicViewModel(mnemonicWords: words) { [weak navigationRouter] in
            navigationRouter?.popTopmost()
        }
        let router = WizardMnemonicRouter(extendNavigationBarHeight: true, viewModel: viewModel)
        navigationRouter?.push(router: router)
    }

    func showPasscodeConfirmation(passcode: String, onSuccess: @escaping () -> Void) {
        guard let navigationRouter else {
            return
        }

        let router = PasscodeRouter(
            passcode: passcode,
            navigationRouter: navigationRouter
        ) { [weak navigationRouter] in
            navigationRouter?.dismissTopmost()
            onSuccess()
        }
        router.viewController.modalPresentationStyle = .overFullScreen
        navigationRouter.present(router: router)
    }

    func showPasscodeChange(onSuccess: @escaping (String) -> Void) {
        let viewModel = PasscodeChangeViewModel { [weak navigationRouter] _viewModel in
            let router = WizardPasscodeRouter(
                isInConfirmationMode: true,
                extendNavigationBarHeight: true,
                viewModel: _viewModel
            )
            navigationRouter?.push(router: router)
        } onConfirm: { [weak navigationRouter] passcode in
            navigationRouter?.popTopmost(animated: false)
            navigationRouter?.popTopmost(animated: true)

            onSuccess(passcode)
        }

        let router = WizardPasscodeRouter(
            isInConfirmationMode: false,
            extendNavigationBarHeight: true,
            viewModel: viewModel
        )
        navigationRouter?.push(router: router)
    }

    func showDeleteConfirmation(onSuccess: @escaping () -> Void) {
        let actions: [UIAlertAction] = [
            .init(title: "Cancel", style: .cancel),
            .init(title: "Delete", style: .destructive) { [weak parentNavigationRouter] _ in
                guard let parentNavigationRouter else {
                    return
                }

                parentNavigationRouter.dismissTopmost()
                onSuccess()
            }
        ]

        let router = AlertRouter(
            title: "Are you sure?",
            message: "All of your wallet data will be lost.",
            actions: actions
        )

        navigationRouter?.present(router: router)
    }
}

private final class RecoveryMnemonicViewModel: WizardMnemonicViewModel {
    let mnemonicWords: [String]

    private let onDoneTap: () -> Void

    init(mnemonicWords: [String], onDoneTap: @escaping () -> Void) {
        self.mnemonicWords = mnemonicWords
        self.onDoneTap = onDoneTap
    }

    func proceedToNext() {
        onDoneTap()
    }

    func didAppear() { }
}

private final class PasscodeChangeViewModel: WizardPasscodeViewModel {
    @Published var passcode: String?

    private let onSetup: (PasscodeChangeViewModel) -> Void
    private let onConfirm: (String) -> Void

    init(onSetup: @escaping (PasscodeChangeViewModel) -> Void, onConfirm: @escaping (String) -> Void) {
        self.onSetup = onSetup
        self.onConfirm = onConfirm
    }

    func confirmPasscode(_ value: String) -> Bool {
        if value == passcode {
            onConfirm(passcode ?? "")
            return true
        }
        return false
    }

    func setUpPasscode(_ value: String) {
        passcode = value
        onSetup(self)
    }
}
