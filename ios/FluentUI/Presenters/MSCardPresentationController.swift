//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class MSCardPresentationController: UIPresentationController {
    // Workaround to get Voiceover to ignore the view behind the action sheet.
    // Setting accessibilityViewIsModal directly on the container does not work.
    private lazy var accessibilityContainer: UIView = {
        let view = UIView()
        view.accessibilityViewIsModal = true
        return view
    }()

    private let backgroundObscurable: Obscurable

    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, backgroundObscurable: Obscurable? = nil) {
        self.backgroundObscurable = backgroundObscurable ?? BlurringView(style: .dark)
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    override func presentationTransitionWillBegin() {
        accessibilityContainer.addSubview(backgroundObscurable.view)
        accessibilityContainer.addSubview(presentedViewController.view)
        containerView?.addSubview(accessibilityContainer)

        backgroundObscurable.isObscuring = false

        let transitionCoordinator = presentingViewController.transitionCoordinator
        transitionCoordinator?.animate(alongsideTransition: { _ in
            self.backgroundObscurable.isObscuring = true
        })
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed {
            UIAccessibility.post(notification: .screenChanged, argument: presentedViewController.view)
        } else {
            backgroundObscurable.view.removeFromSuperview()
        }
    }

    override func dismissalTransitionWillBegin() {
        let transitionCoordinator = presentingViewController.transitionCoordinator

        transitionCoordinator?.animate(alongsideTransition: { _ in
            self.backgroundObscurable.isObscuring = false
        })
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            backgroundObscurable.view.removeFromSuperview()
            UIAccessibility.post(notification: .screenChanged, argument: presentingViewController.view)
        }
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        return containerView?.bounds ?? .zero
    }

    override func containerViewDidLayoutSubviews() {
        if let containerView = containerView {
            accessibilityContainer.frame = containerView.bounds
            backgroundObscurable.view.frame = accessibilityContainer.bounds
            presentedView?.frame = frameOfPresentedViewInContainerView
        }
    }
}
