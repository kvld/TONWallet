//
//  Created by Vladislav Kiriukhin on 30.04.2023.
//

import Foundation
import SwiftUI
import SwiftUIHelpers
import TON

public protocol ReceiveModuleOutput: AnyObject {
    func share(url: URL)
}

public final class ReceiveModule {
    public let view: AnyView
    private let viewModel: ReceiveViewModel

    public var output: ReceiveModuleOutput? {
        get {
            viewModel.output
        }
        set {
            viewModel.output = newValue
        }
    }

    public init(walletInfo: WalletInfo) {
        let viewModel = ReceiveViewModel(walletInfo: walletInfo)

        self.view = ReceiveView(viewModel: viewModel).eraseToAnyView()
        self.viewModel = viewModel
    }
}
