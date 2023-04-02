//
//  Created by Vladislav Kiriukhin on 02.04.2023.
//

import Foundation
import SwiftUI

import WizardInfo

final class WizardRouter: Router {
    private let _navigationRouter: NavigationRouter
    private let transitioningDelegate: WizardTransitioningDelegate
    private weak var parentNavigationRouter: NavigationRouter?

    var viewController: UIViewController {
        _navigationRouter.viewController
    }

    init(parentNavigationRouter: NavigationRouter) {
        let transitioningDelegate = WizardTransitioningDelegate()

        let navigationRouter = NavigationRouter { controller in
            controller.navigationBar.isHidden = true
        }

        var onCreateWallet: (() -> Void)?
        var onImportWallet: (() -> Void)?
        
        let wizardInitialRouter = WizardInitialRouter(
            onCreateWallet: { onCreateWallet?() },
            onImportWallet: { onImportWallet?() }
        )

        navigationRouter.embed(router: wizardInitialRouter)

        navigationRouter.viewController.modalPresentationStyle = .fullScreen
        navigationRouter.viewController.transitioningDelegate = transitioningDelegate

        self._navigationRouter = navigationRouter
        self.transitioningDelegate = transitioningDelegate
        self.parentNavigationRouter = parentNavigationRouter

        onCreateWallet = { [weak self] in
            self?.showCongratulations()
        }

        onImportWallet = { [weak self] in
            self?.showFinal()
//            self?.showImport()
        }
    }

    func showCongratulations() {
        let router = WizardCongratulationsRouter(
            onShowMnemonicWords: { [weak self] in
                self?.showMnemonicWordsList()
            }
        )

        _navigationRouter.push(router: router)
    }

    func showImport() {
        let router = WizardMnemonicInputRouter(
            state: .import(count: 24), // TODO: magic const
            onComplete: {
                // TODO: after import
            },
            onForgotWords: { [weak self] in
                self?.showForgotMnemonicWords()
            }
        )

        _navigationRouter.push(router: router)
    }

    func showMnemonicWordsList() {
        let router = WizardMnemonicRouter(
            onComplete: { [weak self] in
                self?.showMnemonicWordsTest()
            }
        )

        _navigationRouter.push(router: router)
    }

    func showMnemonicWordsTest() {
        let router = WizardMnemonicInputRouter(
            state: .test(indices: [5, 17, 19]),
            onComplete: { [weak self] in
                self?.showPasscodeSetUp()
            },
            onForgotWords: { }
        )

        _navigationRouter.push(router: router)
    }

    func showPasscodeSetUp() {
        let router = WizardPasscodeRouter(
            isInConfirmationMode: false
        ) { [weak self] in
            self?.showPasscodeConfirmation()
        }

        _navigationRouter.push(router: router)
    }

    func showPasscodeConfirmation() {
        let router = WizardPasscodeRouter(
            isInConfirmationMode: true
        ) { [weak self] in
            self?.showBiometric()
        }

        _navigationRouter.push(router: router)
    }

    func showBiometric() {
        let router = WizardBiometricRouter(
            onSuccess: { },
            onSkip: { [weak self] in
                self?.showFinal()
                self?._navigationRouter.dismissTopmost()
            }
        )

        router.viewController.modalPresentationStyle = .fullScreen
        _navigationRouter.present(router: router)
    }

    func showFinal() {
        let router = WizardReadyRouter { [parentNavigationRouter] in
            parentNavigationRouter?.dismissTopmost()
        }
        _navigationRouter.push(router: router)
    }

    func showForgotMnemonicWords() {
        let router = WizardForgotMnemonicRouter(
            onReturnToMnemonicInput: { [weak _navigationRouter] in
                _navigationRouter?.dismissTopmost()
            },
            onReturnToInitial: {
                // TODO: reset stack
            }
        )
        _navigationRouter.push(router: router)
    }
}

final class WizardTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        WizardPresentAnimationController()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        WizardDismissAnimationController()
    }
}

private final class WizardPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        1.25
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let targetController = transitionContext.viewController(forKey: .to),
              let targetView = targetController.view else {
            return
        }

        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: targetController)

        let sourceView = UIView()
        sourceView.backgroundColor = .white
        sourceView.clipsToBounds = true
        sourceView.layer.cornerCurve = .continuous
        sourceView.layer.cornerRadius = 16

        sourceView.frame = finalFrame
        targetView.frame = finalFrame

        sourceView.transform = .init(translationX: 0, y: finalFrame.height)
        targetView.alpha = 0.0

        containerView.addSubview(sourceView)
        containerView.addSubview(targetView)

        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0.0) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.6) {
                sourceView.transform = .identity
            }

            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.7) {
                sourceView.layer.cornerRadius = 0
            }

            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 1.0) {
                targetView.alpha = 1.0
            }
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

private final class WizardDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.75
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let sourceController = transitionContext.viewController(forKey: .from),
              let sourceView = sourceController.view.snapshotView(afterScreenUpdates: false) else {
            return
        }

        guard let targetController = transitionContext.viewController(forKey: .to),
              let targetView = targetController.view else {
            return
        }

        let containerView = transitionContext.containerView

        let initialFrame = transitionContext.initialFrame(for: sourceController)

        let sourceRollView = UIView()
        sourceRollView.backgroundColor = .white
        sourceRollView.clipsToBounds = true
        sourceRollView.layer.cornerCurve = .continuous
        sourceRollView.layer.cornerRadius = 0

        containerView.addSubview(targetView)
        containerView.addSubview(sourceRollView)
        sourceRollView.addSubview(sourceView)

        sourceRollView.frame = initialFrame
        sourceView.frame = sourceRollView.bounds
        targetView.frame = initialFrame

        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0.0) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
                sourceRollView.transform = .init(translationX: 0, y: initialFrame.height * 0.5) // TODO: normal coord
            }

            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4) {
                sourceRollView.layer.cornerRadius = 16
            }

            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.6) {
                sourceView.alpha = 0.0
            }
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
