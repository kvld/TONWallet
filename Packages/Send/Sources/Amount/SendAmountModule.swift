//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import SwiftUI
import SendState
import SwiftUIHelpers

public final class SendAmountModule {
    public let view: AnyView
    
    public init(viewModel: SendViewModel) {
        self.view = SendAmountView(viewModel: viewModel).eraseToAnyView()
    }
}
