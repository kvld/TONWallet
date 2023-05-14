//
//  Created by Vladislav Kiriukhin on 24.03.2023.
//

import Foundation
import UIKit
import Sheet

public final class NavigationRouter: Router {
    private let navigationController: UINavigationController
    private let navigationControllerDelegate = NavigationControllerDelegate()

    public var viewController: UIViewController { navigationController }

    private(set) public var children: [Router] = []

    public init(withControllerSetup: ((UINavigationController) -> Void)? = nil) {
        let navigationController = UINavigationController()
        navigationController.delegate = navigationControllerDelegate
        withControllerSetup?(navigationController)

        self.navigationController = navigationController

        // TODO: handle modal dismiss
        navigationControllerDelegate.didShow = { [weak self] newTopController in
            guard let self else { return }

            var needDropCount = 0
            for router in self.children.reversed() {
                if router.viewController === newTopController {
                    break
                } else {
                    needDropCount += 1
                }
            }

            self.children = Array(self.children.dropLast(needDropCount))
        }
    }

    public func embed(router: Router) {
        children.append(router)
        navigationController.setViewControllers([router.viewController], animated: false)
    }

    public func present(router: Router, overModal: Bool = false, animated: Bool = true) {
        children.append(router)

        if overModal, let controller = navigationController.presentedViewController {
            controller.present(router.viewController, animated: animated)
        } else {
            navigationController.present(router.viewController, animated: animated)
        }
    }

    public func push(router: Router, animated: Bool = true) {
        children.append(router)

        navigationController.interactivePopGestureRecognizer?.isEnabled = router.canDismissInteractively
        navigationController.pushViewController(router.viewController, animated: true)
    }

    public func dismissTopmost() {
        guard let lastRouter = children.last else {
            return
        }

        lastRouter.viewController.dismiss(animated: true)
        children = children.filter { $0.viewController !== lastRouter.viewController }
    }

    public func popTopmost() {
        navigationController.popViewController(animated: true)
    }
}

private final class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    var didShow: ((UIViewController) -> Void)?

    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        didShow?(viewController)
    }
}
