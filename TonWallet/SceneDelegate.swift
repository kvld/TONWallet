//
//  SceneDelegate.swift
//  TonWallet
//
//  Created by Vladislav Kiriukhin on 24.03.2023.
//

import UIKit
import SwiftUI
import Routing

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var mainNavigationRouter: NavigationRouter?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: scene)

        let mainNavigationRouter = NavigationRouter {
            $0.navigationBar.isHidden = true
            $0.navigationBar.barStyle = .black
        }
        let mainRouter = MainRouter(parentNavigationRouter: mainNavigationRouter)
        mainNavigationRouter.embed(router: mainRouter)

        self.window = window
        self.mainNavigationRouter = mainNavigationRouter

        window.rootViewController = mainNavigationRouter.viewController
        window.makeKeyAndVisible()
    }
}

