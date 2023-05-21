//
//  Created by Vladislav Kiriukhin on 30.04.2023.
//

import Foundation
import SendAddress
import SendState
import SwiftUI

final class SendAddressRouter: HostingRouter<AnyView, SendAddressModule> {
    init(viewModel: SendViewModel, parentNavigationRouter: NavigationRouter) {
        let module = SendAddressModule(
            viewModel: viewModel,
            onClose: { [weak parentNavigationRouter] in
                parentNavigationRouter?.dismissTopmost()
            }
        )

        super.init(view: module.view, module: module)
    }
}
