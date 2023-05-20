//
//  Created by Vladislav Kiriukhin on 14.05.2023.
//

import Foundation
import SwiftUI
import SwiftUIHelpers
import TON

public final class SettingsModule {
    public let view: AnyView

    public init() {
        self.view = SettingsView(viewModel: .init()).eraseToAnyView()
    }
}
