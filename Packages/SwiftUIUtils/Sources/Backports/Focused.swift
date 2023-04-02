//
//  Created by Vladislav Kiriukhin on 02.04.2023.
//

import Foundation
import SwiftUI

struct FocusedModifier: ViewModifier {
    @FocusState private var isFocused_
    @Binding var isFocused: Bool

    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .focused($isFocused_)
                .onAppear {
                    isFocused_ = isFocused
                }
                .onChange(of: isFocused) { newValue in
                    isFocused_ = newValue
                }
        } else {
            content
        }
    }
}

extension View {
    public func focused(_ isFocused: Binding<Bool>) -> some View {
        modifier(FocusedModifier(isFocused: isFocused))
    }
}
