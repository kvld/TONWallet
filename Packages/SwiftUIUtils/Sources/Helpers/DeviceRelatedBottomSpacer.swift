//
//  Created by Vladislav Kiriukhin on 01.05.2023.
//

import Foundation
import SwiftUI
import Combine

public struct DeviceRelatedBottomSpacer: View {
    @State private var isKeyboardVisible = false

    public init() { }

    private var safeAreaInsets: UIEdgeInsets {
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero
    }

    private var height: CGFloat {
        if safeAreaInsets.bottom > 0 {
            return isKeyboardVisible ? 16 : 0
        }
        return 16
    }

    public var body: some View {
        Spacer()
            .frame(height: height)
            .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                isKeyboardVisible = keyboardHeight > 0
            }
    }
}
