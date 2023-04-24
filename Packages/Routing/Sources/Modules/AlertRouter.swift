//
//  Created by Vladislav Kiriukhin on 23.04.2023.
//

import UIKit

final class AlertRouter: Router {
    let viewController: UIViewController

    init(
        title: String? = nil,
        message: String? = nil,
        actions: [UIAlertAction] = []
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }

        viewController = alert
    }
}
