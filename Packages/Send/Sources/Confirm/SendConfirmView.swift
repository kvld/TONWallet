//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import SwiftUI
import SendState
import SwiftUIHelpers
import Components

struct SendConfirmView: View {
    @ObservedObject var viewModel: SendViewModel

    var body: some View {
        ScreenContainer(
            navigationBarTitle: "Send TON",
            navigationBarTitleAlwaysVisible: true,
            extendBarHeight: true,
            backgroundColor: .background.grouped
        ) { proxy in
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    TableSectionView(title: "Summary")

                    VStack(spacing: 0) {
                        HStack {
                            Text("Recipient")
                            Spacer()
                            Text(viewModel.state.address?.shortened(partLength: 4) ?? "")
                        }
                        .fontConfiguration(.body.regular)
                        .foregroundColor(.text.primary)
                        .padding(.horizontal, 16)
                        .frame(height: 44)

                        Divider().foregroundColor(Color.separator).padding(.leading, 16)

                        HStack {
                            Text("Amount")
                            Spacer()
                            HStack(spacing: 2) {
                                Image("ton").resizable().frame(width: 18, height: 18)
                                Text(viewModel.state.amount?.formatted.formatted ?? "")
                            }
                        }
                        .fontConfiguration(.body.regular)
                        .foregroundColor(.text.primary)
                        .padding(.horizontal, 16)
                        .frame(height: 44)

                        Divider().foregroundColor(Color.separator).padding(.leading, 16)

                        if let fee = viewModel.state.fee?.formatted.formatted {
                            HStack {
                                Text("Fee")
                                Spacer()
                                HStack(spacing: 2) {
                                    Image("ton").resizable().frame(width: 18, height: 18)
                                    Text("≈ \(fee)")
                                }
                            }
                            .fontConfiguration(.body.regular)
                            .foregroundColor(.text.primary)
                            .padding(.horizontal, 16)
                            .frame(height: 44)
                        }
                    }
                    .background(Color.background.content)
                    .cornerRadius(10)
                    .padding(.horizontal, 16)

                    Spacer()
                }

                VStack(spacing: 0) {
                    Spacer()

                    Button("Confirm and send") {
                        Task {
                            await viewModel.confirmTransaction()
                        }
                    }
                    .buttonStyle(.action())
                    .loading(viewModel.state.isLoading)
                    .padding(.horizontal, 16)

                    DeviceRelatedBottomSpacer()
                }
            }
            .frame(height: proxy.contentSize.height)
        }
    }
}

private struct TableSectionView: View {
    let title: String

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            HStack {
                Text(title.uppercased())
                    .foregroundColor(.text.secondary)
                    .fontConfiguration(.footnote)
                Spacer()
            }
            .padding(.bottom, 4)
        }
        .frame(height: 44)
        .padding(.horizontal, 32)
    }
}
