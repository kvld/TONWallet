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
                BubbleTextView(message: message)
                    .padding(.top, 8)
                    .padding(.leading, -5)
            }
        }
        .padding(.vertical, 16)
        .zIndex(99)
    }
}
