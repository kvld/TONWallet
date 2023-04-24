//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import WizardPasscode
import WizardState
import SwiftUI

final class WizardPasscodeRouter: HostingRouter<AnyView, WizardPasscodeModule> {
    init(isInConfirmationMode: Bool, viewModel: WizardViewModel) {
        let module = WizardPasscodeModule(isInConfirmationMode: isInConfirmationMode, viewModel: viewModel)
        super.init(view: module.view, module: module)
    }
}

