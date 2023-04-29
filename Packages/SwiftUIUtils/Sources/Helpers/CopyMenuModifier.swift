//
//  Created by Vladislav Kiriukhin on 29.04.2023.
//

import SwiftUI

struct CopyMenuModifier: ViewModifier {
    let text: String
    let title: String

    func body(content: Content) -> some View {
        content.padding(.all, 8).contextMenu(
            ContextMenu(
                menuItems: {
                    Button {
                        UIPasteboard.general.string = text
                    } label: {
                        Label(title, systemImage: "doc.on.doc")
                    }
                }
            )
        )
        .padding(.top, -8)
    }
}

extension View {
    public func copyMenu(text: String, title: String = "Copy") -> some View {
        modifier(CopyMenuModifier(text: text, title: title))
    }
}
