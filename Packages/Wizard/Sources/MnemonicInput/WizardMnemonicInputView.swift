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

struct WizardMnemonicInputView: View {
    let state: WizardMnemonicInputState
    @ObservedObject var viewModel: WizardViewModel
    @State var inputText: [String]

    private var testWordsIndices: [Int] {
        viewModel.state.mnemonicTestWordsIndices.map { $0 + 1 }
    }

    var body: some View {
        ScreenContainer(
            navigationBarVisibility: .visible,
            navigationBarTitle: state.title(count: testWordsIndices.count)
        ) { _ in
            LazyVStack(spacing: 0) {
                AnimationView(animationName: state.animationName, repeatInfinitely: false)
                    .frame(width: 124, height: 124)
                    .padding(.bottom, 20)

                VStack(spacing: 12) {
                    Text(state.title(count: testWordsIndices.count))
                        .fontConfiguration(.title1)
                        .foregroundColor(.text.primary)
                        .navigationBarTitleVisibilityAnchor()

                    Text(state.text(indices: testWordsIndices))
                        .fontConfiguration(.body.regular)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.text.primary)

                    if case .import = state {
                        Text("I don’t have those")
                            .fontConfiguration(.body.regular)
                            .foregroundColor(.accent.app)
                            .onTapWithFeedback(action: { })
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 36)

                VStack(spacing: 16) {
                    if case .import = state {
                        ForEach(testWordsIndices, id: \.self) { idx in
                            RecoveryWordInputView(
                                index: idx,
                                maxWidthIndex: testWordsIndices.last ?? 0,
                                typedText: .constant("")
                            )
                        }
                    } else if case .test = state {
                        ForEach(testWordsIndices, id: \.self) { idx in
                            RecoveryWordInputView(
                                index: idx,
                                maxWidthIndex: testWordsIndices.last ?? 0,
                                typedText: $inputText[idx - 1]
                            )
                        }
                    }

                    Button("Continue") {
                        viewModel.checkMnemonicTestWords(allWords: inputText)
                    }
                    .buttonStyle(.action())
                }
                .padding(.horizontal, 48)
                .padding(.bottom, 44)
            }
        }
        .additionalKeyboardAvoidancePadding(20)
        .onAppear {
            inputText = Array(repeating: "", count: viewModel.state.mnemonicWords.count)
        }
    }
}

private struct RecoveryWordInputView: View {
    let index: Int
    let maxWidthIndex: Int
    @Binding var typedText: String

    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            ZStack {
                Text("\(maxWidthIndex):")
                    .opacity(0.0)

                Text("\(index):")
            }
            .fontConfiguration(.body.regular)
            .foregroundColor(.text.secondary)
            .multilineTextAlignment(.trailing)

            TextField("", text: $typedText)
                .autocapitalization(.none)
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
    func title(count: Int) -> String {
        switch self {
        case .import:
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

    func text(indices: [Int]) -> String {
        switch self {
        case .import:
            return "You can restore access to your wallet by entering 24 words you wrote when down you creating the wallet."
        case .test:
            return "Let’s check that you wrote them down correctly. " +
                "Please enter the words \(indices.dropLast().map(String.init).joined(separator: ", ")) " +
                "and \(indices.last ?? 0)"
        }
    }
}
