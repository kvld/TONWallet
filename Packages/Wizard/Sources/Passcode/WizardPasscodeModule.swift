//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import WizardState
import SwiftUI

public protocol WizardPasscodeViewModel: ObservableObject {
    var passcode: String? { get }

    func confirmPasscode(_ value: String) -> Bool
    func setUpPasscode(_ value: String)
}

public final class WizardPasscodeModule {
    public let view: AnyView

    public init<ViewModel: WizardPasscodeViewModel>(
        isInConfirmationMode: Bool,
        extendNavigationBarHeight: Bool,
        viewModel: ViewModel
    ) {
        self.view = AnyView(
            WizardPasscodeView(
                isInConfirmationMode: isInConfirmationMode,
                extendNavigationBarHeight: extendNavigationBarHeight,
                viewModel: viewModel
            )
        )
    }
}

extension WizardViewModel: WizardPasscodeViewModel {
    public var passcode: String? {
        state.passcode
    }
}
