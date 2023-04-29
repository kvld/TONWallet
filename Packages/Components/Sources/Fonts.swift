//
//  Created by Vladislav Kiriukhin on 29.03.2023.
//

import Foundation
import SwiftUI
import UIKit

public struct FontConfiguration {
    let pointSize: CGFloat
    let weight: Font.Weight
    let lineHeight: CGFloat?
    let design: Font.Design
}

extension FontConfiguration {
    public static var title1: FontConfiguration {
        .init(pointSize: 28, weight: .semibold, lineHeight: 32, design: .default)
    }

    public static var caption1: FontConfiguration {
        .init(pointSize: 13, weight: .regular, lineHeight: 16, design: .default)
    }

    public static var callout: FontConfiguration {
        .init(pointSize: 16, weight: .regular, lineHeight: 22, design: .default)
    }

    public static var title3: FontConfiguration {
        .init(pointSize: 20, weight: .regular, lineHeight: 24, design: .default)
    }

    public static var footnote: FontConfiguration {
        .init(pointSize: 13, weight: .regular, lineHeight: 18, design: .default)
    }

    public struct Body {
        public let regular: FontConfiguration = .init(pointSize: 17, weight: .regular, lineHeight: 22, design: .default)

        public let semibold: FontConfiguration = .init(
            pointSize: 17,
            weight: .semibold,
            lineHeight: 22,
            design: .default
        )

        public let mono: FontConfiguration = .init(
            pointSize: 17,
            weight: .regular,
            lineHeight: 22,
            design: .monospaced
        )
    }

    public static var body: Body {
        .init()
    }

    public struct Subheadline {
        public let regular: FontConfiguration = .init(pointSize: 15, weight: .regular, lineHeight: 18, design: .default)

        public let semibold: FontConfiguration = .init(
            pointSize: 15,
            weight: .semibold,
            lineHeight: 18,
            design: .default
        )

        public let mono: FontConfiguration = .init(
            pointSize: 15,
            weight: .regular,
            lineHeight: 18,
            design: .monospaced
        )
    }

    public static var subheadline: Subheadline {
        .init()
    }

    public struct Rounded {
        public let balanceLarge: FontConfiguration = .init(
            pointSize: 48,
            weight: .semibold,
            lineHeight: nil,
            design: .rounded
        )

        public let balanceSmall: FontConfiguration = .init(
            pointSize: 30,
            weight: .semibold,
            lineHeight: nil,
            design: .rounded
        )
    }

    public static var rounded: Rounded {
        .init()
    }

    public struct Untyped {
        public let balanceInteger: FontConfiguration = .init(
            pointSize: 19,
            weight: .medium,
            lineHeight: nil,
            design: .default
        )
    }

    public static var _untyped: Untyped {
        .init()
    }
}

extension View {
    @ViewBuilder
    public func fontConfiguration(_ configuration: FontConfiguration) -> some View {
        let lineHeight = UIFont.systemFont(ofSize: configuration.pointSize).lineHeight

        if let configurationLineHeight = configuration.lineHeight {
            let multiplier = configurationLineHeight / lineHeight

            _lineHeightMultiple(multiplier).font(
                Font.system(size: configuration.pointSize, weight: configuration.weight, design: configuration.design)
            )
        } else {
            font(
                Font.system(size: configuration.pointSize, weight: configuration.weight, design: configuration.design)
            )
        }
    }
}
