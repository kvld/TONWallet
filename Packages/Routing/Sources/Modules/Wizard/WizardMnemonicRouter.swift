//
//  Created by Vladislav Kiriukhin on 02.04.2023.
//

import Foundation
import SwiftUI
import WizardMnemonic

final class WizardMnemonicRouter: HostingRouter<AnyView, WizardMnemonicModule> {
    init(onComplete: @escaping () -> Void) {
        let module = WizardMnemonicModule(onDoneTap: onComplete)

        super.init(view: module.view, module: module)
    }
}
