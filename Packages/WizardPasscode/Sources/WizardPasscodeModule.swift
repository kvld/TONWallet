//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import SwiftUI

public final class WizardPasscodeModule {
    private let isInConfirmationMode: Bool
    private let onSuccess: () -> Void

    public lazy var view: AnyView = {
        AnyView(
            WizardPasscodeView(
                isInConfirmationMode: isInConfirmationMode,
                onSuccess: { [weak self] _ in
                    self?.onSuccess()
                }
            )
        )
    }()

    public init(
        isInConfirmationMode: Bool,
        onSuccess: @escaping () -> Void
    ) {
        self.isInConfirmationMode = isInConfirmationMode
        self.onSuccess = onSuccess
    }
}
