//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import SwiftUI

public struct WizardInfoModel {
    let animationName: String
    let title: String
    let text: String
    let isNavigationBarVisible: Bool
    let primaryButton: Button
    let secondaryButton: Button?

    public init(
        animationName: String,
        title: String,
        text: String,
        isNavigationBarVisible: Bool = false,
        primaryButton: Button,
        secondaryButton: Button?
    ) {
        self.animationName = animationName
        self.title = title
        self.text = text
        self.isNavigationBarVisible = isNavigationBarVisible
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }

    public struct Button {
        let title: String
        let action: () -> Void

        public init(title: String, action: @escaping () -> Void) {
            self.title = title
            self.action = action
        }
    }
}

public final class WizardInfoModule {
    private let model: WizardInfoModel

    public lazy var view: AnyView = {
        AnyView(WizardInfoView(model: model))
    }()

    public init(model: WizardInfoModel) {
        self.model = model
    }
}
