//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import SwiftUI
import Components
import AnimationView
import SwiftUIBackports
import SwiftUIHelpers

struct WizardPasscodeView: View {
    @State private var passcodeLength = 4
    @State private var hapticFeedback = HapticFeedback()

    let isInConfirmationMode: Bool
    let onSuccess: (String) -> Void

    var title: String {
        isInConfirmationMode ? "Confirm a Passcode" : "Set a Passcode"
    }

    var body: some View {
        ScreenContainer(navigationBarVisibility: .visible, navigationBarTitle: title) { proxy in
            VStack(spacing: 0) {
                AnimationView(animationName: "password") // TODO: 0.5 duration
                    .frame(width: 124, height: 124)
                    .padding(.top, 46)
                    .padding(.bottom, 20)

                VStack(spacing: 12) {
                    Text(title)
                        .fontConfiguration(.title1)
                        .foregroundColor(.text.primary)
                        .navigationBarTitleVisibilityAnchor()

                    Text("Enter the \(passcodeLength) digits in the passcode.")
                        .fontConfiguration(.body.regular)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.text.primary)
                }
                .padding(.horizontal, 32)

                PasscodeInputView(length: passcodeLength) { passcode in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        hapticFeedback.play(effect: .success)
                        onSuccess(passcode)
                    }
                }
                .padding(.top, 28)

                Spacer()

                Menu {
                    Button("4-digit code") {
                        passcodeLength = 4
                        hapticFeedback.play(effect: .selection)
                    }
                    Button("6-digit code") {
                        passcodeLength = 6
                        hapticFeedback.play(effect: .selection)
                    }
                } label: {
                    Text("Passcode options")
                        .foregroundColor(.accent.app)
                        .fontConfiguration(.body.regular)
                        .padding(.all, 14)
                }
                .opacity(isInConfirmationMode ? 0.0 : 1.0)
                .padding(.bottom, 8)
            }
            .frame(height: proxy.contentSize.height)
        }
    }
}

private struct PasscodeInputView: View {
    @State private var typedPasscode: String = ""

    let length: Int
    let onSuccess: (String) -> Void

    var body: some View {
        ZStack {
            TextField("", text: $typedPasscode)
                .opacity(0.0)
                .focused(.constant(true))
                .keyboardType(.numberPad)

            HStack(spacing: 16) {
                ForEach(0..<length, id: \.self) { idx in
                    Circle()
                        .strokeBorder(Color.separator, lineWidth: 1.0)
                        .background {
                            if typedPasscode.count > idx {
                                Circle()
                                    .foregroundColor(.text.primary)
                                    .transition(.asymmetric(insertion: .scale, removal: .identity))
                            }
                        }
                        .animation(.easeInOut(duration: 0.2), value: typedPasscode)
                        .frame(width: 16, height: 16)
                }
            }
        }
        .frame(height: 40)
        .onChange(of: length) { _ in
            typedPasscode = ""
        }
        .onChange(of: typedPasscode) { newValue in
            if newValue.count == length {
                onSuccess(String(newValue.prefix(length)))
            }
        }
    }
}
