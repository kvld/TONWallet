//
//  Created by Vladislav Kiriukhin on 20.05.2023.
//

import SwiftUI
import CommonServices

public protocol PasscodeModuleOutput: AnyObject {
    func showWrongPasscodeAlert()
}

public final class PasscodeModule {
    public let view: AnyView
    private let viewModel: PasscodeViewModel

    public var output: PasscodeModuleOutput? {
        get {
            viewModel.output
        }
        set {
            viewModel.output = newValue
        }
    }

    public init(passcode: String, biometricService: BiometricService, onSuccess: @escaping () -> Void) {
        let viewModel = PasscodeViewModel(passcode: passcode, biometricService: biometricService, onSuccess: onSuccess)
        self.viewModel = viewModel
        self.view = AnyView(PasscodeView(viewModel: viewModel))
    }
}
