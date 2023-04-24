//
//  Created by Vladislav Kiriukhin on 24.04.2023.
//

import SwiftUI
import SwiftUIHelpers

struct MainNavigationBar<BalanceView: View>: View {
    @ViewBuilder let balanceView: () -> BalanceView

    var body: some View {
        HStack {
            Image("scan")
                .resizable()
                .frame(width: 28, height: 28)
                .onTapWithFeedback {

                }

            Spacer()

            balanceView()

            Spacer()

            Image("settings")
                .resizable()
                .frame(width: 28, height: 28)
                .onTapWithFeedback {

                }
        }
        .padding(.horizontal, 14)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 44)
    }
}
