//
//  Created by Vladislav Kiriukhin on 24.04.2023.
//

import SwiftUI
import UIKit

public struct RoundedCorner: Shape {
    private let radius: CGFloat
    private let corners: UIRectCorner

    public init(
        radius: CGFloat = .infinity,
        corners: UIRectCorner = .allCorners
    ) {
        self.radius = radius
        self.corners = corners
    }

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
