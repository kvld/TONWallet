//
//  Created by Vladislav Kiriukhin on 14.05.2023.
//

import SwiftUI
import SwiftUIHelpers
import Components

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    @State private var creatingWalletID: String?

    var body: some View {
        ScreenContainer(
            navigationBarTitle: "Wallet Settings",
            navigationBarTitleAlwaysVisible: true,
            navigationBarLeftButton: .cancel,
            extendBarHeight: true,
            backgroundColor: .background.grouped
        ) { proxy in
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    TableSectionView(title: "General")

                    VStack(spacing: 0) {
                        HStack {
                            Text("Active address")
                            Spacer()

                            Menu {
                                ForEach(viewModel.wallets) { wallet in
                                    Button {
                                        creatingWalletID = wallet.id
                                        Task {
                                            await viewModel.switchWallet(to: wallet.id)
                                            creatingWalletID = nil
                                        }
                                    } label: {
                                        HStack {
                                            Text(wallet.title)
                                            Spacer()

                                            if wallet.isActive {
                                                Image(systemName: "checkmark")
                                            } else if wallet.id == creatingWalletID {
                                                ProgressView()
                                            }
                                        }
                                    }
                                }
                            } label: {
                                HStack(alignment: .center, spacing: 6) {
                                    Text(viewModel.wallets.first(where: { $0.isActive })?.title ?? "")
                                        .fontConfiguration(.body.regular)

                                    Image("menu_arrow").resizable()
                                        .frame(width: 12, height: 12)
                                        .padding(.top, 2)
                                }
                                .foregroundColor(.accent.app)
                            }
                        }
                        .fontConfiguration(.body.regular)
                        .foregroundColor(.text.primary)
                        .padding(.horizontal, 16)
                        .frame(height: 44)

                        Divider().foregroundColor(Color.separator).padding(.leading, 16)

                        HStack {
                            Text("Primary currency")
                            Spacer()
                            HStack(alignment: .center, spacing: 6) {
                                Text("USD")
                                    .fontConfiguration(.body.regular)

                                Image("menu_arrow").resizable()
                                    .frame(width: 12, height: 12)
                                    .padding(.top, 2)
                            }
                            .foregroundColor(.accent.app)
                        }
                        .fontConfiguration(.body.regular)
                        .foregroundColor(.text.primary)
                        .padding(.horizontal, 16)
                        .frame(height: 44)
                    }
                    .background(Color.background.content)
                    .cornerRadius(10)
                    .padding(.horizontal, 16)

                    TableSectionView(title: "Security")

                    VStack(spacing: 0) {
                        HStack {
                            Text("Show recovery phrase")
                            Spacer()
                            Image("back").resizable()
                                .frame(width: 7, height: 12)
                                .rotationEffect(.degrees(180))
                                .foregroundColor(.text.secondary)
                                .opacity(0.5)
                        }
                        .fontConfiguration(.body.regular)
                        .foregroundColor(.text.primary)
                        .padding(.horizontal, 16)
                        .frame(height: 44)
                        .onTapWithHighlight {
                            Task {
                                await viewModel.showMnemonicWords()
                            }
                        }

                        Divider().foregroundColor(Color.separator).padding(.leading, 16)

                        HStack {
                            Text("Change passcode")
                            Spacer()
                            Image("back").resizable()
                                .frame(width: 7, height: 12)
                                .rotationEffect(.degrees(180))
                                .foregroundColor(.text.secondary)
                                .opacity(0.5)
                        }
                        .fontConfiguration(.body.regular)
                        .foregroundColor(.text.primary)
                        .padding(.horizontal, 16)
                        .frame(height: 44)
                        .onTapWithHighlight {
                            Task {
                                await viewModel.changePasscode()
                            }
                        }

                        if let biometricType = viewModel.biometricType {
                            Divider().foregroundColor(Color.separator).padding(.leading, 16)

                            HStack {
                                Text(biometricType == .faceID ? "Face ID" : "Touch ID")
                                Spacer()
                                Toggle("", isOn: $viewModel.isBiometricEnabled)
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

                    Spacer().frame(height: 16)

                    VStack(spacing: 0) {
                        HStack {
                            Text("Delete Wallet")
                            Spacer()
                        }
                        .fontConfiguration(.body.regular)
                        .foregroundColor(.system.red)
                        .padding(.horizontal, 16)
                        .frame(height: 44)
                        .onTapWithHighlight {
                            Task {
                                viewModel.deleteAccount()
                            }
                        }
                    }
                    .background(Color.background.content)
                    .cornerRadius(10)
                    .padding(.horizontal, 16)

                    Spacer()
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
