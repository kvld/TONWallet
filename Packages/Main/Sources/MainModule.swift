//
//  Created by Vladislav Kiriukhin on 24.03.2023.
//

import Foundation
import SwiftUI
import CommonServices
import TON

public protocol MainModuleOutput: AnyObject {
    func showWizard()
    func showReceive(walletInfo: WalletInfo)
    func showSend()
    func showTransaction(_ transaction: TON.Transaction)
    func showScanner()
    func showSettings()
}

public final class MainModule {
    public let view: AnyView
    private let viewModel: MainViewModel

    public var output: MainModuleOutput? {
        get {
            viewModel.output
        }
        set {
            viewModel.output = newValue
        }
    }

    public init() {
        let viewModel = MainViewModel(configService: resolve(), tonService: resolve())

        self.viewModel = viewModel
        self.view = AnyView(MainView(viewModel: viewModel))
    }
}
