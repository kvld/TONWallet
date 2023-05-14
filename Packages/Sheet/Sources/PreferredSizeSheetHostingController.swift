//
//  Created by Vladislav Kiriukhin on 13.05.2023.
//

import SwiftUI
import Support
import Components

private final class CustomHostingView<Content: View>: _UIHostingView<Content> {
    var onLayoutSubviews: (() -> Void)?

    override func layoutSubviews() {
        super.layoutSubviews()

        onLayoutSubviews?()
    }
}

@available(iOS 15.0, *)
public final class PreferredSizeSheetHostingController<Content: View>: UIViewController {
    private var _lastHeight: CGFloat = 0
    private var _hostingView: UIView

    public init(rootView: Content) {
        let view = CustomHostingView(rootView: rootView)
        _hostingView = view

        super.init(nibName: nil, bundle: nil)

        view.onLayoutSubviews = { [weak self] in
            self?.updatePreferredContentSize()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(_hostingView)
        _hostingView.translatesAutoresizingMaskIntoConstraints = false
        _hostingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        _hostingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        _hostingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        view.backgroundColor = UIColor(Color.background.content)

        sheetPresentationController?.preferredCornerRadius = 10
        sheetPresentationController?.prefersGrabberVisible = false
    }

    private func updatePreferredContentSize() {
        _hostingView.sizeToFit()
        let sizeThatFits = _hostingView.bounds.size
        let roundedHeight = sizeThatFits.height.rounded(.up)

        if roundedHeight == _lastHeight {
            return
        }

        _lastHeight = roundedHeight

        let detent: UISheetPresentationController.Detent = ._custom(height: roundedHeight)

        sheetPresentationController?.animateChanges {
            sheetPresentationController?.detents = [detent]
        }
    }
}
