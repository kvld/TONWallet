//
//  Created by Vladislav Kiriukhin on 24.04.2023.
//

import SwiftUI
import Components

struct SmallBalanceView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 2) {
            Image("ton")
                .resizable()
                .frame(width: 18, height: 18)
                .padding(.top, 2)

            VStack(alignment: .center, spacing: -2) {
                Text("56.2322")
                    .fontConfiguration(.body.semibold)
                    .foregroundColor(.text.overlay)

                Text("≈ $89.6")
                    .fontConfiguration(.caption1)
                    .foregroundColor(.text.overlay)
                    .opacity(0.6)
            }
        }
    }
}
