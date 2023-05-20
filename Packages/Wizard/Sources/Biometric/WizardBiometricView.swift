//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import SwiftUI
import Components
import SwiftUIBackports
import SwiftUIHelpers
import WizardState

struct WizardBiometricView: View {
    @ObservedObject var viewModel: WizardViewModel
    @State private var isLoading = false

    private var shouldUseFaceID: Bool {
        viewModel.state.supportedBiometricType == .faceID
    }

    private var biometricType: String {
        shouldUseFaceID ? "Face ID" : "Touch ID"
    }

    var body: some View {
        ScreenContainer(navigationBarVisibility: .preserveSpace) { proxy in
            ZStack {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Image(systemName: shouldUseFaceID ? "faceid" : "touchid")
                            .resizable()
                            .foregroundColor(.accent.app)
                            .frame(width: 88, height: 88)
                            .padding(.all, 18)
                            .padding(.bottom, 20)

                        Text(biometricType)
                            .fontConfiguration(.title1)
                            .foregroundColor(.text.primary)
                            .padding(.bottom, 12)

                        Text("\(biometricType) allows you to open your wallet faster without having to enter your password.")
                            .fontConfiguration(.body.regular)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.text.primary)
                    }
                    .padding(.top, 150)
                    .padding(.horizontal, 32)

                    Spacer()
                }

                VStack(spacing: 0) {
                    Spacer(minLength: 16)

                    VStack(spacing: 16) {
                        Button("Enable \(biometricType)") {
                            isLoading = true
                            Task {
                                await viewModel.tryToEnableBiometric()
                                isLoading = false
                            }
                        }
                        .buttonStyle(.action())
                        .loading(isLoading)

                        Button("Skip") {
                            if isLoading {
                                return
                            }

                            viewModel.skipBiometric()
                        }
                        .buttonStyle(.action(background: .outline))
                    }
                    .offset(y: -56)
                    .padding(.horizontal, 48)
                }
            }
            .frame(height: proxy.contentSize.height)
        }
    }
}
