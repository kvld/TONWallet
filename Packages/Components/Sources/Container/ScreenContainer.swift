//
//  Created by Vladislav Kiriukhin on 02.04.2023.
//

import Foundation
import SwiftUI
import SwiftUIHelpers
import SwiftUIBackports

public enum NavigationBarVisibilityState {
    case visible
    case hidden
    case preserveSpace
}

public enum NavigationBarButton {
    case back
    case cancel
    case done
}

public final class ScreenContainerProxy {
    public let navigationBarHeight: CGFloat
    public let containerSize: CGSize

    public var contentSize: CGSize {
        .init(width: containerSize.width, height: containerSize.height - navigationBarHeight)
    }

    init(navigationBarHeight: CGFloat, containerSize: CGSize) {
        self.navigationBarHeight = navigationBarHeight
        self.containerSize = containerSize
    }
}

public struct ScreenContainer<Content: View>: View {
    private let content: (ScreenContainerProxy) -> Content

    private let navigationBarTitle: String?
    private let navigationBarVisibility: NavigationBarVisibilityState
    private let navigationBarLeftButton: NavigationBarButton?
    private let navigationBarRightButton: NavigationBarButton?
    private let navigationBarTitleAlwaysVisible: Bool
    private let wrapInScrollView: Bool
    private let extendBarHeight: Bool
    private let backgroundColor: Color

    @State private var scrollOffset: CGFloat = 0
    @State private var navigationBarTitleAnchorOffset: CGFloat = 0

    private var navigationBarHeight: CGFloat {
        44.0 + (extendBarHeight ? 12.0 : 0.0)
    }

    public init(
        navigationBarVisibility: NavigationBarVisibilityState = .visible,
        navigationBarTitle: String? = nil,
        navigationBarTitleAlwaysVisible: Bool = false,
        navigationBarLeftButton: NavigationBarButton? = .back,
        navigationBarRightButton: NavigationBarButton? = nil,
        extendBarHeight: Bool = false,
        wrapInScrollView: Bool = true,
        backgroundColor: Color = .white,
        @ViewBuilder content: @escaping (ScreenContainerProxy) -> Content
    ) {
        self.navigationBarVisibility = navigationBarVisibility
        self.navigationBarTitle = navigationBarTitle
        self.navigationBarTitleAlwaysVisible = navigationBarTitleAlwaysVisible
        self.navigationBarLeftButton = navigationBarLeftButton
        self.navigationBarRightButton = navigationBarRightButton
        self.wrapInScrollView = wrapInScrollView
        self.extendBarHeight = extendBarHeight
        self.backgroundColor = backgroundColor
        self.content = content
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                ConditionallyScrollView(needScrollView: wrapInScrollView) {
                    let navigationBarHeight = navigationBarVisibility == .visible ? navigationBarHeight : 0

                    ZStack {
                        content(
                            ScreenContainerProxy(
                                navigationBarHeight: navigationBarHeight,
                                containerSize: proxy.size
                            )
                        )
                        .coordinateSpace(name: contentSpaceID)
                        .padding(.top, navigationBarHeight)

                        GeometryReader { proxy in
                            let proxyFrame = proxy.frame(in: .named(scrollViewSpaceID))
                            Color.clear
                                .preference(
                                    key: ScrollViewOffsetPreferenceKey.self,
                                    value: CGPoint(x: proxyFrame.minX, y: proxyFrame.minY)
                                )
                        }
                    }
                }
                .coordinateSpace(name: scrollViewSpaceID)
                .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                    scrollOffset = value.y
                }
                .onPreferenceChange(NavigationBarTitleVisibilityAnchorOffsetKey.self) { value in
                    navigationBarTitleAnchorOffset = value
                }
                .background(backgroundColor.ignoresSafeArea())

                ZStack(alignment: .top) {
                    let navigationBarOpacity = min(1.0, max(0.0, -scrollOffset / navigationBarHeight))

                    backgroundColor
                        .edgesIgnoringSafeArea(.top)
                        .opacity(navigationBarVisibility == .visible ? 1.0 : 0.0)

                    Group {
                        if navigationBarVisibility == .visible {
                            NavigationBar(
                                title: navigationBarTitle,
                                isTitleVisible: -scrollOffset > navigationBarTitleAnchorOffset
                                    || navigationBarTitleAlwaysVisible,
                                leftButton: navigationBarLeftButton,
                                rightButton: navigationBarRightButton
                            )
                        } else {
                            EmptyView()
                        }
                    }
                    .frame(height: navigationBarVisibility == .hidden ? 0 : navigationBarHeight)
                    .overlay(alignment: .bottom) {
                        if navigationBarVisibility == .visible {
                            Divider().foregroundColor(Color.separator)
                                .opacity(navigationBarOpacity)
                        }
                    }
                }
                .frame(maxHeight: navigationBarVisibility == .hidden ? 0 : navigationBarHeight)
            }
        }
    }
}

private struct ConditionallyScrollView<Content: View>: View {
    let needScrollView: Bool
    @ViewBuilder let content: () -> Content

    var body: some View {
        if needScrollView {
            ScrollView(content: content)
        } else {
            Group(content: content)
        }
    }
}

private struct NavigationBar: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let title: String?
    let isTitleVisible: Bool
    let leftButton: NavigationBarButton?
    let rightButton: NavigationBarButton?

    var body: some View {
        ZStack(alignment: .center) {
            HStack(alignment: .center, spacing: 8) {
                HStack(alignment: .center, spacing: 8) {
                    switch leftButton {
                    case .back:
                        Image("back")
                            .renderingMode(.template)
                            .frame(
                                width: FontConfiguration.body.regular.pointSize * 0.5,
                                height: FontConfiguration.body.regular.pointSize
                            )
                            .foregroundColor(Color.accent.app)

                        Text("Back")
                            .fontConfiguration(.body.regular)
                            .frame(height: FontConfiguration.body.regular.pointSize)
                            .padding(.top, -2)

                    case .cancel:
                        Text("Cancel")
                            .fontConfiguration(.body.regular)
                            .frame(height: FontConfiguration.body.regular.pointSize)
                            .padding(.leading, 7)

                    case .done, .none:
                        EmptyView()
                    }
                }
                .onTapWithFeedback {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(Color.accent.app)
                .padding(.leading, 9)

                Spacer()

                HStack(spacing: 0) {
                    switch rightButton {
                    case .back, .cancel, .none:
                        EmptyView()

                    case .done:
                        Text("Done")
                            .fontConfiguration(.body.semibold)
                            .frame(height: FontConfiguration.body.semibold.pointSize)
                            .padding(.trailing, 7)
                    }
                }
                .onTapWithFeedback {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(Color.accent.app)
                .padding(.trailing, 9)
            }

            HStack(alignment: .center, spacing: 8) {
                Spacer(minLength: 0)

                if let title = title, isTitleVisible {
                    Text(title)
                        .fontConfiguration(.body.semibold)
                        .frame(height: FontConfiguration.body.semibold.pointSize)
                        .foregroundColor(.text.primary)
                        .transition(.opacity.animation(.easeInOut(duration: 0.15)))
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 77)
                }

                Spacer(minLength: 0)
            }
        }
    }
}

private struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero

    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
}
