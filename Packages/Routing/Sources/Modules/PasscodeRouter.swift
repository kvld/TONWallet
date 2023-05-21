//
//  Created by Vladislav Kiriukhin on 20.05.2023.
//

import SwiftUI
import Passcode
import CommonServices

final class PasscodeRouter: HostingRouter<AnyView, PasscodeModule>, PasscodeModuleOutput {
    private weak var navigationRouter: NavigationRouter?

    init(passcode: String, navigationRouter: NavigationRouter, onSuccess: @escaping () -> Void) {
        self.navigationRouter = navigationRouter

        let module = PasscodeModule(passcode: passcode, biometricService: BiometricService(), onSuccess: onSuccess)
        super.init(view: module.view, module: module)

        module.output = self
    }

    func showWrongPasscodeAlert() {
        let actions: [UIAlertAction] = [
            .init(title: "Cancel", style: .default) { [weak navigationRouter] _ in
                navigationRouter?.dismissTopmost()
                navigationRouter?.dismissTopmost()
            },
            .init(title: "Try again", style: .default) { [weak navigationRouter] _ in
                navigationRouter?.dismissTopmost()
            }
        ]

        let router = AlertRouter(
            title: "Incorrect passcode",
            message: "The passcode you have entered is not correct.",
            actions: actions
        )

        navigationRouter?.present(router: router, overModal: true)
    }
}
