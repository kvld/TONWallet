//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import SwiftUI
import SendState
import SwiftUIHelpers
import Components

struct SendAddressView: View {
    @ObservedObject var viewModel: SendViewModel

    @State private var address: String = ""

    var body: some View {
        ScreenContainer(
            navigationBarTitle: "Send TON",
            navigationBarTitleAlwaysVisible: true,
            navigationBarLeftButton: .cancel,
            extendBarHeight: true
        ) { proxy in
            ZStack(alignment: .bottom) {
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

                    Spacer()
                }

                VStack {
                    Spacer()

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
            .frame(height: proxy.contentSize.height)
        }
        .onAppear {
            address = viewModel.state.address?.value ?? ""
        }
    }
}

struct AddressInputView: View {
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

struct _TextEditor: UIViewRepresentable {
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
