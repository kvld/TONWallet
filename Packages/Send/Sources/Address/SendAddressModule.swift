//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import SwiftUI
import SendState
import SwiftUIHelpers

public final class SendAddressModule {
    public let view: AnyView
    
    public init(viewModel: SendViewModel, onClose: @escaping () -> Void) {
        self.view = SendAddressView(viewModel: viewModel, onClose: onClose).eraseToAnyView()
    }
}
