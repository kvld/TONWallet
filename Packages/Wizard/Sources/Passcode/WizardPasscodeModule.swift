//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import WizardState
import SwiftUI

public final class WizardPasscodeModule {
    public let view: AnyView

    public init(isInConfirmationMode: Bool, viewModel: WizardViewModel) {
        self.view = AnyView(WizardPasscodeView(isInConfirmationMode: isInConfirmationMode, viewModel: viewModel))
    }
}
