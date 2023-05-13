//
//  Created by Vladislav Kiriukhin on 24.03.2023.
//

import Foundation
import SwiftUI
import TON

public protocol MainModuleOutput: AnyObject {
    func showWizard()
    func showReceive(walletInfo: WalletInfo)
    func showSend()
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
        let walletInfoService = WalletInfoService(storage: .init())
        let tonService = TONService(
            storage: .init(),
            configURL: URL(string: "https://ton.org/testnet-global.config.json")!
        )
        let viewModel = MainViewModel(walletInfoService: walletInfoService, tonService: tonService)

        self.viewModel = viewModel
        self.view = AnyView(MainView(viewModel: viewModel))
    }
}
