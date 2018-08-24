//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

// MARK: MSDrawerPresentationDirection

@objc public enum MSDrawerPresentationDirection: Int {
    case down   // drawer animated down from a top base
    case up     // drawer animated up from a bottom base
}

// MARK: - MSDrawerController

/**
 `MSDrawerController` is used to present a portion of UI in a slider frame that shows up or down depending on `presentationDirection`. Use `presentationOrigin` to specify the vertical offset (in screen coordinates) from which to show drawer. If not provided it will be calculated automatically: bottom of navigation bar for `.down` presentation and bottom of the screen for `.up` presentation.

 `MSDrawerController` will be presented as a popover on iPad and so requires either `sourceView`/`sourceRect` or `barButtonItem` to be provided via available initializers. Use `permittedArrowDirections` to specify the direction of the popover arrow.

 Override `preferredWidth` to provide a custom preferred width for presentation on iPad or landscape iPhone.
 */

open class MSDrawerController: UIViewController {
    private struct Constants {
        static let preferredWidthForLandscapePhone: CGFloat = 400
        static let preferredWidthForPad: CGFloat = 300
    }

    private enum PresentationStyle {
        case slideover
        case popover
    }

    /// Use `permittedArrowDirections` to specify the direction of the popover arrow for popover presentation on iPad.
    @objc open var permittedArrowDirections: UIPopoverArrowDirection = .any
    ///  Override `preferredWidth` to provide a custom preferred width for presentation on iPad or landscape iPhone.
    open var preferredWidth: CGFloat {
        if UIDevice.isPhone {
            let maxWidth = presentingViewController?.view?.window?.bounds.width ?? .infinity
            return min(UIScreen.isPortrait ? UIScreen.main.bounds.width : Constants.preferredWidthForLandscapePhone, maxWidth)
        } else {
            return Constants.preferredWidthForPad
        }
    }

    private let sourceView: UIView?
    private let sourceRect: CGRect?
    private let barButtonItem: UIBarButtonItem?
    /// The `y` position the slideover should slide from
    private let presentationOrigin: CGFloat?
    private let presentationDirection: MSDrawerPresentationDirection

    /**
     Initializes `MSDrawerController` to be presented as a popover from `sourceRect` in `sourceView` on iPad and as a slideover on iPhone.

     - Parameter sourceView: The view containing the anchor rectangle for the popover.
     - Parameter sourceRect: The rectangle in the specified view in which to anchor the popover.
     - Parameter presentationOrigin: The vertical offset (in screen coordinates) from which to show a slideover. If not provided it will be calculated automatically: bottom of navigation bar for `.down` presentation and bottom of the screen for `.up` presentation.
     - Parameter presentationDirection: The direction of slideover presentation (`.down` or `.up`).
     */
    @objc public init(sourceView: UIView, sourceRect: CGRect, presentationOrigin: CGFloat = -1, presentationDirection: MSDrawerPresentationDirection) {
        self.sourceView = sourceView
        self.sourceRect = sourceRect
        self.barButtonItem = nil
        self.presentationOrigin = presentationOrigin == -1 ? nil : presentationOrigin
        self.presentationDirection = presentationDirection

        super.init(nibName: nil, bundle: nil)

        initialize()
    }

    /**
     Initializes `MSDrawerController` to be presented as a popover from `barButtonItem` on iPad and as a slideover on iPhone.

     - Parameter barButtonItem: The bar button item on which to anchor the popover.
     - Parameter presentationOrigin: The vertical offset (in screen coordinates) from which to show a slideover. If not provided it will be calculated automatically: bottom of navigation bar for `.down` presentation and bottom of the screen for `.up` presentation.
     - Parameter presentationDirection: The direction of slideover presentation (`.down` or `.up`).
     */
    @objc public init(barButtonItem: UIBarButtonItem, presentationOrigin: CGFloat = -1, presentationDirection: MSDrawerPresentationDirection) {
        self.sourceView = nil
        self.sourceRect = nil
        self.barButtonItem = barButtonItem
        self.presentationOrigin = presentationOrigin == -1 ? nil : presentationOrigin
        self.presentationDirection = presentationDirection

        super.init(nibName: nil, bundle: nil)

        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialize() {
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MSColors.background
        view.isAccessibilityElement = false
    }

    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if !isBeingPresented {
            // The top offset is no longer accurate, and we cannot recalculate
            presentingViewController?.dismiss(animated: false)
        }
    }

    open override func accessibilityPerformEscape() -> Bool {
        presentingViewController?.dismiss(animated: true)
        return true
    }

    private func presentationStyle(for sourceViewController: UIViewController) -> PresentationStyle {
        guard let window = sourceViewController.view?.window else {
            // No window, use the device type as last resort. It will be only a problem in splitView on iPad
            return UIDevice.isPhone ? .slideover : .popover
        }
        if window.traitCollection.horizontalSizeClass == .compact || UIDevice.isPhonePlus {
            return .slideover
        }
        return .popover
    }
}

// MARK: - MSDrawerController: UIViewControllerTransitioningDelegate

extension MSDrawerController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented.presentationController is MSDrawerPresentationController {
            return MSDrawerTransitionAnimator(presenting: true, presentationDirection: presentationDirection)
        }
        return nil
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed.presentationController is MSDrawerPresentationController {
            return MSDrawerTransitionAnimator(presenting: false, presentationDirection: presentationDirection)
        }
        return nil
    }

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        switch presentationStyle(for: source) {
        case .slideover:
            return MSDrawerPresentationController(presentedViewController: presented, presenting: presenting, source: source, sourceObject: sourceView ?? barButtonItem, presentationOrigin: presentationOrigin, presentationDirection: presentationDirection)
        case .popover:
            let presentationController = UIPopoverPresentationController(presentedViewController: presented, presenting: presenting)
            presentationController.backgroundColor = MSColors.background
            presentationController.permittedArrowDirections = permittedArrowDirections

            if let sourceView = sourceView {
                presentationController.sourceView = sourceView
                if let sourceRect = sourceRect {
                    presentationController.sourceRect = sourceRect
                }
            } else if let barButtonItem = barButtonItem {
                presentationController.barButtonItem = barButtonItem
            } else {
                fatalError("A UIPopoverPresentationController should have a non-nil sourceView or barButtonItem set before the presentation occurs.")
            }

            return presentationController
        }
    }
}
