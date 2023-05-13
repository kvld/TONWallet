//
//  Created by Vladislav Kiriukhin on 06.05.2023.
//

import Foundation
import SendConfirm
import SendState
import SwiftUI

final class SendConfirmRouter: HostingRouter<AnyView, SendConfirmModule> {
    init(viewModel: SendViewModel) {
        let module = SendConfirmModule(viewModel: viewModel)

        super.init(view: module.view, module: module)
    }
}
