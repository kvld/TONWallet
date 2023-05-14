//
//  Created by Vladislav Kiriukhin on 14.05.2023.
//

import UIKit
import QRScanner

final class QRScannerRouter: Router {
    private weak var parentNavigationRouter: NavigationRouter?

    let viewController: UIViewController

    init(parentNavigationRouter: NavigationRouter, completion: @escaping (String) -> Void) {
        let controller = QRScannerController()
        self.viewController = controller
        self.parentNavigationRouter = parentNavigationRouter

        controller.onSettingsOpenTap = { [weak self] in self?.openSettings() }
        controller.onCloseTap = { [weak self] in self?.close() }
        controller.onSuccessfulScan = { [weak self] in
            self?.close()
            completion($0)
        }
    }

    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    func close() {
        parentNavigationRouter?.dismissTopmost()
    }
}
