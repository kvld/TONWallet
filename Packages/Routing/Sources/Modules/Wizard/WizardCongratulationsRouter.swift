//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import WizardInfo
import SwiftUI

final class WizardCongratulationsRouter: HostingRouter<AnyView, WizardInfoModule> {
    var canDismissInteractively: Bool { false }

    init(onShowMnemonicWords: @escaping () -> Void) {
        let module = WizardInfoModule(
            model: .init(
                animationName: "congratulations",
                title: "Congratulations",
                text: "Your TON Wallet has just been created. Only you control it.\n\nTo be able to always have access to it, please write down secret words and set up a secure passcode.",
                primaryButton: .init(title: "Proceed", action: onShowMnemonicWords),
                secondaryButton: nil
            )
        )

        super.init(view: module.view, module: module)
    }
}
