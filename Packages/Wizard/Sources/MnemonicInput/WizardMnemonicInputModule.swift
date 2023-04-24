//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import SwiftUI
import WizardState

public enum WizardMnemonicInputState {
    case test
    case `import`
}

public final class WizardMnemonicInputModule {
    public let view: AnyView

    public init(
        state: WizardMnemonicInputState,
        viewModel: WizardViewModel
    ) {
        self.view = AnyView(
            WizardMnemonicInputView(
                state: state,
                viewModel: viewModel,
                inputText: Array(repeating: "", count: viewModel.state.mnemonicWords.count)
            )
        )
    }
}
