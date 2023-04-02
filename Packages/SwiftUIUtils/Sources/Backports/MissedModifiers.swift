//
//  Created by Vladislav Kiriukhin on 24.03.2023.
//

import Foundation
import SwiftUI

extension View {
    public func overlay(alignment: Alignment = .center, @ViewBuilder content: () -> some View) -> some View {
        overlay(content(), alignment: alignment)
    }
}

extension View {
    public func background(alignment: Alignment = .center, @ViewBuilder content: () -> some View) -> some View {
        background(content(), alignment: alignment)
    }
}
