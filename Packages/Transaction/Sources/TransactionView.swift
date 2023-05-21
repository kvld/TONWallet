//
//  Created by Vladislav Kiriukhin on 14.05.2023.
//

import SwiftUI
import SwiftUIHelpers
import Components

struct TransactionView: View {
    @ObservedObject var viewModel: TransactionViewModel

    var body: some View {
        VStack(spacing: 0) {
            NavigationBar(title: "Transaction", isTitleVisible: true, leftButton: nil, rightButton: .done)
                .frame(height: 56)

            HStack(spacing: 4) {
                Image("ton")
                    .resizable()
                    .frame(width: 48, height: 48)

                HStack(alignment: .center, spacing: 0) {
                    Text(viewModel.amountInteger)
                        .fontConfiguration(.rounded.balanceLarge)

                    if let amountFractional = viewModel.amountFractional {
                        Text(amountFractional)
                            .fontConfiguration(.rounded.balanceSmall)
                            .padding(.top, 13)
                    }
                }
                .foregroundColor(viewModel.isIncome ? Color.system.green : Color.system.red)
            }
            .padding(.top, 20)
            .padding(.horizontal, 32)

            Text("\(viewModel.fee) transaction fee")
                .fontConfiguration(.subheadline.regular)
                .foregroundColor(.text.secondary)
                .padding(.top, 6)
                .padding(.horizontal, 32)

            Text(viewModel.date)
                .fontConfiguration(.subheadline.regular)
                .foregroundColor(.text.secondary)
                .padding(.top, 4)
                .padding(.horizontal, 32)

            if let message = viewModel.message {
                BubbleTextView(message: message)
                    .padding(.horizontal, 48)
                    .padding(.top, 16)
            }

            HStack {
                Text("Details".uppercased())
                    .fontConfiguration(.footnote)
                    .foregroundColor(.text.secondary)
                    .padding(.bottom, 4)
                    .frame(height: 44, alignment: .bottomLeading)

                Spacer()
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)

            Group {
                HStack {
                    Text(viewModel.isIncome ? "Sender address" : "Recipient address")
                        .foregroundColor(.text.primary)
                    Spacer()

                    Text(viewModel.address)
                        .foregroundColor(.text.secondary)
                }
                .fontConfiguration(.body.regular)
                .frame(height: 44)
                .padding(.horizontal, 16)

                Divider().foregroundColor(Color.separator).padding(.leading, 16)

                HStack {
                    Text("Transaction")
                        .foregroundColor(.text.primary)
                    Spacer()

                    Text(viewModel.transactionID)
                        .foregroundColor(.text.secondary)
                }
                .fontConfiguration(.body.regular)
                .frame(height: 44)
                .padding(.horizontal, 16)

                Divider().foregroundColor(Color.separator).padding(.leading, 16)

                HStack {
                    Text("View in explorer")
                        .foregroundColor(.accent.app)
                        .onTapWithFeedback {
                            viewModel.showTransactionInExplorer()
                        }
                    Spacer()
                }
                .fontConfiguration(.body.regular)
                .frame(height: 44)
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }

            Button("Send TON to this address") {
                viewModel.sendToAddress()
            }
            .buttonStyle(.action())
            .padding(.horizontal, 16)

            DeviceRelatedBottomSpacer()
        }
    }
}
