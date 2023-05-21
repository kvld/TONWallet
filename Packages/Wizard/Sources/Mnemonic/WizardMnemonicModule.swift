//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import SwiftUI
import WizardState

public protocol WizardMnemonicViewModel: ObservableObject {
    var mnemonicWords: [String] { get }

    func proceedToNext()
    func didAppear()
}

public final class WizardMnemonicModule {
    public let view: AnyView

    public init<ViewModel: WizardMnemonicViewModel>(extendNavigationBarHeight: Bool, viewModel: ViewModel) {
        self.view = WizardMnemonicView(extendNavigationBarHeight: extendNavigationBarHeight, viewModel: viewModel)
            .eraseToAnyView()
    }
}

extension WizardViewModel: WizardMnemonicViewModel {
    public var mnemonicWords: [String] {
        state.mnemonicWords
    }

    @MainActor
    public func proceedToNext() {
        proceedToSavedMnemonicTest()
    }

    @MainActor
    public func didAppear() {
        startTimerToSaveMnemonic()
    }
}
