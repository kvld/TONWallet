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
    let primaryButton: AnyView
    let secondaryButton: AnyView?

    public init(
        animationName: String,
        title: String,
        text: String,
        isNavigationBarVisible: Bool = false,
        primaryButton: AnyView,
        secondaryButton: AnyView?
    ) {
        self.animationName = animationName
        self.title = title
        self.text = text
        self.isNavigationBarVisible = isNavigationBarVisible
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
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
