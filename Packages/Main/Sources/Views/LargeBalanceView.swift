//
//  Created by Vladislav Kiriukhin on 24.04.2023.
//

import SwiftUI
import Components

struct LargeBalanceView: View {
    let address: (displayed: String, copy: String)?
    let balanceInteger: String?
    let balanceFraction: String?

    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            if let address {
                Text(address.displayed)
                    .fontConfiguration(.body.regular)
                    .foregroundColor(.text.overlay)
                    .transition(.opacity.animation(.easeInOut(duration: 0.1)))
                    .copyMenu(text: address.copy)
            }

            HStack(alignment: .center, spacing: 4) {
                Image("ton")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .padding(.bottom, 2)
                    .animation(.linear(duration: 0.25), value: balanceInteger)

                if let balanceInteger {
                    HStack(alignment: .center, spacing: 0) {
                        Text(balanceInteger)
                            .fontConfiguration(.rounded.balanceLarge)
                        
                        if let balanceFraction {
                            Text(String(balanceFraction).prefix(3))
                                .fontConfiguration(.rounded.balanceSmall)
                                .padding(.top, 13)
                        }
                    }
                    .foregroundColor(.text.overlay)
                    .transition(.opacity.animation(.easeInOut(duration: 0.25).delay(0.15)))
                }
            }
        }
    }
}
