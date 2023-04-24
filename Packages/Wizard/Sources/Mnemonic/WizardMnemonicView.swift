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

struct WizardMnemonicView: View {
    @ObservedObject var viewModel: WizardViewModel

    private var words: [String] {
        viewModel.state.mnemonicWords
    }

    var leftColumnWords: [(Int, String)] {
        words.enumerated().prefix(Int(words.count / 2)).map { ($0.offset, $0.element) }
    }

    var rightColumnWords: [(Int, String)] {
        words.enumerated().dropFirst(Int(words.count / 2)).map { ($0.offset, $0.element) }
    }

    var body: some View {
        ScreenContainer(navigationBarVisibility: .visible, navigationBarTitle: "Your Recovery Phrase") { _ in
            LazyVStack(spacing: 0) {
                AnimationView(animationName: "recovery", repeatInfinitely: false)
                    .frame(width: 124, height: 124)
                    .padding(.bottom, 20)

                VStack(spacing: 12) {
                    Text("Your Recovery Phrase")
                        .fontConfiguration(.title1)
                        .foregroundColor(.text.primary)
                        .navigationBarTitleVisibilityAnchor()

                    Text("Write down these 24 words in this exact order and keep them in a secure place. Do not share this list with anyone. If you lose it, you will irrevocably lose access to your TON account.")
                        .fontConfiguration(.body.regular)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.text.primary)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 36)

                HStack(spacing: 0) {
                    VStack(spacing: 10) {
                        ForEach(leftColumnWords, id: \.0) { word in
                            MnemonicWordColumnView(
                                maxWidthNumber: leftColumnWords.map(\.0).last ?? 0,
                                number: word.0,
                                maxWidthWord: leftColumnWords.map(\.1).max(by: { $0.count < $1.count }) ?? word.1,
                                word: word.1
                            )
                        }
                    }

                    Spacer()

                    VStack(spacing: 10) {
                        ForEach(rightColumnWords, id: \.0) { word in
                            MnemonicWordColumnView(
                                maxWidthNumber: rightColumnWords.map(\.0).last ?? 0,
                                number: word.0,
                                maxWidthWord: rightColumnWords.map(\.1).max(by: { $0.count < $1.count }) ?? word.1,
                                word: word.1
                            )
                        }
                    }
                }
                .padding(.horizontal, 45)

                Button("Done") {
                    viewModel.proceedToSavedMnemonicTest()
                }
                .buttonStyle(.action())
                .padding(.top, 52)
                .padding(.horizontal, 48)
                .padding(.bottom, 44)
            }
        }
        .onAppear {
            viewModel.startTimerToSaveMnemonic()
        }
    }
}

private struct MnemonicWordColumnView: View {
    let maxWidthNumber: Int
    let number: Int
    let maxWidthWord: String
    let word: String

    var body: some View {
        HStack(spacing: 6) {
            ZStack(alignment: .trailing) {
                Text("\(maxWidthNumber).")
                    .opacity(0.0)

                Text("\(number + 1).")
            }
            .fontConfiguration(.body.regular)
            .foregroundColor(.text.secondary)

            ZStack(alignment: .leading) {
                Text("\(maxWidthWord)")
                    .opacity(0.0)

                Text("\(word)")
            }
            .fontConfiguration(.body.semibold)
            .foregroundColor(.text.primary)
        }
    }
}
