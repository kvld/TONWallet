//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import WizardPasscode
import WizardState
import SwiftUI

final class WizardPasscodeRouter: HostingRouter<AnyView, WizardPasscodeModule> {
    init<ViewModel: WizardPasscodeViewModel>(
        isInConfirmationMode: Bool,
        extendNavigationBarHeight: Bool = false,
        viewModel: ViewModel
    ) {
        let module = WizardPasscodeModule(
            isInConfirmationMode: isInConfirmationMode,
            extendNavigationBarHeight: extendNavigationBarHeight,
            viewModel: viewModel
        )
        super.init(view: module.view, module: module)
    }
}

