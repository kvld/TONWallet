//
//  Created by Vladislav Kiriukhin on 14.05.2023.
//

import Foundation
import SwiftUI
import SwiftUIHelpers
import TON
import CommonServices

public protocol SettingsModuleOutput: AnyObject {
    func showPasscodeConfirmation(passcode: String, onSuccess: @escaping () -> Void)
    func showMnemonicWords(words: [String])
    func showPasscodeChange(onSuccess: @escaping (String) -> Void)
    func showDeleteConfirmation(onSuccess: @escaping () -> Void)
}

public final class SettingsModule {
    public let view: AnyView
    private let viewModel: SettingsViewModel

    public var output: SettingsModuleOutput? {
        get {
            viewModel.output
        }
        set {
            viewModel.output = newValue
        }
    }

    public init(
        configService: ConfigService,
        tonService: TONService,
        biometricService: BiometricService,
        onClose: @escaping () -> Void
    ) {
        let viewModel = SettingsViewModel(
            configService: configService,
            tonService: tonService,
            biometricService: biometricService
        )

        self.viewModel = viewModel
        self.view = SettingsView(viewModel: viewModel, onClose: onClose).eraseToAnyView()
    }
}
