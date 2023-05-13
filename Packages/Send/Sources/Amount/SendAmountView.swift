//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import SwiftUI
import SendState
import SwiftUIHelpers
import Components

struct SendAmountView: View {
    @ObservedObject var viewModel: SendViewModel

    @State private var amount = ""
    @State private var useFullBalance = false

    @State private var maxAmountWidth: CGFloat = 0
    @State private var amountWidth: CGFloat = 0

    var body: some View {
        ScreenContainer(
            navigationBarTitle: "Send TON",
            navigationBarTitleAlwaysVisible: true,
            extendBarHeight: true
        ) { proxy in
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    HStack(spacing: 4) {
                        Text("Send to:")
                            .foregroundColor(.text.secondary)

                        Text(viewModel.state.address?.shortened(partLength: 4) ?? "")
                            .foregroundColor(.text.primary)

                        if let domain = viewModel.state.domain {
                            Text(domain)
                                .foregroundColor(.text.secondary)
                        }

                        Spacer()

                        Text("Edit")
                            .onTapWithFeedback {

                            }
                    }
                    .fontConfiguration(.body.regular)
                    .frame(height: 44)
                    .padding(.top, 4)
                    .padding(.horizontal, 16)

                    Spacer()

                    HStack(spacing: 0) {
                        Spacer(minLength: 0)

                        let imageSpacing: CGFloat = 3
                        let imageWidth: CGFloat = 48

                        VStack(spacing: 1) {
                            HStack(spacing: imageSpacing) {
                                Image("ton")
                                    .resizable()
                                    .frame(width: imageWidth, height: imageWidth)

                                ZStack(alignment: .leading) {
                                    Text("0")
                                        .fontConfiguration(.rounded.balanceLarge)
                                        .foregroundColor(.text.secondary)
                                        .opacity(amount.isEmpty ? 0.2 : 0.0)

                                    AmountTextField(
                                        text: $amount,
                                        width: $amountWidth,
                                        maxWidth: proxy.contentSize.width - imageSpacing - imageWidth - 32 * 2,
                                        textColor: viewModel.state.hasInsufficientFunds
                                            ? UIColor(Color.system.red)
                                            : UIColor(Color.text.primary)
                                    )
                                    .frame(width: amountWidth)
                                    .fixedSize(horizontal: true, vertical: true)
                                }
                            }
                            .frame(height: 56)

                            if viewModel.state.hasInsufficientFunds {
                                Text("Insufficient funds")
                                    .foregroundColor(.system.red)
                                    .fontConfiguration(.body.regular)
                            } else {
                                Spacer().frame(height: FontConfiguration.body.regular.lineHeight)
                            }
                        }

                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, -64)

                    Spacer()
                }

                VStack(spacing: 0) {
                    Spacer()

                    HStack(spacing: 2) {
                        Text("Send all")
                            .fontConfiguration(.body.regular)
                            .foregroundColor(.text.primary)

                        if let balance = viewModel.state.balance?.formatted.formatted {
                            Image("ton")
                                .resizable()
                                .frame(width: 22, height: 22)

                            Text(balance)
                                .fontConfiguration(.body.regular)
                                .foregroundColor(.text.primary)
                        }

                        Spacer()

                        Toggle("", isOn: $useFullBalance)
                    }
                    .frame(height: 44)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)

                    Button("Continue") {
                        Task {
                            await viewModel.submit(amount: amount)
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
        .onChange(of: amount) { newAmount in
            viewModel.updateAmount(with: newAmount)
        }
        .onChange(of: useFullBalance) { useFullBalance in
            if let balance = viewModel.state.balance?.formatted.formatted {
                amount = useFullBalance ? balance : ""
            }
        }
    }
}

private struct AmountTextField: UIViewRepresentable {
    static let minWidth: CGFloat = 40

    @Binding var text: String
    @Binding var width: CGFloat
    let maxWidth: CGFloat
    let textColor: UIColor

    final class TextField: UITextField {
        var _text: Binding<String>
        var _width: Binding<CGFloat>
        var maxWidth: CGFloat

        init(frame: CGRect, text: Binding<String>, width: Binding<CGFloat>, maxWidth: CGFloat) {
            self._text = text
            self._width = width
            self.maxWidth = maxWidth

            DispatchQueue.main.async {
                width.wrappedValue = AmountTextField.minWidth
            }

            super.init(frame: frame)
            addTarget(self, action: #selector(updateText), for: .editingChanged)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func caretRect(for position: UITextPosition) -> CGRect {
            var rect = super.caretRect(for: position)
            rect.origin.y = 4
            rect.size.height = 48
            return rect
        }

        @objc
        func updateText() {
            guard var text = text else {
                return
            }

            let separator = Locale.current.decimalSeparator ?? "."
            text = text.filter { $0.isNumber || $0 == separator.first }

            guard !text.isEmpty else {
                _text.wrappedValue = ""
                _width.wrappedValue = AmountTextField.minWidth
                return
            }

            if text == separator {
                text = "0" + text
            }

            let parts = text.split(whereSeparator: { $0 == separator.first })

            var integer = String(parts[0].replacingOccurrences(of: separator, with: "").prefix(9))
            if integer != "0" {
                integer = String(integer.drop(while: { $0 == "0".first }))
            }

            var fractional = parts.count > 1 ? String(parts[1]) : (text.contains(separator) ? "" : nil)
            if let _fractional = fractional {
                fractional = separator + String(_fractional.prefix(9))
            }

            let integerString = NSAttributedString(
                string: "\(integer)",
                attributes: [
                    .font: UIFont(
                        descriptor: UIFont.systemFont(
                            ofSize: FontConfiguration.rounded.balanceLarge.pointSize,
                            weight: .semibold
                        )
                        .fontDescriptor.withDesign(.rounded)
                            ?? UIFont.systemFont(ofSize: 48).fontDescriptor,
                        size: FontConfiguration.rounded.balanceLarge.pointSize
                    )
                ]
            )

            let fractionalString = NSAttributedString(
                string: "\(fractional ?? "")",
                attributes: [
                    .font: UIFont(
                        descriptor: UIFont.systemFont(
                            ofSize: FontConfiguration.rounded.balanceSmall.pointSize,
                            weight: .semibold
                        )
                        .fontDescriptor.withDesign(.rounded)
                            ?? UIFont.systemFont(ofSize: 30).fontDescriptor,
                        size: FontConfiguration.rounded.balanceSmall.pointSize
                    )
                ]
            )

            let attributedText = NSMutableAttributedString(attributedString: integerString)
            var width = integerString.size().width

            if fractional != nil {
                attributedText.append(fractionalString)
                width += fractionalString.size().width
            }

            self.attributedText = attributedText

            _text.wrappedValue = attributedText.string
            _width.wrappedValue = min(maxWidth, max(AmountTextField.minWidth, width))
        }
    }

    func makeUIView(context: Context) -> TextField {
        let textField = TextField(frame: .zero, text: _text, width: _width, maxWidth: maxWidth)
        textField.keyboardType = .decimalPad
        textField.textColor = textColor
        return textField
    }

    func updateUIView(_ uiView: TextField, context: Context) {
        if uiView.text != _text.wrappedValue {
            uiView.text = _text.wrappedValue
        }
        
        uiView.maxWidth = maxWidth
        uiView.textColor = textColor

        DispatchQueue.main.async {
            uiView.updateText()
        }
    }
}
