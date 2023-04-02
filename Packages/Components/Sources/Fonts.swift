//
//  Created by Vladislav Kiriukhin on 29.03.2023.
//

import Foundation
import SwiftUI
import UIKit

public struct FontConfiguration {
    let pointSize: CGFloat
    let weight: Font.Weight
    let lineHeight: CGFloat
}

extension FontConfiguration {
    public static var title1: FontConfiguration {
        .init(pointSize: 28, weight: .semibold, lineHeight: 32)
    }

    public static var caption1: FontConfiguration {
        .init(pointSize: 13, weight: .regular, lineHeight: 16)
    }

    public static var callout: FontConfiguration {
        .init(pointSize: 16, weight: .regular, lineHeight: 22)
    }

    public static var title3: FontConfiguration {
        .init(pointSize: 20, weight: .regular, lineHeight: 24)
    }

    public static var footnote: FontConfiguration {
        .init(pointSize: 13, weight: .regular, lineHeight: 18)
    }

    public struct Body {
        public let regular: FontConfiguration = .init(pointSize: 17, weight: .regular, lineHeight: 22)

        public let semibold: FontConfiguration = .init(pointSize: 17, weight: .semibold, lineHeight: 22)
    }

    public static var body: Body {
        .init()
    }

    public struct Subheadline {
        public let regular: FontConfiguration = .init(pointSize: 15, weight: .regular, lineHeight: 18)

        public let semibold: FontConfiguration = .init(pointSize: 15, weight: .semibold, lineHeight: 18)
    }

    public static var subheadline: Subheadline {
        .init()
    }
}

extension View {
    public func fontConfiguration(_ configuration: FontConfiguration) -> some View {
        let lineHeight = UIFont.systemFont(ofSize: configuration.pointSize).lineHeight
        let multiplier = configuration.lineHeight / lineHeight

        return _lineHeightMultiple(multiplier)
            .font(Font.system(size: configuration.pointSize, weight: configuration.weight))
    }
}
