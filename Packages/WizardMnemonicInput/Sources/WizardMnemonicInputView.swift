//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import SwiftUI
import Components
import AnimationView
import SwiftUIBackports
import SwiftUIHelpers

struct WizardMnemonicInputView: View {
    let state: WizardMnemonicInputState
    let onForgotTap: () -> Void
    let onDoneTap: () -> Void

    var body: some View {
        ScreenContainer(navigationBarVisibility: .visible, navigationBarTitle: state.title) { _ in
            LazyVStack(spacing: 0) {
                AnimationView(animationName: state.animationName, repeatInfinitely: false)
                    .frame(width: 124, height: 124)
                    .padding(.bottom, 20)

                VStack(spacing: 12) {
                    Text(state.title)
                        .fontConfiguration(.title1)
                        .foregroundColor(.text.primary)
                        .navigationBarTitleVisibilityAnchor()

                    Text(state.text)
                        .fontConfiguration(.body.regular)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.text.primary)

                    if case .import = state {
                        Text("I don’t have those")
                            .fontConfiguration(.body.regular)
                            .foregroundColor(.accent.app)
                            .onTapWithFeedback(action: onForgotTap)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 36)

                VStack(spacing: 16) {
                    if case let .import(count) = state {
                        let allWordsNumbers = Array(1...count)
                        ForEach(0..<count, id: \.self) { idx in
                            RecoveryWordInputView(allWordsNumbers: allWordsNumbers, currentIndex: idx)
                        }
                    } else if case let .test(indices) = state {
                        let allWordsNumbers = indices.map { $0 + 1 }
                        ForEach(0..<indices.count, id: \.self) { idx in
                            RecoveryWordInputView(allWordsNumbers: allWordsNumbers, currentIndex: idx)
                        }
                    }

                    Button("Continue", action: onDoneTap)
                        .buttonStyle(.action())
                }
                .padding(.horizontal, 48)
                .padding(.bottom, 44)
            }
        }
        .additionalKeyboardAvoidancePadding(20)
    }
}

private struct RecoveryWordInputView: View {
    let allWordsNumbers: [Int]
    let currentIndex: Int

    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            ZStack {
                ForEach(0..<allWordsNumbers.count, id: \.self) { idx in
                    Text("\(allWordsNumbers[idx]):")
                        .fontConfiguration(.body.regular)
                        .foregroundColor(.text.secondary)
                        .multilineTextAlignment(.trailing)
                        .opacity(idx == currentIndex ? 1.0 : 0.0)
                }
            }

            TextField("", text: .constant(""))
                .frame(height: 50)
        }
        .padding([.bottom, .leading, .trailing], 16)
        .padding(.top, 14)
        .frame(height: 50)
        .background(Color.background.grouped)
        .cornerRadius(10)
    }
}

extension WizardMnemonicInputState {
    var title: String {
        switch self {
        case let .import(count):
            return "\(count) Secret Words"
        case .test:
            return "Test Time!"
        }
    }

    var animationName: String {
        switch self {
        case .import:
            return "recovery"
        case .test:
            return "test_time"
        }
    }

    var text: String {
        switch self {
        case .import:
            return "You can restore access to your wallet by entering 24 words you wrote when down you creating the wallet."
        case .test:
            return "Let’s check that you wrote them down correctly. Please enter the words 5, 15 and 18."
        }
    }
}
