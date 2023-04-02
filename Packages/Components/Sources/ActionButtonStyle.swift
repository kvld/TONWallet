//
//  Created by Vladislav Kiriukhin on 29.03.2023.
//

import Foundation
import SwiftUI

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

    public init(color: ActionButtonColor, background: ActionButtonBackground) {
        self.background = background
        self.color = color
    }

    public func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 0) {
            Spacer()

            HStack(spacing: 0) {
                Spacer(minLength: 4)

                configuration.label
                    .fontConfiguration(.body.semibold)
                    .foregroundColor(textColor)

                Spacer(minLength: 4)
            }

            Spacer()
        }
        .frame(height: 50)
        .background(backgroundColor)
        .cornerRadius(12)
        .opacity(configuration.isPressed ? 0.6 : 1.0)
    }
}

extension ButtonStyle where Self == ActionButtonStyle {
    public static func action(
        color: ActionButtonColor = .accent,
        background: ActionButtonBackground = .filled
    ) -> ActionButtonStyle {
        ActionButtonStyle(color: color, background: background)
    }
}
