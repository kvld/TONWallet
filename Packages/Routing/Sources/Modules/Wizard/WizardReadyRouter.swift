//
//  Created by Vladislav Kiriukhin on 02.04.2023.
//

import Foundation
import WizardInfo
import SwiftUI

final class WizardReadyRouter: HostingRouter<AnyView, WizardInfoModule> {
    var canDismissInteractively: Bool { false }

    init(onClose: @escaping () -> Void) {
        let module = WizardInfoModule(
            model: .init(
                animationName: "start",
                title: "Ready to go!",
                text: "You are all set. Now you have a wallet that only you control — directly, without middlemen or bankers.",
                primaryButton: .init(title: "View my wallet", action: onClose),
                secondaryButton: nil
            )
        )

        super.init(view: module.view, module: module)
    }
}