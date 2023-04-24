//
//  Created by Vladislav Kiriukhin on 24.03.2023.
//

import Foundation
import SwiftUI
import SwiftUIBackports
import SwiftUIHelpers
import Components
import Combine

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel

    @State private var isBalanceInNavigationBarTitleVisible = false

    @ViewBuilder
    private var balanceView: some View {
        VStack(spacing: 0) {
            Spacer()

            LargeBalanceView()

            Spacer().frame(height: 74)

            HStack(spacing: 12) {
                Button("Receive", action: { })
                    .buttonStyle(.action(color: .accentMain))

                Button("Send", action: { })
                    .buttonStyle(.action(color: .accentMain))
            }
        }
        .padding(.bottom, 16)
        .padding(.horizontal, 16)
    }

    var body: some View {
        MainContainerView(isBalanceInNavigationBarTitleVisible: $isBalanceInNavigationBarTitleVisible) {
            MainNavigationBar {
                SmallBalanceView()
                    .opacity(isBalanceInNavigationBarTitleVisible ? 1.0 : 0.0)
            }
        } balanceView: {
            balanceView
        } contentView: {

        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                viewModel.loadInitial()
            }
        }
    }
}
