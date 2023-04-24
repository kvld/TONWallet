//
//  Created by Vladislav Kiriukhin on 24.04.2023.
//

import SwiftUI
import Components

struct LargeBalanceView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            Text("UQBF...AoKP")
                .fontConfiguration(.body.regular)
                .foregroundColor(.text.overlay)

            HStack(alignment: .center, spacing: 4) {
                Image("ton")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .padding(.bottom, 2)

                HStack(alignment: .center, spacing: 0) {
                    Text("56")
                        .fontConfiguration(.rounded.balanceLarge)

                    Text(".2322")
                        .fontConfiguration(.rounded.balanceSmall)
                        .padding(.top, 13)
                }
                .foregroundColor(.text.overlay)
            }
        }
    }
}
