//
//  Created by Vladislav Kiriukhin on 02.04.2023.
//

import Foundation
import WizardInfo
import SwiftUI

final class WizardReadyRouter: HostingRouter<AnyView, WizardInfoModule> {
    var canDismissInteractively: Bool { false }

    init(afterImport: Bool, onClose: @escaping () -> Void) {
        let module = WizardInfoModule(
            model: .init(
                animationName: afterImport ? "congratulations" : "start",
                title: afterImport ? "Your wallet has just been imported!" : "Ready to go!",
                text: afterImport
                    ? ""
                    : "You are all set. Now you have a wallet that only you control — directly, without middlemen or bankers.",
                primaryButton: Self.makePrimaryButton(onClose: onClose),
                secondaryButton: nil
            )
        )

        super.init(view: module.view, module: module)
    }

    private static func makePrimaryButton(onClose: @escaping () -> Void) -> AnyView {
        Button("View my wallet") {
            onClose()
        }
        .buttonStyle(.action())
        .eraseToAnyView()
    }
}
