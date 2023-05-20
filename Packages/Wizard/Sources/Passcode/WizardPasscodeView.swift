//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import SwiftUI
import Components
import AnimationView
import SwiftUIBackports
import SwiftUIHelpers
import WizardState

struct WizardPasscodeView: View {
    let isInConfirmationMode: Bool
    @ObservedObject var viewModel: WizardViewModel

    @State private var _passcodeLength = 4
    @State private var hapticFeedback = HapticFeedback()
    @State private var attemptsCount = 0

    @State private var shakePasscodeInput: Bool = false

    var passcodeLength: Int {
        viewModel.state.passcode?.count ?? _passcodeLength
    }

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

                PasscodeInputView(length: passcodeLength, attemptsCount: attemptsCount) { passcode in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        if isInConfirmationMode {
                            let isOk = viewModel.confirmPasscode(passcode)

                            if !isOk {
                                attemptsCount += 1
                                hapticFeedback.play(effect: .error)

                                shakePasscodeInput = true
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.25, blendDuration: 0.25)) {
                                    shakePasscodeInput = false
                                }
                            } else {
                                hapticFeedback.play(effect: .success)
                            }
                        } else {
                            hapticFeedback.play(effect: .success)
                            viewModel.setUpPasscode(passcode)
                        }
                    }
                }
                .offset(x: shakePasscodeInput ? 40 : 0)
                .padding(.top, 28)

                Spacer()

                Menu {
                    Button("4-digit code") {
                        _passcodeLength = 4
                        hapticFeedback.play(effect: .selection)
                    }
                    Button("6-digit code") {
                        _passcodeLength = 6
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
    let attemptsCount: Int
    let onSuccess: (String) -> Void

    var body: some View {
        ZStack {
            _TextField(text: $typedPasscode)
                .opacity(0.0)

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
        .onChange(of: attemptsCount) { _ in
            typedPasscode = ""
        }
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

private struct _TextField: UIViewRepresentable {
    @Binding var text: String

    final class TextField: UITextField {
        var _text: Binding<String>

        init(frame: CGRect, text: Binding<String>) {
            self._text = text

            super.init(frame: frame)
            addTarget(self, action: #selector(onUpdate), for: .editingChanged)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        @objc
        func onUpdate() {
            guard let text = text else {
                return
            }

            _text.wrappedValue = text
        }
    }

    func makeUIView(context: Context) -> TextField {
        let textField = TextField(frame: .zero, text: _text)
        textField.keyboardType = .decimalPad

        DispatchQueue.main.async {
            textField.becomeFirstResponder()
        }

        return textField
    }

    func updateUIView(_ uiView: TextField, context: Context) {
        uiView.text = _text.wrappedValue

        DispatchQueue.main.async {
            uiView.becomeFirstResponder()
        }
    }
}
