//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import WizardInfo
import SwiftUI

final class WizardInitialRouter: HostingRouter<AnyView, WizardInfoModule> {
    init(onCreateWallet: @escaping () -> Void, onImportWallet: @escaping () -> Void) {
        let module = WizardInfoModule(
            model: .init(
                animationName: "start",
                title: "TON Wallet",
                text: "TON Wallet allows you to make fast and secure blockchain-based payments without intermediaries.",
                primaryButton: .init(title: "Create my wallet", action: onCreateWallet),
                secondaryButton: .init(title: "Import existing wallet", action: onImportWallet)
            )
        )

        super.init(view: module.view, module: module)
    }
}
