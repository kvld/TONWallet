//
//  Created by Vladislav Kiriukhin on 30.04.2023.
//

import Foundation
import SendAddress
import SendState
import SwiftUI

final class SendAddressRouter: HostingRouter<AnyView, SendAddressModule> {
    init(viewModel: SendViewModel) {
        let module = SendAddressModule(viewModel: viewModel)

        super.init(view: module.view, module: module)
    }
}
