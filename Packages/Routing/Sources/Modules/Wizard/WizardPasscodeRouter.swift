//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import WizardPasscode
import SwiftUI

final class WizardPasscodeRouter: HostingRouter<AnyView, WizardPasscodeModule> {
    init(isInConfirmationMode: Bool, onSuccess: @escaping () -> Void) {
        let module = WizardPasscodeModule(isInConfirmationMode: isInConfirmationMode, onSuccess: onSuccess)

        super.init(view: module.view, module: module)
    }
}

