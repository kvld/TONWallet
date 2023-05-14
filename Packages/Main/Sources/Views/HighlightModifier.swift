//
//  Created by Vladislav Kiriukhin on 14.05.2023.
//

import SwiftUI
import Components

private struct HighlightModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        Button(action: action) {
            content
        }
        .buttonStyle(HighlightStyle())
    }

    private struct HighlightStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .background(configuration.isPressed ? Color.tableHighlight : Color.background.content)
        }
    }
}

extension View {
    func onTapWithHighlight(_ action: @escaping () -> Void) -> some View {
        modifier(HighlightModifier(action: action))
    }
}
