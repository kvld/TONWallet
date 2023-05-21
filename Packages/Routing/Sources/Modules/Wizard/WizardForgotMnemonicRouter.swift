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
                primaryButton: Self.makePrimaryButton(onTap: onReturnToMnemonicInput),
                secondaryButton: Self.makeSecondaryButton(onTap: onReturnToInitial)
            )
        )

        super.init(view: module.view, module: module)
    }

    private static func makePrimaryButton(onTap: @escaping () -> Void) -> AnyView {
        Button("Enter 24 secret words", action: onTap)
            .buttonStyle(.action())
            .eraseToAnyView()
    }

    private static func makeSecondaryButton(onTap: @escaping () -> Void) -> AnyView {
        Button("Create an empty wallet", action: onTap)
            .buttonStyle(.action(background: .outline))
            .eraseToAnyView()
    }
}
