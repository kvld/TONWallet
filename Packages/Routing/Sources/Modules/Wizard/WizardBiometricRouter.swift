//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import WizardBiometric
import SwiftUI
import WizardState

final class WizardBiometricRouter: HostingRouter<AnyView, WizardBiometricModule> {
    init(viewModel: WizardViewModel) {
        let module = WizardBiometricModule(viewModel: viewModel)

        super.init(view: module.view, module: module)
    }
}
