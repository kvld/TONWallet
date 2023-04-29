//
//  Created by Vladislav Kiriukhin on 29.03.2023.
//

import Foundation
import SwiftUI
import SwiftUIHelpers

public enum ActionButtonBackground {
    case filled
    case outline
}

public enum ActionButtonColor {
    case accent
    case accentMain

    var backgroundColor: Color {
        switch self {
        case .accent:
            return .accent.app
        case .accentMain:
            return .accent.main
        }
    }

    var titleColor: Color {
        .text.overlay
    }
}

public struct ActionButtonStyle: ButtonStyle {
    private let background: ActionButtonBackground
    private let color: ActionButtonColor
    private let icon: AnyView?

    @Environment(\.isLoading) var isLoading
    @Environment(\.isEnabled) var isEnabled

    private var textColor: Color {
        switch background {
        case .filled:
            return color.titleColor
        case .outline:
            return color.backgroundColor
        }
    }

    private var backgroundColor: Color {
        switch background {
        case .filled:
            return color.backgroundColor
        case .outline:
            return .clear
        }
    }

    public init(color: ActionButtonColor, background: ActionButtonBackground, icon: AnyView?) {
        self.background = background
        self.color = color
        self.icon = icon
    }

    public func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 0) {
            Spacer()

            ZStack {
                HStack(spacing: 0) {
                    Spacer(minLength: 4)

                    if let icon {
                        icon.frame(width: 24, height: 24)
                            .padding(.trailing, 2)
                    }

                    configuration.label
                        .fontConfiguration(.body.semibold)
                        .padding(.bottom, 2)

                    Spacer(minLength: 4)
                }
                .foregroundColor(textColor)

                if isLoading {
                    HStack(alignment: .center) {
                        Spacer()
                        
                        LoadingIndicator(lineWidth: 2.3)
                            .foregroundColor(textColor)
                            .frame(width: 16, height: 16)
                            .padding(.trailing, 16)
                    }
                }
            }

            Spacer()
        }
        .frame(height: 50)
        .background(backgroundColor)
        .cornerRadius(12)
        .opacity(configuration.isPressed ? 0.6 : 1.0)
        .opacity(isEnabled ? 1.0 : 0.4)
        .allowsHitTesting(isEnabled)
    }
}

extension ButtonStyle where Self == ActionButtonStyle {
    public static func action(
        color: ActionButtonColor = .accent,
        background: ActionButtonBackground = .filled,
        icon: AnyView? = nil
    ) -> ActionButtonStyle {
        ActionButtonStyle(color: color, background: background, icon: icon)
    }
}
