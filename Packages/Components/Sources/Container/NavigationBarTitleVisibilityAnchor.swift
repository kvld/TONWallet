//
//  Created by Vladislav Kiriukhin on 02.04.2023.
//

import Foundation
import SwiftUI
import SwiftUIBackports

let scrollViewSpaceID = "scrollView"
let contentSpaceID = "scrollContentView"

struct NavigationBarTitleVisibilityAnchorModifier: ViewModifier {
    @State private var offset: CGFloat = 0

    func body(content: Content) -> some View {
        content.overlay {
            GeometryReader { proxy in
                let offset = proxy.frame(in: .named(contentSpaceID)).midY
                
                Color.clear
                    .preference(
                        key: NavigationBarTitleVisibilityAnchorOffsetKey.self,
                        value: offset
                    )
            }
        }
    }
}

extension View {
    public func navigationBarTitleVisibilityAnchor() -> some View {
        modifier(NavigationBarTitleVisibilityAnchorModifier())
    }
}

struct NavigationBarTitleVisibilityAnchorOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(nextValue(), value)
    }
}
