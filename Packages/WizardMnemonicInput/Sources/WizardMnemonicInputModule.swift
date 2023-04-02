//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import SwiftUI

public enum WizardMnemonicInputState {
    case test(indices: [Int])
    case `import`(count: Int)
}

public final class WizardMnemonicInputModule {
    private let state: WizardMnemonicInputState

    public lazy var view: AnyView = {
        AnyView(
            WizardMnemonicInputView(
                state: state,
                onForgotTap: onForgotTap,
                onDoneTap: onDoneTap
            )
        )
    }()

    private let onForgotTap: () -> Void
    private let onDoneTap: () -> Void

    public init(
        state: WizardMnemonicInputState,
        onComplete: @escaping () -> Void,
        onForgotWords: @escaping () -> Void
    ) {
        self.state = state
        self.onForgotTap = onForgotWords
        self.onDoneTap = onComplete
    }
}
