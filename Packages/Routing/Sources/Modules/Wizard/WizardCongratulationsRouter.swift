//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import WizardState
import WizardInfo
import SwiftUIHelpers
import SwiftUI

final class WizardCongratulationsRouter: HostingRouter<AnyView, WizardInfoModule> {
    var canDismissInteractively: Bool { false }

    init(viewModel: WizardViewModel) {
        let module = WizardInfoModule(
            model: .init(
                animationName: "congratulations",
                title: "Congratulations",
                text: "Your TON Wallet has just been created. Only you control it.\n\nTo be able to always have access to it, please write down secret words and set up a secure passcode.",
                primaryButton: Self.makePrimaryButton(viewModel: viewModel),
                secondaryButton: nil
            )
        )

        super.init(view: module.view, module: module)
    }

    private static func makePrimaryButton(viewModel: WizardViewModel) -> AnyView {
        Button("Proceed") {
            viewModel.output?.showMnemonicWordsList()
        }
        .buttonStyle(.action())
        .eraseToAnyView()
    }
}
