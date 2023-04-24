//
//  Created by Vladislav Kiriukhin on 02.04.2023.
//

import Foundation
import SwiftUI
import WizardMnemonic
import WizardState

final class WizardMnemonicRouter: HostingRouter<AnyView, WizardMnemonicModule> {
    init(viewModel: WizardViewModel) {
        let module = WizardMnemonicModule(viewModel: viewModel)
        super.init(view: module.view, module: module)
    }
}
