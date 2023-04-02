//
//  Created by Vladislav Kiriukhin on 02.04.2023.
//

import Foundation
import SwiftUI
import Combine

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { notification in
                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
            }

        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }

        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

struct KeyboardSafeAreaAdditionalAdjustmentModifier: ViewModifier {
    @State private var keyboardActiveAdjustment: CGFloat = 0

    let additionalKeyboardAvoidancePadding: CGFloat

    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .safeAreaInset(edge: .bottom, spacing: keyboardActiveAdjustment) {
                    EmptyView().frame(height: 0)
                }
                .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                    self.keyboardActiveAdjustment = keyboardHeight > 0 ? additionalKeyboardAvoidancePadding : 0
                }
        } else {
            content
        }
    }
}

extension View {
    public func additionalKeyboardAvoidancePadding(_ value: CGFloat) -> some View {
        modifier(KeyboardSafeAreaAdditionalAdjustmentModifier(additionalKeyboardAvoidancePadding: value))
    }
}

