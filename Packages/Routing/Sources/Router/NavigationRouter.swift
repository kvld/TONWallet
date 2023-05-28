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

        navigationControllerDelegate.didShow = { [weak self] newTopController in
            self?.removeChildren(afterViewController: newTopController)
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

    public func dismissTopmost(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let lastRouter = children.last else {
            return
        }

        lastRouter.viewController.dismiss(animated: animated, completion: completion)
        children = children.filter { $0.viewController !== lastRouter.viewController }
    }

    public func popTopmost(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }

    public func popToRoot(animated: Bool = true) {
        navigationController.popToRootViewController(animated: animated)
    }

    // MARK: - Private

    private func removeChildren(afterViewController controller: UIViewController) {
        var needDropCount = 0
        for router in children.reversed() {
            if router.viewController === controller {
                break
            } else {
                needDropCount += 1
            }
        }

        children = Array(children.dropLast(needDropCount))
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
