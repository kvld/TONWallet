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
    }

    @State private var offset: CGFloat = .zero
    @State private var didScrollOnce = false

    @Binding var isBalanceInNavigationBarTitleVisible: Bool
    @Binding var containerHeight: CGFloat
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
                        Color.black.frame(height: Dimensions.balanceAreaHeight)
                            .overlay(alignment: .center, content: balanceView)

                        LazyVStack(spacing: 0, content: contentView)
                            .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
                            .background(
                                Color.white.clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
                            )
                            .background(Color.black)
                    }

                    GeometryReader { proxy in
                        let offset = proxy.frame(in: .named(mainScrollViewCoordinatesID)).minY
                        Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: offset)
                    }
                }
            }
            .coordinateSpace(name: mainScrollViewCoordinatesID)
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                didScrollOnce = didScrollOnce || offset != 0
                offset = value
                isBalanceInNavigationBarTitleVisible = -value >= 98
            }
            .background(
                VStack(spacing: 0) {
                    Color.black
                        .frame(height: Dimensions.balanceAreaHeight, alignment: .top)

                    Group {
                        offset > containerHeight / 2 ? Color.black : Color.white
                    }
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
                // Backport for pull-to-refresh on iOS 14
                ScrollViewFinderView { scrollView in
                    if scrollView.refreshControl != refreshControl {
                        scrollView.refreshControl = refreshControl
                    }
                }
                .frame(height: 0)
                .id("_scrollview_finder_\(didScrollOnce ? "appear" : "disappear")")
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
            findScrollView()
        }

        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            findScrollView()
        }

        func findScrollView() {
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
