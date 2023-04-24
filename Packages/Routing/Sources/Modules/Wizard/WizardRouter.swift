//
//  Created by Vladislav Kiriukhin on 02.04.2023.
//

import Foundation
import SwiftUI
import WizardState
import WizardInfo

@MainActor
final class WizardRouter: Router, WizardViewModelOutput {
    private let _navigationRouter: NavigationRouter
    private let transitioningDelegate: WizardTransitioningDelegate
    private weak var parentNavigationRouter: NavigationRouter?

    private let viewModel: WizardViewModel

    var viewController: UIViewController {
        _navigationRouter.viewController
    }

    init(viewModel: WizardViewModel, parentNavigationRouter: NavigationRouter) {
        let transitioningDelegate = WizardTransitioningDelegate()

        let navigationRouter = NavigationRouter { controller in
            controller.navigationBar.isHidden = true
        }

        let wizardInitialRouter = WizardInitialRouter(viewModel: viewModel)

        navigationRouter.embed(router: wizardInitialRouter)

        navigationRouter.viewController.modalPresentationStyle = .fullScreen
        navigationRouter.viewController.transitioningDelegate = transitioningDelegate

        self._navigationRouter = navigationRouter
        self.transitioningDelegate = transitioningDelegate
        self.parentNavigationRouter = parentNavigationRouter
        self.viewModel = viewModel

        viewModel.output = self
    }

    func showCongratulations() {
        let router = WizardCongratulationsRouter(viewModel: viewModel)
        _navigationRouter.push(router: router)
    }

    func showImport() {
        let router = WizardMnemonicInputRouter(state: .import, viewModel: viewModel)
        _navigationRouter.push(router: router)
    }

    func showMnemonicWordsList() {
        let router = WizardMnemonicRouter(viewModel: viewModel)
        _navigationRouter.push(router: router)
    }

    func showMnemonicWordsTooFastAlert(canSkip: Bool) {
        var actions: [UIAlertAction] = [
            .init(title: "OK, sorry", style: .cancel)
        ]

        if canSkip {
            actions.append(
                .init(title: "Skip", style: .default) { [weak self] _ in
                    self?.showMnemonicWordsTest()
                }
            )
        }

        let router = AlertRouter(
            title: "Sure done?",
            message: "You didn't have enough time to write these words down.",
            actions: actions
        )

        _navigationRouter.present(router: router)
    }

    func showMnemonicWordsTest() {
        let router = WizardMnemonicInputRouter(state: .test, viewModel: viewModel)
        _navigationRouter.push(router: router)
    }

    func showFailedTestAlert() {
        let actions: [UIAlertAction] = [
            .init(title: "See words", style: .default) { [weak _navigationRouter] _ in
                _navigationRouter?.dismissTopmost()
                _navigationRouter?.popTopmost()
            },
            .init(title: "Try again", style: .default) { [weak _navigationRouter] _ in
                _navigationRouter?.dismissTopmost()
            }
        ]

        let router = AlertRouter(
            title: "Incorrect words",
            message: "The secret words you have entered do not match the ones in the list.",
            actions: actions
        )

        _navigationRouter.present(router: router)
    }

    func showPasscodeSetUp() {
        let router = WizardPasscodeRouter(isInConfirmationMode: false, viewModel: viewModel)
        _navigationRouter.push(router: router)
    }

    func showPasscodeConfirmation() {
        let router = WizardPasscodeRouter(isInConfirmationMode: true, viewModel: viewModel)
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
