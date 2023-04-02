//
//  Created by Vladislav Kiriukhin on 24.03.2023.
//

import SwiftUI

struct OnTapWithFeedbackModifier: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        Button(action: action) {
            content
        }
    }
}

extension View {
    public func onTapWithFeedback(action: @escaping () -> Void) -> some View {
        modifier(OnTapWithFeedbackModifier(action: action))
    }
}
