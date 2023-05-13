//
//  Created by Vladislav Kiriukhin on 30.04.2023.
//

import Foundation
import SendAmount
import SendState
import SwiftUI

final class SendAmountRouter: HostingRouter<AnyView, SendAmountModule> {
    init(viewModel: SendViewModel) {
        let module = SendAmountModule(viewModel: viewModel)

        super.init(view: module.view, module: module)
    }
}
