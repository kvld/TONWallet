//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import WizardMnemonicInput
import WizardState
import SwiftUI

final class WizardMnemonicInputRouter: HostingRouter<AnyView, WizardMnemonicInputModule> {
    init(state: WizardMnemonicInputState, viewModel: WizardViewModel) {
        let module = WizardMnemonicInputModule(state: state, viewModel: viewModel)
        super.init(view: module.view, module: module)
    }
}

