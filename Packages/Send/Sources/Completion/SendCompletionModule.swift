//
//  Created by Vladislav Kiriukhin on 13.05.2023.
//

import Foundation
import SwiftUI
import SendState
import SwiftUIHelpers

public enum SendCompletionStage {
    case waiting
    case completed
}

public final class SendCompletionModule {
    public let view: AnyView

    public init(stage: SendCompletionStage, viewModel: SendViewModel, onClose: @escaping () -> Void) {
        self.view = SendCompletionView(stage: stage, viewModel: viewModel, onClose: onClose).eraseToAnyView()
    }
}
