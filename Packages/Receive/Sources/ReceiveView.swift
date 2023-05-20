//
//  Created by Vladislav Kiriukhin on 30.04.2023.
//

import Foundation
import SwiftUI
import Components
import SwiftUIHelpers

struct ReceiveView: View {
    @ObservedObject var viewModel: ReceiveViewModel

    var body: some View {
        ScreenContainer(navigationBarLeftButton: .cancel, extendBarHeight: true, wrapInScrollView: true) { proxy in
            VStack(spacing: 0) {
                Text("Receive Toncoin")
                    .foregroundColor(.text.primary)
                    .fontConfiguration(.title1)
                    .padding(.top, 16)

                (
                    Text("Send only ")
                    + Text("Toncoin (TON)").fontWeight(.semibold)
                    + Text(" to this address.\nSending other coins may result in permanent loss.")
                )
                .fontConfiguration(.body.regular)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(.text.primary)
                .padding(.top, 12)
                .padding(.horizontal, 16)

                Image(uiImage: viewModel.qr ?? .init())
                    .resizable()
                    .frame(width: proxy.contentSize.width * 0.56, height: proxy.contentSize.width * 0.56)
                    .copyMenu(text: viewModel.link, title: "Copy transfer link")
                    .padding(.top, 24)
                    .padding(.bottom, 24)

                Text(viewModel.address)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.text.primary)
                    .fontConfiguration(.body.mono)
                    .copyMenu(text: viewModel.address)
                    .padding(.bottom, 6)
                    .padding(.horizontal, 32)

                Text("Your wallet address")
                    .foregroundColor(.text.secondary)
                    .fontConfiguration(.body.regular)
                    .padding(.bottom, 16)
                    .padding(.horizontal, 32)

                Spacer(minLength: 16)

                Button("Share Wallet Address") {
                    viewModel.share()
                }
                .buttonStyle(
                    .action(
                        icon: Image("share").eraseToAnyView()
                    )
                )
                .padding(.horizontal, 16)

                DeviceRelatedBottomSpacer()
            }
            .frame(height: proxy.contentSize.height)
        }
    }
}
