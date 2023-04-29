//
//  Created by Vladislav Kiriukhin on 29.04.2023.
//

import Foundation
import SwiftUI
import AnimationView
import Components
import SwiftUIHelpers

struct EmptyStateView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            AnimationView(animationName: "created", repeatInfinitely: false)
                .frame(width: 124, height: 124)
                .padding(.bottom, 16)

            Text("Wallet Created")
                .fontConfiguration(.title1)
                .foregroundColor(.text.primary)
                .padding(.bottom, 28)

            Text("Your wallet address")
                .fontConfiguration(.body.regular)
                .foregroundColor(.text.secondary)
                .padding(.bottom, 6)

            Text("UQBFz01R2CU7YA8pevUaNIYE\nzi1mRo4cX-r3W2Dwx-WEAoKP")
                .fontConfiguration(.body.mono)
                .foregroundColor(.text.primary)
                .copyMenu(text: "123")
        }
    }
}
