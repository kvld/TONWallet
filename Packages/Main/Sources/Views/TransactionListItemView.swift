//
//  Created by Vladislav Kiriukhin on 29.04.2023.
//

import Foundation
import SwiftUI
import Components

struct TransactionListItemView: View {
    let model: MainViewState.TransactionListModel.Info

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Image("ton")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .padding(.trailing, 2)
                    .padding(.bottom, 1)

                HStack(alignment: .center, spacing: 0) {
                    Text(model.amount.integer)
                        .fontConfiguration(._untyped.balanceInteger)

                    Text(model.amount.formattedFractionalOrEmpty)
                        .fontConfiguration(.subheadline.regular)
                        .padding(.top, 2)
                }
                .foregroundColor(model.isIncome ? .system.green : .system.red)

                Text(model.isIncome ? "from" : "to")
                    .fontConfiguration(.subheadline.regular)
                    .foregroundColor(.text.secondary)
                    .padding(.leading, 4)
                    .padding(.top, 2)

                Spacer()

                Text(model.time)
                    .fontConfiguration(.subheadline.regular)
                    .foregroundColor(.text.secondary)
            }

            Text(model.address)
                .padding(.top, 6)
                .fontConfiguration(.subheadline.mono)

            Text("\(model.fee.formatted) fee")
                .padding(.top, 8)
                .fontConfiguration(.subheadline.regular)
                .foregroundColor(.text.secondary)

            if let message = model.message {
                Text(message)
                    .foregroundColor(.text.primary)
                    .fontConfiguration(.subheadline.regular)
                    .padding(.vertical, 8)
                    .padding(.leading, 16)
                    .padding(.trailing, 10)
                    .background(Color.background.grouped)
                    .clipShape(BubbleShape())
                    .padding(.top, 8)
                    .padding(.leading, -5)
            }
        }
        .padding(.vertical, 16)
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
