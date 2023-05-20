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
    @State var suggestions: [String] = []
    @State var activeIndex: Int = -1
    @State var isLoading = false

    init(state: WizardMnemonicInputState, viewModel: WizardViewModel) {
        self.state = state
        self.viewModel = viewModel

        switch state {
        case .import:
            self.inputText = Array(repeating: "", count: viewModel.state.mnemonicTestWordsIndices.count)
        case .test:
            self.inputText = Array(repeating: "", count: viewModel.state.mnemonicWords.count)
        }
    }

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
                    ForEach(testWordsIndices, id: \.self) { idx in
                        RecoveryWordInputView(
                            index: idx - 1,
                            maxWidthIndex: testWordsIndices.last ?? 0,
                            typedText: $inputText[idx - 1],
                            suggestions: suggestions,
                            activeIndex: $activeIndex,
                            isLast: idx == testWordsIndices.count
                        ) { word in
                            activeIndex += 1
                            inputText[idx - 1] = word
                        } onReturnTap: {
                            if idx == testWordsIndices.count {
                                activeIndex = -1
                            } else {
                                activeIndex += 1
                            }
                        }
                        .onChange(of: inputText[idx - 1]) { newValue in
                            if (idx - 1) != activeIndex {
                                return
                            }

                            Task {
                                let words = await viewModel.getMnemonicSuggestions(prefix: newValue)
                                suggestions = words
                            }
                        }
                        .onChange(of: activeIndex) { newValue in
                            suggestions = []
                        }
                    }

                    Button("Continue") {
                        guard !isLoading else {
                            return
                        }

                        activeIndex = -1

                        switch state {
                        case .test:
                            viewModel.checkMnemonicTestWords(allWords: inputText)
                        case .import:
                            isLoading = true
                            Task {
                                await viewModel.checkMnemonicImport(allWords: inputText)
                                isLoading = false
                            }
                        }
                    }
                    .buttonStyle(.action())
                    .loading(isLoading)
                }
                .padding(.horizontal, 48)
                .padding(.bottom, 44)
            }
        }
        .additionalKeyboardAvoidancePadding(20)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                activeIndex = 0
            }
        }
    }
}

private struct RecoveryWordInputView: View {
    let index: Int
    let maxWidthIndex: Int
    @Binding var typedText: String
    let suggestions: [String]
    @Binding var activeIndex: Int
    let isLast: Bool
    let onWordSelect: (String) -> Void
    let onReturnTap: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            ZStack {
                Text("\(maxWidthIndex):")
                    .opacity(0.0)

                Text("\(index + 1):")
            }
            .fontConfiguration(.body.regular)
            .foregroundColor(.text.secondary)
            .multilineTextAlignment(.trailing)

            SuggestionTextField(
                index: index,
                text: $typedText,
                suggestions: suggestions,
                onWordSelect: onWordSelect,
                activeIndex: $activeIndex,
                isLast: isLast,
                onReturnTap: onReturnTap
            )
            .frame(height: 50)
            .padding(.top, 2)
        }
        .padding([.bottom, .leading, .trailing], 16)
        .padding(.top, 14)
        .frame(height: 50)
        .background(Color.background.grouped)
        .cornerRadius(10)
    }
}

private struct SuggestionTextField: UIViewRepresentable {
    let index: Int
    @Binding var text: String
    let suggestions: [String]
    let onWordSelect: (String) -> Void
    @Binding var activeIndex: Int
    let isLast: Bool
    let onReturnTap: () -> Void

    final class TextField: UITextField {
        var _text: Binding<String>
        var activeIndex: Binding<Int>
        let index: Int

        var onReturnTap: (() -> Void)?

        init(
            frame: CGRect,
            text: Binding<String>,
            index: Int,
            activeIndex: Binding<Int>
        ) {
            self._text = text
            self.activeIndex = activeIndex
            self.index = index

            super.init(frame: frame)
            addTarget(self, action: #selector(onUpdate), for: .editingChanged)
            addTarget(self, action: #selector(_onReturnTap), for: .editingDidEndOnExit)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func becomeFirstResponder() -> Bool {
            let result = super.becomeFirstResponder()
            activeIndex.wrappedValue = index
            return result
        }

        @objc
        func _onReturnTap() {
            onReturnTap?()
        }

        @objc
        func onUpdate() {
            guard let text else {
                return
            }

            _text.wrappedValue = text
        }
    }

    final class SuggestionsView: UIInputView {
        var words: [String] = [] {
            didSet {
                makeButtons()
            }
        }

        var onWordSelect: ((String) -> Void)?

        private var suggestionsView: UIView?

        private func makeButtons() {
            suggestionsView?.removeFromSuperview()

            let _view = Group { [weak self] in
                HStack(spacing: 4) {
                    ForEach(words, id: \.self) { word in
                        HStack(spacing: 0) {
                            Spacer(minLength: 8)
                            Text(word)
                                .fontConfiguration(.body.regular)
                                .foregroundColor(Color.text.primary)
                                .padding(.bottom, 2)
                            Spacer(minLength: 8)
                        }
                        .frame(height: 42)
                        .background(Color.background.elevation.opacity(0.64))
                        .cornerRadius(5)
                        .padding(.top, 2)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .onTapWithFeedback {
                            self?.onWordSelect?(word)
                        }
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.horizontal, 4)
            }

            let view = _UIHostingView(rootView: _view)
            addSubview(view)
            view.frame = bounds
            suggestionsView = view
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            suggestionsView?.frame = bounds
        }
    }

    func makeUIView(context: Context) -> TextField {
        let view = TextField(frame: .zero, text: $text, index: index, activeIndex: $activeIndex)
        view.keyboardType = .alphabet
        view.autocorrectionType = .no
        view.autocapitalizationType = .none

        view.onReturnTap = onReturnTap

        let suggestionsView = SuggestionsView(
            frame: .init(origin: .zero, size: .init(width: 0, height: 48)),
            inputViewStyle: .keyboard
        )
        suggestionsView.onWordSelect = onWordSelect
        suggestionsView.words = suggestions

        view.inputAccessoryView = suggestionsView

        updateTextFieldState(view)

        return view
    }

    func updateUIView(_ uiView: TextField, context: Context) {
        uiView.text = _text.wrappedValue

        updateTextFieldState(uiView)

        if let suggestionsView = uiView.inputAccessoryView as? SuggestionsView {
            suggestionsView.onWordSelect = onWordSelect
            suggestionsView.words = suggestions
        }
    }

    private func updateTextFieldState(_ view: TextField) {
        view.returnKeyType = isLast ? .done : .next

        if !view.isFirstResponder, index == activeIndex {
            DispatchQueue.main.async {
                _ = view.becomeFirstResponder()
            }
        }
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
