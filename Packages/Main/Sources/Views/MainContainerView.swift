//
//  Created by Vladislav Kiriukhin on 24.03.2023.
//

import Foundation
import SwiftUI
import SwiftUIBackports
import SwiftUIHelpers
import Combine

private let mainScrollViewCoordinatesID = "mainScroll"

struct MainContainerView<NavigationBar: View, BalanceView: View, ContentView: View>: View {
    private enum Dimensions {
        static var balanceAreaHeight: CGFloat { 248 }
        static var refreshControlHeight: CGFloat { 44 }
    }

    @State private var offset: CGFloat = .zero

    @State private var isLoading: Bool = false
    @State private var shouldExtendPadding: Bool = false

    @Binding var isBalanceInNavigationBarTitleVisible: Bool
    @ViewBuilder let navigationBar: () -> NavigationBar
    @ViewBuilder let balanceView: () -> BalanceView
    @ViewBuilder let contentView: () -> ContentView

    var body: some View {
        VStack(spacing: 0) {
            navigationBar()

            ScrollView {
                ZStack {
                    VStack(spacing: 0) {
                        Color.black
                            .frame(
                                height: shouldExtendPadding
                                    ? Dimensions.refreshControlHeight
                                : min(max(0, offset), Dimensions.refreshControlHeight)
                            )

                        RefreshControlView()
                            .padding(.top, -Dimensions.refreshControlHeight)

                        Color.clear.frame(height: Dimensions.balanceAreaHeight)
                            .overlay(alignment: .center, content: balanceView)

                        LazyVStack(spacing: 0, content: contentView)
                            .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
                    }

                    GeometryReader { proxy in
                        let offset = proxy.frame(in: .named(mainScrollViewCoordinatesID)).minY
                        Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: offset)
                    }
                }
            }
            .coordinateSpace(name: mainScrollViewCoordinatesID)
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                offset = value

                isBalanceInNavigationBarTitleVisible = -value >= 98

                if value >= Dimensions.refreshControlHeight {
                    isLoading = true
                } else if isLoading, value <= Dimensions.refreshControlHeight {
                    shouldExtendPadding = true

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            isLoading = false
                            shouldExtendPadding = false
                        }
                    }
                }
            }
            .background(
                VStack(spacing: 0) {
                    Color.black
                        .frame(
                            height: shouldExtendPadding
                                ? Dimensions.refreshControlHeight
                            : min(max(0, offset), Dimensions.refreshControlHeight)
                        )

                    Color.black
                        .frame(
                            height: max(offset + Dimensions.balanceAreaHeight, 0),
                            alignment: .top
                        )

                    Color.white
                        .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
                }
                .ignoresSafeArea()
            )
            .cornerRadius(16)
            .ignoresSafeArea(.container)
        }
        .background(
            Color.black.ignoresSafeArea(.container)
        )
    }
}

private struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
