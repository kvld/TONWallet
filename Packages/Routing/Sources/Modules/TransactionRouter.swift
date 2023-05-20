//
//  Created by Vladislav Kiriukhin on 14.05.2023.
//

import Foundation
import SwiftUI
import TON
import Settings

final class SettingsRouter: HostingRouter<AnyView, SettingsModule> {
    init() {
        let module = SettingsModule()
        super.init(view: module.view, module: module)
    }
}
