//
//  Created by Vladislav Kiriukhin on 24.03.2023.
//

import Foundation
import SwiftUI
import SwiftUIBackports
import SwiftUIHelpers
import Combine

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel

    @State private var offset: CGFloat = .zero

    @State private var isLoading: Bool = false
    @State private var shouldExtendPadding: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            MainNavigationBar()

            ScrollView {
                ZStack {
                    VStack(spacing: 0) {
                        Color.black
                            .frame(height: shouldExtendPadding ? 44 : min(max(0, offset), 44))

                        RefreshControlView()
                            .padding(.top, -44)

                        Color.clear.frame(height: 200)

                        LazyVStack(spacing: 0) {
                        }
                        .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
                    }

                    GeometryReader { proxy in
                        let offset = proxy.frame(in: .named("scroll")).minY
                        Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: offset)
                    }
                }
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                offset = value

                if value >= 44 {
                    isLoading = true
                } else if isLoading, value <= 44 {
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
                            height: max(offset + 244, 0),
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
            Color.black
                .ignoresSafeArea(.container)
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                viewModel.loadInitial()
            }
        }
    }
}

struct RefreshControlView: View {
    var body: some View {
        HStack {
            Spacer()

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.yellow))
                .frame(width: 36, height: 36)

            Spacer()
        }
        .frame(height: 44)
        .background(Color.black)
    }
}

private struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: .init())
    }
}

struct MainNavigationBar: View {
    var body: some View {
        HStack {
            Image(systemName: "viewfinder")
                .resizable()
                .frame(width: 24, height: 24)
                .onTapWithFeedback {

                }

            Spacer()

            Spacer()

            Image(systemName: "gear")
                .resizable()
                .frame(width: 24, height: 24)
                .onTapWithFeedback {

                }
        }
        .padding(.horizontal, 16)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 44)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
