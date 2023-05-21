//
//  Created by Vladislav Kiriukhin on 20.05.2023.
//

import SwiftUI
import Components

struct PasscodeView: View {
    @ObservedObject var viewModel: PasscodeViewModel

    @State private var hapticFeedback = HapticFeedback()

    var body: some View {
        VStack(spacing: 0) {
            Image("ton")
                .resizable()
                .frame(width: 48, height: 48)
                .padding(.top, 24)

            Text("Enter your TON Wallet Passcode")
                .foregroundColor(.white)
                .fontConfiguration(.title3)
                .padding(.top, 20)

            HStack(spacing: 16) {
                ForEach(0..<viewModel.passcodeLength, id: \.self) { idx in
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 1.0)
                        .background {
                            if viewModel.typedPasscode.count > idx {
                                Circle()
                                    .foregroundColor(.white)
                                    .transition(.asymmetric(insertion: .scale, removal: .identity))
                            }
                        }
                        .animation(.easeInOut(duration: 0.2), value: viewModel.typedPasscode)
                        .frame(width: 16, height: 16)
                }
            }
            .padding(.top, 24)

            VStack(spacing: 24) {
                Spacer()

                HStack(spacing: 24) {
                    Spacer()

                    DigitButtonView(title: "1", subtitle: "").onTapWithFeedback {
                        viewModel.typeSymbol("1")
                    }
                    DigitButtonView(title: "2", subtitle: "A B C").onTapWithFeedback {
                        viewModel.typeSymbol("2")
                    }
                    DigitButtonView(title: "3", subtitle: "D E F").onTapWithFeedback {
                        viewModel.typeSymbol("3")
                    }

                    Spacer()
                }

                HStack(spacing: 24) {
                    Spacer()

                    DigitButtonView(title: "4", subtitle: "G H I").onTapWithFeedback {
                        viewModel.typeSymbol("4")
                    }
                    DigitButtonView(title: "5", subtitle: "J K L").onTapWithFeedback {
                        viewModel.typeSymbol("5")
                    }
                    DigitButtonView(title: "6", subtitle: "M N O").onTapWithFeedback {
                        viewModel.typeSymbol("6")
                    }

                    Spacer()
                }

                HStack(spacing: 24) {
                    Spacer()

                    DigitButtonView(title: "7", subtitle: "P Q R S").onTapWithFeedback {
                        viewModel.typeSymbol("7")
                    }
                    DigitButtonView(title: "8", subtitle: "T U V").onTapWithFeedback {
                        viewModel.typeSymbol("8")
                    }
                    DigitButtonView(title: "9", subtitle: "W X Y Z").onTapWithFeedback {
                        viewModel.typeSymbol("9")
                    }

                    Spacer()
                }

                HStack(spacing: 24) {
                    Spacer()

                    BiometricButtonView(biometricType: viewModel.biometricType).onTapWithFeedback {
                        viewModel.showBiometric()
                    }
                    DigitButtonView(title: "0", subtitle: "+").onTapWithFeedback {
                        viewModel.typeSymbol("0")
                    }
                    DeleteButtonView().onTapWithFeedback {
                        viewModel.deleteSymbol()
                    }

                    Spacer()
                }

                Spacer()
            }
        }
        .background(Color.black.ignoresSafeArea())
        .onChange(of: viewModel.enterResult) { newValue in
            switch newValue {
            case .success:
                hapticFeedback.play(effect: .success)
                viewModel.enterResult = nil
            case .failure:
                hapticFeedback.play(effect: .error)
                viewModel.enterResult = nil
            case .none:
                break
            }
        }
    }
}

private struct DigitButtonView: View {
    let title: String
    let subtitle: String

    var body: some View {
        Circle()
            .fill(Color.white.opacity(0.12))
            .overlay(alignment: .center) {
                VStack(spacing: -2) {
                    Text(title)
                        .font(.system(size: 37))
                    Text(subtitle)
                        .font(.system(size: 10, weight: .medium))
                }
                .foregroundColor(.white)
                .padding(.top, -6)
            }
            .frame(maxWidth: 72, maxHeight: 72)
    }
}

private struct DeleteButtonView: View {
    var body: some View {
        Circle()
            .fill(Color.white.opacity(0.12))
            .overlay(alignment: .center) {
                Image(systemName: "delete.left.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(.all, 26)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: 78, maxHeight: 78)
    }
}

private struct BiometricButtonView: View {
    let biometricType: PasscodeViewModel.BiometricType?

    var body: some View {
        Circle()
            .fill(Color.white.opacity(0.12))
            .overlay(alignment: .center) {
                Group {
                    switch biometricType {
                    case .faceID:
                        Image(systemName: "faceid").resizable()
                    case .touchID:
                        Image(systemName: "touchid").resizable()
                    case .none:
                        EmptyView()
                    }
                }
                .aspectRatio(1.0, contentMode: .fit)
                .padding(.horizontal, 22)
                .foregroundColor(.white)
            }
            .opacity(biometricType == .none ? 0.0 : 1.0)
            .frame(maxWidth: 78, maxHeight: 78)
    }
}
