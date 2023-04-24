//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import SwiftUI
import WizardState

public final class WizardInitialModule {
    public let view: AnyView
    
    public init(viewModel: WizardViewModel) {
        self.view = WizardInitialView(viewModel: viewModel).eraseToAnyView()
    }
}
