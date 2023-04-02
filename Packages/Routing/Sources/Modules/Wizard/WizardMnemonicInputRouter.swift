//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import WizardMnemonicInput
import SwiftUI

final class WizardMnemonicInputRouter: HostingRouter<AnyView, WizardMnemonicInputModule> {
    init(
        state: WizardMnemonicInputState,
        onComplete: @escaping () -> Void,
        onForgotWords: @escaping () -> Void
    ) {
        let module = WizardMnemonicInputModule(
            state: state,
            onComplete: onComplete,
            onForgotWords: onForgotWords
        )

        super.init(view: module.view, module: module)
    }
}

