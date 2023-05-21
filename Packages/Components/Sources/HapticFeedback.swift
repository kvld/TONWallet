//
//  Created by Vladislav Kiriukhin on 02.04.2023.
//

import UIKit

public final class HapticFeedback {
    public enum Effect {
        case selection
        case error
        case success
        case warning
        case impact
    }

    private let notificationFeedbackGenerator: UINotificationFeedbackGenerator
    private let impactFeedbackGenerator: UIImpactFeedbackGenerator
    private let selectionFeedbackGenerator: UISelectionFeedbackGenerator

    public init() {
        self.notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        self.notificationFeedbackGenerator.prepare()

        self.impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        self.impactFeedbackGenerator.prepare()

        self.selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        self.selectionFeedbackGenerator.prepare()
    }

    public func play(effect: Effect) {
        switch effect {
        case .error:
            notificationFeedbackGenerator.notificationOccurred(.error)
        case .success:
            notificationFeedbackGenerator.notificationOccurred(.success)
        case .warning:
            notificationFeedbackGenerator.notificationOccurred(.warning)
        case .selection:
            selectionFeedbackGenerator.selectionChanged()
        case .impact:
            impactFeedbackGenerator.impactOccurred()
        }
    }
}
