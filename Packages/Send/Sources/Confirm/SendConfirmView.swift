//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import SwiftUI
import SendState
import SwiftUIHelpers
import Components

struct SendConfirmView: View {
    @ObservedObject var viewModel: SendViewModel

    @State private var comment: String = ""

    var body: some View {
        ZStack(alignment: .bottom) {
            ScreenContainer(
                navigationBarTitle: "Send TON",
                navigationBarTitleAlwaysVisible: true,
                extendBarHeight: true,
                backgroundColor: .background.grouped
            ) { proxy in
                VStack(spacing: 0) {
                    TableSectionView(title: "Comment (optional)")

                    VStack(spacing: 6) {
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $comment)
                                .fontConfiguration(.body.regular)
                                .foregroundColor(.text.primary)
                                .frame(height: 72)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)

                            if comment.isEmpty {
                                Text("Description of the payment")
                                    .fontConfiguration(.body.regular)
                                    .foregroundColor(.text.tertiary)
                                    .padding(.horizontal, 16)
                                    .padding(.top, 11)
                                    .allowsHitTesting(false)
                            }
                        }
                        .background(Color.background.content)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)

                        HStack(spacing: 0) {
                            Text("The comment is visible to everyone. You must include the note when sending to an exchange.")
                                .multilineTextAlignment(.leading)
                                .lineLimit(3)
                                .fontConfiguration(.caption1)
                                .foregroundColor(.text.secondary)

                            Spacer(minLength: 0)
                        }
                        .padding(.bottom, 6)
                        .padding(.horizontal, 32)
                    }

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

                    Spacer(minLength: 88)
                }
                .frame(minHeight: proxy.contentSize.height)
            }

            VStack(spacing: 0) {
                Spacer()

                if let error = viewModel.state.error {
                    AlertView(
                        isPresented: .init(
                            get: { viewModel.state.error != nil },
                            set: { !$0 ? viewModel.state.error = nil : nil }
                        ),
                        title: error.title,
                        message: error.error
                    )
                    .padding([.horizontal, .bottom], 16)
                }

                Button("Confirm and send") {
                    Task {
                        await viewModel.confirmTransaction(comment: comment)
                    }
                }
                .buttonStyle(.action())
                .loading(viewModel.state.isLoading)
                .padding(.horizontal, 16)

                DeviceRelatedBottomSpacer()
            }
        }
        .onAppear {
            comment = viewModel.state.comment ?? ""
        }
        .onChange(of: comment) { newValue in
            comment = String(comment.prefix(256))
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
