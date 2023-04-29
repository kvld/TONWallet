//
//  Created by Vladislav Kiriukhin on 24.03.2023.
//

import Foundation
import SwiftUI
import SwiftUIBackports
import SwiftUIHelpers
import Combine

private let mainScrollViewCoordinatesID = "mainScroll"

typealias RefreshEndToken = () -> Void

struct MainContainerView<NavigationBar: View, BalanceView: View, ContentView: View>: View {
    private enum Dimensions {
        static var balanceAreaHeight: CGFloat { 248 }
        static var refreshControlHeight: CGFloat { 60 }
    }

    @State private var offset: CGFloat = .zero

    @State private var isInRefresh = false

    @Binding var isBalanceInNavigationBarTitleVisible: Bool
    @Binding var containerHeight: CGFloat
    @Binding var isRefreshControlActive: Bool
    let refreshControl: UIRefreshControl
    @ViewBuilder let navigationBar: () -> NavigationBar
    @ViewBuilder let balanceView: () -> BalanceView
    @ViewBuilder let contentView: () -> ContentView

    var body: some View {
        VStack(spacing: 0) {
            navigationBar()

            ScrollView {
                ZStack {
                    VStack(spacing: 0) {
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
                // to prevent jumps in pull-to-refresh
                if abs(offset - value) > 50, isInRefresh != isRefreshControlActive {
                    isInRefresh.toggle()
                }

                offset = value
                isBalanceInNavigationBarTitleVisible = -value >= 98
            }
            .background(
                VStack(spacing: 0) {
                    Color.black
                        .frame(
                            height: max(
                                offset
                                    + Dimensions.balanceAreaHeight
                                    + (isInRefresh ? Dimensions.refreshControlHeight : 0),
                                0
                            ),
                            alignment: .top
                        )

                    Color.white
                        .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
                        .containerSizeChanged { size in
                            if containerHeight == 0.0 {
                                containerHeight = size.height
                            }
                        }
                }
                .ignoresSafeArea()
            )
            .cornerRadius(16)
            .ignoresSafeArea(.container)
            .overlay {
                ScrollViewFinderView { scrollView in
                    scrollView.refreshControl = refreshControl
                }
                .frame(height: 0)
            }
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

private struct ScrollViewFinderView: UIViewRepresentable {
    let updateScrollView: (UIScrollView) -> Void

    final class View: UIView {
        var updateScrollView: ((UIScrollView) -> Void)?

        override func didMoveToWindow() {
            super.didMoveToWindow()

            func traverse(_ view: UIView) -> UIScrollView? {
                if let scrollView = view as? UIScrollView {
                    return scrollView
                }

                for subview in view.subviews {
                    if let scrollView = traverse(subview) {
                        return scrollView
                    }
                }

                return nil
            }

            if let window, let scrollView = traverse(window) {
                updateScrollView?(scrollView)
            }
        }
    }

    func makeUIView(context: Context) -> View {
        let view = View()
        view.updateScrollView = updateScrollView
        return view
    }

    func updateUIView(_ uiView: View, context: Context) {
        uiView.updateScrollView = updateScrollView
    }
}
