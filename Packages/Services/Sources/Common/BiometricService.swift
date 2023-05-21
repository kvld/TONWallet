//
//  Created by Vladislav Kiriukhin on 20.05.2023.
//

import Foundation
import LocalAuthentication

public final class BiometricService {
    private let context: LAContext

    public var isSupportBiometric: Bool {
        guard canEvaluate else { return false }
        return context.biometryType != .none
    }

    public var isSupportFaceID: Bool {
        guard canEvaluate else { return false }
        return context.biometryType == .faceID
    }

    private var canEvaluate: Bool {
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }

    public init() {
        self.context = LAContext()
    }

    public func evaluate(withLocalizedReason reason: String = "Need to confirm operation") async -> Bool {
        guard canEvaluate else { return false }

        let result = try? await context
            .evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
        return result ?? false
    }
}
