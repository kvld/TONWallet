//
//  Created by Vladislav Kiriukhin on 24.03.2023.
//

import Foundation
import SwiftUI

public protocol MainModuleOutput: AnyObject {
    func showWizard()
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
        let viewModel = MainViewModel()

        self.viewModel = viewModel
        self.view = AnyView(MainView(viewModel: viewModel))
    }
}
