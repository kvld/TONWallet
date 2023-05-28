//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import SwiftUI
import SendState
import SwiftUIHelpers
import Components

struct SendAddressView: View {
    @ObservedObject var viewModel: SendViewModel
    let onClose: () -> Void

    @State private var address: String = ""

    var body: some View {
        ZStack(alignment: .bottom) {
            ScreenContainer(
                navigationBarTitle: "Send TON",
                navigationBarTitleAlwaysVisible: true,
                navigationBarLeftButton: .cancel,
                navigationBarOnLeftButtonTap: onClose,
                extendBarHeight: true
            ) { proxy in
                VStack(alignment: .leading, spacing: 0) {
                    AddressInputView(text: $address)
                        .padding(.horizontal, 16)
                        .padding(.top, 4)

                    Text("Paste the 24-letter wallet address of the recipient here or TON DNS.")
                        .fixedSize(horizontal: false, vertical: true)
                        .fontConfiguration(.callout)
                        .foregroundColor(.text.secondary)
                        .padding([.horizontal, .top], 16)
                        .padding(.bottom, 12)

                    HStack(spacing: 20) {
                        HStack(spacing: 4) {
                            Image("paste")
                                .resizable()
                                .frame(width: 19, height: 22)

                            Text("Paste")
                                .padding(.bottom, 1)
                        }
                        .onTapWithFeedback {
                            if let pasteAddress = UIPasteboard.general.string {
                                address = pasteAddress
                            }
                        }

                        HStack(spacing: 4) {
                            Image("scan")
                                .resizable()
                                .frame(width: 22, height: 22)

                            Text("Scan")
                                .padding(.bottom, 1)
                        }
                        .onTapWithFeedback {
                            viewModel.scanForTransferLink()
                        }

                        Spacer()
                    }
                    .padding(.horizontal, 16)

                    if !viewModel.state.history.isEmpty {
                        HistoryView(history: viewModel.state.history) {
                            viewModel.clearHistory()
                        } onAddressSelect: { idx in
                            viewModel.fillWithHistoryEntry(with: idx)
                        }
                        .padding(.top, 22)
                        .padding(.bottom, 64)
                    }

                    Spacer()
                }
                .frame(minHeight: proxy.contentSize.height)
            }

            VStack(spacing: 0) {
                Spacer()

                if let error = viewModel.state.error {
                    AlertView(
                        isPresented: .init(
                            get: { viewModel.state.error != nil },
                            set: { !$0 ? viewModel.state.error = nil : nil }
                        ),
                        title: error.title,
                        message: error.error
                    )
                    .padding([.horizontal, .bottom], 16)
                }

                Button("Continue") {
                    Task {
                        await viewModel.submit(address: address)
                    }
                }
                .buttonStyle(.action())
                .loading(viewModel.state.isLoading)
                .padding(.horizontal, 16)

                DeviceRelatedBottomSpacer()
            }
        }
        .onAppear {
            address = viewModel.state.address?.value ?? ""
        }
        .onChange(of: viewModel.state.address) { newValue in
            address = newValue?.value ?? ""
        }
    }
}

private struct AddressInputView: View {
    @Binding var text: String
    @State private var textEditorHeight: CGFloat = 0

    var body: some View {
        ZStack(alignment: .leading) {
            Color.background.grouped

            Text("Enter Wallet Address or Domain...")
                .foregroundColor(.text.secondary)
                .fontConfiguration(.body.regular)
                .opacity(text.isEmpty ? 1.0 : 0.0)
                .padding(.horizontal, 16)
                .padding(.bottom, 2)

            HStack(spacing: 0) {
                _TextEditor(text: $text, height: $textEditorHeight)
                    .frame(minHeight: textEditorHeight, maxHeight: textEditorHeight)
                    .padding(.vertical, 12)
                    .padding(.leading, 12)
                    .padding(.top, 1)

                Button {
                    text = ""
                } label: {
                    Image("clear")
                        .foregroundColor(.text.secondary)
                        .frame(width: 19, height: 22)
                }
                .opacity(!text.isEmpty ? 1.0 : 0.0)
                .padding(.horizontal, 12)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .cornerRadius(10)
    }
}

private struct _TextEditor: UIViewRepresentable {
    @Binding var text: String
    @Binding var height: CGFloat

    final class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        @Binding var height: CGFloat

        init(text: Binding<String>, height: Binding<CGFloat>) {
            self._text = text
            self._height = height
        }

        func textViewDidChange(_ uiView: UITextView) {
            text = uiView.text.replacingOccurrences(of: "\n", with: "")
            Coordinator.height(of: uiView, result: $height)
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                return false
            }
            return (textView.text as NSString).replacingCharacters(in: range, with: text).count <= 48
        }

        static func height(of view: UIView, result: Binding<CGFloat>) {
            let newSize = view.sizeThatFits(
                CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
            )

            if result.wrappedValue != newSize.height {
                DispatchQueue.main.async {
                    result.wrappedValue = newSize.height
                }
            }
        }
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()

        textView.delegate = context.coordinator

        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = .clear

        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none

        textView.textContainerInset = .zero
        textView.font = .systemFont(ofSize: FontConfiguration.body.regular.pointSize)

        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }

        Coordinator.height(of: uiView, result: $height)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, height: $height)
    }
}

private struct HistoryView: View {
    let history: [SendState.HistoryEntry]
    let onClearTap: () -> Void
    let onAddressSelect: (Int) -> Void

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                HStack {
                    Text("Recents".uppercased())
                        .foregroundColor(.text.secondary)
                        .fontConfiguration(.footnote)
                    Spacer()
                    Text("Clear".uppercased())
                        .foregroundColor(.accent.app)
                        .fontConfiguration(.footnote)
                        .onTapWithFeedback(action: onClearTap)
                }
                .padding(.bottom, 4)
            }
            .frame(height: 44)
            .padding(.horizontal, 16)

            ForEach(Array(history.enumerated()), id: \.offset) { (idx, item) in
                VStack(alignment: .leading, spacing: 2) {
                    Spacer(minLength: 0)

                    HStack(spacing: 0) {
                        Group {
                            if let domain = item.domain {
                                Text(domain)
                            } else {
                                Text(item.address)
                            }
                        }

                        Spacer(minLength: 0)
                    }
                    .foregroundColor(.text.primary)
                    .padding(.horizontal, 16)

                    Group {
                        if item.domain != nil {
                            Text(item.address)
                        } else {
                            Text(item.date)
                        }
                    }
                    .foregroundColor(.text.secondary)
                    .padding(.horizontal, 16)

                    Spacer(minLength: 0)
                }
                .fontConfiguration(.body.regular)
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .onTapWithHighlight {
                    onAddressSelect(idx)
                }

                if idx != history.count - 1 {
                    Divider().foregroundColor(Color.separator).padding(.leading, 16)
                }
            }
        }
    }
}
