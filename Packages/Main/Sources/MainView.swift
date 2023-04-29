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
    @State private var isRefreshControlActive = false

    @State private var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl(frame: .init(x: 0, y: 0, width: 32, height: 32))
        control.backgroundColor = .black
        control.tintColor = .white
        return control
    }()

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
    private var navigationBarBalanceView: some View {
        if case let .idle(model) = viewModel.state {
            SmallBalanceView(
                model: model.isLoading ? .updating : .idle(balance: model.balance.formatted, fiatRate: nil)
            )
            .opacity(model.isLoading || isBalanceInNavigationBarTitleVisible ? 1.0 : 0.0)
        }
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

                if model.canLoadMore {
                    ProgressView().padding(.vertical, 24)
                        .onAppear {
                            Task {
                                await viewModel.loadMoreTransactions()
                            }
                        }
                } else {
                    Spacer().frame(height: 60)
                }

                Spacer().frame(height: 40)
            }
        }
    }

    var body: some View {
        MainContainerView(
            isBalanceInNavigationBarTitleVisible: $isBalanceInNavigationBarTitleVisible,
            containerHeight: $containerHeight,
            isRefreshControlActive: $isRefreshControlActive,
            refreshControl: refreshControl
        ) {
            MainNavigationBar {
                navigationBarBalanceView
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
        .onAppear {
            refreshControl.addAction(
                .init { [weak refreshControl] _ in
                    Task { @MainActor in
                        isRefreshControlActive = true

                        await viewModel.refresh()

                        isRefreshControlActive = false
                        refreshControl?.endRefreshing()
                    }
                },
                for: .valueChanged
            )
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
