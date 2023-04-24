//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import SwiftUI

public final class WizardBiometricModule {
    public lazy var view: AnyView = {
        AnyView(
            WizardBiometricView(onSkipTap: onSkip)
        )
    }()

    private let onSkip: () -> Void
    private let onSuccess: () -> Void

    public init(onSuccess: @escaping () -> Void, onSkip: @escaping () -> Void) {
        self.onSkip = onSkip
        self.onSuccess = onSuccess
    }
}
