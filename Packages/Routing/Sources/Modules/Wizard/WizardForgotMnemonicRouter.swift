//
//  Created by Vladislav Kiriukhin on 02.04.2023.
//

import Foundation
import WizardInfo
import SwiftUI

final class WizardForgotMnemonicRouter: HostingRouter<AnyView, WizardInfoModule> {
    init(onReturnToMnemonicInput: @escaping () -> Void, onReturnToInitial: @escaping () -> Void) {
        let module = WizardInfoModule(
            model: .init(
                animationName: "too_bad",
                title: "Too Bad!",
                text: "Without the secret words you can’t restore access to the wallet.",
                isNavigationBarVisible: true,
                primaryButton: .init(
                    title: "Enter 24 secret words",
                    action: onReturnToMnemonicInput
                ),
                secondaryButton: .init(
                    title: "Create a new empty wallet instead",
                    action: onReturnToInitial
                )
            )
        )

        super.init(view: module.view, module: module)
    }
}
