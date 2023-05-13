//
//  Created by Vladislav Kiriukhin on 13.05.2023.
//

import Foundation
import SendCompletion
import SendState
import SwiftUI

final class SendCompletionRouter: HostingRouter<AnyView, SendCompletionModule> {
    var canDismissInteractively: Bool { false }

    init(stage: SendCompletionStage, viewModel: SendViewModel) {
        let module = SendCompletionModule(stage: stage, viewModel: viewModel)

        super.init(view: module.view, module: module)
    }
}
