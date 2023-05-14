//
//  Created by Vladislav Kiriukhin on 14.05.2023.
//

import SwiftUI

public struct BubbleTextView: View {
    public let message: String

    public init(message: String) {
        self.message = message
    }

    public var body: some View {
        Text(message)
            .foregroundColor(.text.primary)
            .fontConfiguration(.subheadline.regular)
            .padding(.vertical, 8)
            .padding(.leading, 16)
            .padding(.trailing, 10)
            .background(Color.background.grouped)
            .clipShape(BubbleShape())
    }
}

private struct BubbleShape: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height

        let bezierPath = UIBezierPath()

        bezierPath.move(to: CGPoint(x: 20, y: height))
        bezierPath.addLine(to: CGPoint(x: width - 15, y: height))
        bezierPath.addCurve(
            to: CGPoint(x: width, y: height - 15),
            controlPoint1: CGPoint(x: width - 8, y: height),
            controlPoint2: CGPoint(x: width, y: height - 8)
        )
        bezierPath.addLine(to: CGPoint(x: width, y: 15))
        bezierPath.addCurve(
            to: CGPoint(x: width - 15, y: 0),
            controlPoint1: CGPoint(x: width, y: 8),
            controlPoint2: CGPoint(x: width - 8, y: 0)
        )
        bezierPath.addLine(to: CGPoint(x: 20, y: 0))
        bezierPath.addCurve(
            to: CGPoint(x: 5, y: 15),
            controlPoint1: CGPoint(x: 12, y: 0),
            controlPoint2: CGPoint(x: 5, y: 8)
        )
        bezierPath.addLine(to: CGPoint(x: 5, y: height - 10))
        bezierPath.addCurve(
            to: CGPoint(x: 0, y: height),
            controlPoint1: CGPoint(x: 5, y: height - 1),
            controlPoint2: CGPoint(x: 0, y: height)
        )
        bezierPath.addLine(to: CGPoint(x: -1, y: height))
        bezierPath.addCurve(
            to: CGPoint(x: 12, y: height - 4),
            controlPoint1: CGPoint(x: 4, y: height + 1),
            controlPoint2: CGPoint(x: 8, y: height - 1)
        )
        bezierPath.addCurve(
            to: CGPoint(x: 20, y: height),
            controlPoint1: CGPoint(x: 15, y: height),
            controlPoint2: CGPoint(x: 20, y: height)
        )

        return Path(bezierPath.cgPath)
    }
}
