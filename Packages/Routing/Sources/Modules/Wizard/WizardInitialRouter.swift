//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import WizardInitial
import WizardState
import SwiftUI

final class WizardInitialRouter: HostingRouter<AnyView, WizardInitialModule> {
    init(viewModel: WizardViewModel) {
        let module = WizardInitialModule(viewModel: viewModel)
        super.init(view: module.view, module: module)
    }
}
