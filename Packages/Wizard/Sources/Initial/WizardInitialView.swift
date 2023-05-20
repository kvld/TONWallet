//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import SwiftUI
import WizardInfo
import WizardState
import SwiftUIHelpers

struct WizardInitialView: View {
    @ObservedObject var viewModel: WizardViewModel

    @State private var isWalletLoading = false

    private var primaryButton: AnyView {
        Button("Create my wallet") {
            guard !isWalletLoading else {
                return
            }

            isWalletLoading = true
            viewModel.generateMnemonic()
        }
        .buttonStyle(.action())
        .loading(isWalletLoading)
        .eraseToAnyView()
    }

    private var secondaryButton: AnyView {
        Button("Importing existing wallet") {
            guard !isWalletLoading else {
                return
            }

            viewModel.importMnemonic()
        }
        .buttonStyle(.action(background: .outline))
        .eraseToAnyView()
    }

    var body: some View {
        WizardInfoView(
            model: .init(
                animationName: "start",
                title: "TON Wallet",
                text: "TON Wallet allows you to make fast and secure blockchain-based payments without intermediaries.",
                primaryButton: primaryButton,
                secondaryButton: secondaryButton
            )
        )
    }
}
