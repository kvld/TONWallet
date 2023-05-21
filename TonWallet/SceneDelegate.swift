//
//  Created by Vladislav Kiriukhin on 24.03.2023.
//

import UIKit
import SwiftUI
import Routing

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private var mainNavigationRouter: NavigationRouter?
    private var deeplinkRouter: DeeplinkRouter?

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: scene)

        let mainNavigationRouter = NavigationRouter {
            $0.navigationBar.isHidden = true
            $0.navigationBar.barStyle = .black
        }
        let mainRouter = MainRouter(parentNavigationRouter: mainNavigationRouter)
        mainNavigationRouter.embed(router: mainRouter)

        let deeplinkRouter = DeeplinkRouter(presentingRouter: mainNavigationRouter)

        self.window = window
        self.mainNavigationRouter = mainNavigationRouter
        self.deeplinkRouter = deeplinkRouter

        window.rootViewController = mainNavigationRouter.viewController
        window.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        deeplinkRouter?.handleDeeplink(for: url)
    }
}

