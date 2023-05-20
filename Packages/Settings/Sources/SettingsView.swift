//
//  Created by Vladislav Kiriukhin on 14.05.2023.
//

import SwiftUI
import SwiftUIHelpers
import Components

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

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
                            HStack(alignment: .center, spacing: 6) {
                                Text("v4R2")
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

                        Divider().background(Color.separator).padding(.leading, 16)

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

                        Divider().background(Color.separator).padding(.leading, 16)

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

                        Divider().background(Color.separator).padding(.leading, 16)

                        HStack {
                            Text("Face ID")
                            Spacer()
                        }
                        .fontConfiguration(.body.regular)
                        .foregroundColor(.text.primary)
                        .padding(.horizontal, 16)
                        .frame(height: 44)
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
