//
//  Created by Vladislav Kiriukhin on 30.04.2023.
//

import Foundation
import SwiftUI
import Components

struct ReceiveView: View {
    @ObservedObject var viewModel: ReceiveViewModel

    var body: some View {
        ScreenContainer(navigationBarLeftButton: .cancel, wrapInScrollView: false) { _ in
            VStack(spacing: 0) {
                Text("Receive Toncoin")
                    .foregroundColor(.text.primary)
                    .fontConfiguration(.title1)
                    .padding(.top, 32)

                (
                    Text("Send only ")
                    + Text("Toncoin (TON)").fontWeight(.semibold)
                    + Text(" to this address.\nSending other coins may result in permanent loss.")
                )
                .fontConfiguration(.body.regular)
                .multilineTextAlignment(.center)
                .foregroundColor(.text.primary)
                .padding(.top, 12)
                .padding(.horizontal, 32)

                Image(uiImage: viewModel.qr ?? .init())
                    .resizable()
                    .frame(width: 220, height: 220)
                    .copyMenu(text: viewModel.link, title: "Copy transfer link")
                    .padding(.top, 50)

                Spacer(minLength: 16)

                Text(viewModel.address)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.text.primary)
                    .fontConfiguration(.body.mono)
                    .copyMenu(text: viewModel.address)
                    .padding(.bottom, 6)
                    .padding(.horizontal, 32)

                Text("Your wallet address")
                    .foregroundColor(.text.secondary)
                    .fontConfiguration(.body.regular)
                    .padding(.bottom, 64)
                    .padding(.horizontal, 32)

                Button("Share Wallet Address") {
                    viewModel.share()
                }
                .buttonStyle(
                    .action(
                        icon: Image("share").eraseToAnyView()
                    )
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 4)
            }
        }
        .padding(.top, 4)
    }
}
