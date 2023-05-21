//
//  Created by Vladislav Kiriukhin on 20.05.2023.
//

import SwiftUI
import CommonServices

enum PasscodeEnterResult: Equatable {
    case success
    case failure
}

final class PasscodeViewModel: ObservableObject {
    private let passcode: String
    private let biometricService: BiometricService
    private let onSuccess: () -> Void

    var passcodeLength: Int { passcode.count }

    var biometricType: BiometricType? {
        biometricService.isSupportBiometric ? (biometricService.isSupportFaceID ? .faceID : .touchID) : nil
    }

    @Published var typedPasscode: String = ""
    @Published var enterResult: PasscodeEnterResult?

    weak var output: PasscodeModuleOutput?

    init(passcode: String, biometricService: BiometricService, onSuccess: @escaping () -> Void) {
        self.passcode = passcode
        self.biometricService = biometricService
        self.onSuccess = onSuccess
    }

    func typeSymbol(_ value: String) {
        if typedPasscode.count < passcodeLength {
            typedPasscode += value
        }

        if typedPasscode.count == passcodeLength {
            if typedPasscode == passcode {
                enterResult = .success
                onSuccess()
            } else {
                enterResult = .failure
                output?.showWrongPasscodeAlert()
            }
        }
    }

    func deleteSymbol() {
        typedPasscode = String(typedPasscode.dropLast())
    }

    func showBiometric() {
        Task { @MainActor in
            let result = await biometricService.evaluate()
            if result {
                enterResult = .success
                onSuccess()
            } else {
                enterResult = .failure
            }
        }
    }

    enum BiometricType {
        case faceID
        case touchID
    }
}
