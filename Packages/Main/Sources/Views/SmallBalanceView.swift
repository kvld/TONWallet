//
//  Created by Vladislav Kiriukhin on 24.04.2023.
//

import SwiftUI
import Components

struct SmallBalanceView: View {
    let model: Model

    var body: some View {
        switch model {
        case let .idle(balance, fiatRate):
            SmallBalanceIdleView(balance: balance, fiatRate: fiatRate)
        case .updating:
            SmallBalanceLoadingView(title: "Updating")
        }
    }

    enum Model {
        case updating
        case idle(balance: String, fiatRate: String?)
    }
}

private struct SmallBalanceLoadingView: View {
    let title: String

    var body: some View {
        HStack(spacing: 8) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .text.overlay))
                .frame(width: 18, height: 18)

            Text(title)
                .fontConfiguration(.body.semibold)
                .foregroundColor(.text.overlay)
        }
    }
}

private struct SmallBalanceIdleView: View {
    let balance: String
    let fiatRate: String?

    var body: some View {
        HStack(alignment: .top, spacing: 2) {
            Image("ton")
                .resizable()
                .frame(width: 18, height: 18)
                .padding(.top, 2)

            VStack(alignment: .center, spacing: -2) {
                Text(balance)
                    .fontConfiguration(.body.semibold)
                    .foregroundColor(.text.overlay)

                if let fiatRate {
                    Text("≈ \(fiatRate)")
                        .fontConfiguration(.caption1)
                        .foregroundColor(.text.overlay)
                        .opacity(0.6)
                }
            }
        }
    }
}
