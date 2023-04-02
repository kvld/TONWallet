import CoreFoundation
import SwiftUI

extension View {
    public func containerSizeChanged(_ callback: @escaping (CGSize) -> Void) -> some View {
        modifier(SizeUpdater(callback: callback))
    }
}

private struct SizeUpdater: ViewModifier {
    let callback: (CGSize) -> Void

    func body(content: Content) -> some View {
        ZStack {
            content

            GeometryReader { proxy in
                Color.clear.preference(key: SizePreference.self, value: proxy.size)
            }
            .onPreferenceChange(SizePreference.self, perform: callback)
        }
    }
}

private struct SizePreference: PreferenceKey {
    static var defaultValue: CGSize { .zero }
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
