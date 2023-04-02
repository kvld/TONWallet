//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import WizardBiometric
import SwiftUI

final class WizardBiometricRouter: HostingRouter<AnyView, WizardBiometricModule> {
    init(onSuccess: @escaping () -> Void, onSkip: @escaping () -> Void) {
        let module = WizardBiometricModule(onSuccess: onSuccess, onSkip: onSkip)

        super.init(view: module.view, module: module)
    }
}

