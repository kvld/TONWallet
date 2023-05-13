//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import SwiftUI
import SendState
import SwiftUIHelpers

public final class SendConfirmModule {
    public let view: AnyView
    
    public init(viewModel: SendViewModel) {
        self.view = SendConfirmView(viewModel: viewModel).eraseToAnyView()
    }
}
