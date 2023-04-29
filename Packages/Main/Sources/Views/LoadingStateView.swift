//
//  Created by Vladislav Kiriukhin on 29.04.2023.
//

import Foundation
import SwiftUI
import AnimationView
import Components
import SwiftUIHelpers

struct LoadingStateView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            AnimationView(animationName: "loading")
                .frame(width: 124, height: 124)
                .padding(.bottom, 16)
        }
    }
}
