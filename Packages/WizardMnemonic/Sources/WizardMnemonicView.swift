//
//  Created by Vladislav Kiriukhin on 26.03.2023.
//

import Foundation
import SwiftUI
import Components
import AnimationView
import SwiftUIBackports
import SwiftUIHelpers

struct WizardMnemonicView: View {
    let onDoneTap: () -> Void

    let words: [String] = [
        "network",
        "banana",
        "coffee",
        "jaguar",
        "mafioso",
        "junk",
        "whale",
        "pepper",
        "steel",
        "execution",
        "drift",
        "sparrow",
        "angel",
        "sidewalk",
        "tank",
        "space",
        "heart",
        "sun",
        "revolver",
        "redneck",
        "hatred",
        "snake",
        "collision",
        "hoverbike"
    ]

    var leftColumnWords: [(Int, String)] {
        words.enumerated().prefix(Int(words.count / 2)).map { ($0.offset, $0.element) }
    }

    var rightColumnWords: [(Int, String)] {
        words.enumerated().dropFirst(Int(words.count / 2)).map { ($0.offset, $0.element) }
    }

    var body: some View {
        ScreenContainer(navigationBarVisibility: .visible, navigationBarTitle: "Your Recovery Phrase") { _ in
            LazyVStack(spacing: 0) {
                AnimationView(animationName: "recovery")
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
                            MnemonicWordColumnView(words: leftColumnWords, selectedIndex: word.0)
                        }
                    }

                    Spacer()

                    VStack(spacing: 10) {
                        ForEach(rightColumnWords, id: \.0) { word in
                            MnemonicWordColumnView(words: rightColumnWords, selectedIndex: word.0)
                        }
                    }
                }
                .padding(.horizontal, 45)

                Button("Done", action: onDoneTap)
                    .buttonStyle(.action())
                    .padding(.top, 52)
                    .padding(.horizontal, 48)
                    .padding(.bottom, 44)
            }
        }
    }
}

private struct MnemonicWordColumnView: View {
    let words: [(Int, String)]
    let selectedIndex: Int

    var body: some View {
        HStack(spacing: 6) {
            ZStack(alignment: .trailing) {
                ForEach(words, id: \.0) { (idx, word) in
                    Text("\(idx + 1).")
                        .fontConfiguration(.body.regular)
                        .foregroundColor(.text.secondary)
                        .opacity(idx == selectedIndex ? 1.0 : 0.0)
                }
            }

            ZStack(alignment: .leading) {
                ForEach(words, id: \.0) { (idx, word) in
                    Text("\(word)")
                        .fontConfiguration(.body.semibold)
                        .foregroundColor(.text.primary)
                        .opacity(idx == selectedIndex ? 1.0 : 0.0)
                }
            }
        }
    }
}
