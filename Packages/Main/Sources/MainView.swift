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
    @State private var containerHeight: CGFloat = 0.0

    @ViewBuilder
    private var balanceView: some View {
        VStack(spacing: 0) {
            Spacer()

            if case .preparing = viewModel.state {
                EmptyView()
            } else {
                LargeBalanceView(
                    address: viewModel.state.model.flatMap { ($0.address.short, $0.address.full) },
                    balanceInteger: viewModel.state.model?.balance.integer,
                    balanceFraction: viewModel.state.model?.balance.formattedFractionalOrEmpty
                )
            }

            Spacer().frame(height: 74)

            HStack(spacing: 12) {
                Button("Receive", action: { })
                    .buttonStyle(
                        .action(
                            color: .accentMain,
                            icon: Image("arrow_bottom_left").eraseToAnyView()
                        )
                    )

                Button("Send", action: { })
                    .buttonStyle(
                        .action(
                            color: .accentMain,
                            icon: Image("arrow_bottom_left")
                                .rotationEffect(.degrees(180))
                                .eraseToAnyView()
                        )
                    )
            }
        }
        .padding(.bottom, 16)
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .preparing:
            EmptyView()

        case .loading:
            LoadingStateView()
                .frame(height: containerHeight, alignment: .center)
                .padding(.top, -56)

        case let .idle(model):
            if model.transactions.isEmpty {
                EmptyStateView()
                    .frame(height: containerHeight, alignment: .center)
                    .padding(.top, -56)
            } else {
                ForEach(model.transactions) { item in
                    switch item {
                    case let .date(date):
                        TransactionListDateView(date: date).padding(.horizontal, 16)
                    case let .transaction(info):
                        EmptyView()
                        TransactionListItemView(model: info).padding(.horizontal, 16)
                        Divider().background(Color.separator).padding(.leading, 16)
                    }
                }

                Spacer().frame(height: 100)
            }
        }
    }

    var body: some View {
        MainContainerView(
            isBalanceInNavigationBarTitleVisible: $isBalanceInNavigationBarTitleVisible,
            containerHeight: $containerHeight
        ) {
            MainNavigationBar {
                if case let .idle(model) = viewModel.state {
                    SmallBalanceView(
                        model: .idle(balance: model.balance.formatted, fiatRate: nil)
                    )
                    .opacity(isBalanceInNavigationBarTitleVisible ? 1.0 : 0.0)
                }
            }
        } balanceView: {
            balanceView
        } contentView: {
            contentView
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                viewModel.loadInitial()
            }
        }
    }
}

extension MainViewState {
    fileprivate var model: MainViewState.Model? {
        if case let .idle(model) = self {
            return model
        }
        return nil
    }
}
