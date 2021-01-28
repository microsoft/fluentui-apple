//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

// MARK: - Drawer

@objc public protocol MSFDrawerControllerDelegate: AnyObject {
    /// Called when a user opens/closes the drawer  to change its expanded state. Use `isExpanded` property to get the current state.
    @objc optional func drawerDidChangeState(state: MSFDrawerState, controller: UIViewController)
}

/// ` Drawer` is UIKit wrapper that exposes the SwiftUI Drawer implementation
@objc(MSFDrawer)
open class MSFDrawer: UIHostingController<AnyView>, FluentUIWindowProvider {

    public var window: UIWindow? {
        return self.view.window
    }

    /// Set this delegate to recieve updates when drawer's state changes
    /// @see `DrawerControllerDelegate`
    public weak var delegate: MSFDrawerControllerDelegate?

    /// Represents the drawer's state with properties to configure its behavior.
    /// @see `DrawerState`
    @objc open var state: MSFDrawerState {
        return self.drawer.state
    }

    private var drawer: MSFDrawerView<UIViewControllerAdapter>

    @objc public init(contentViewController: UIViewController,
                      theme: FluentUIStyle? = nil) {
        let drawer = MSFDrawerView(content: UIViewControllerAdapter(contentViewController))
        self.drawer = drawer
        super.init(rootView: theme != nil ? AnyView(drawer.usingTheme(theme!)) : AnyView(drawer))

        drawer.tokens.windowProvider = self
        view.backgroundColor = .clear
        modalPresentationStyle = .overFullScreen
        transitioningDelegate = self

        state.onStateChange = stateChangeCompletion()
    }

    @objc public convenience init(contentViewController: UIViewController) {
        self.init(contentViewController: contentViewController,
                  theme: nil)
    }

    @objc required dynamic public init?(coder aDecoder: NSCoder) {
        let drawer = MSFDrawerView(content: UIViewControllerAdapter(UIViewController()))
        self.drawer = drawer
        super.init(coder: aDecoder)
    }

    private var transitionHandler: (() -> Void)?

    private var transitionInProgress: Bool = false

    private func stateChangeCompletion() -> ((Bool?) -> Void) {
        return { [weak self]  _ in
            if let strongSelf = self {
                strongSelf.notifyStateChange()
                strongSelf.dimissHostingViewIfRequired()
                strongSelf.transitionHandler?()
            }
        }
    }

    private func notifyStateChange() {
        delegate?.drawerDidChangeState?(state: state, controller: self)
    }

    private func dimissHostingViewIfRequired() {
        guard drawer.state.isExpanded == false else {
            return
        }

        dismiss(animated: false, completion: nil)
    }
}

// MARK: Drawer + UIViewControllerTransitioningDelegate

extension MSFDrawer: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    enum Constant {
        static let linearAnimationDuration: TimeInterval = 0.25
        static let disabledAnimationDuration: TimeInterval = 0
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if let isAnimationAssisted = transitionContext?.isAnimated, isAnimationAssisted == true {
            return Constant.linearAnimationDuration
        }
        return Constant.disabledAnimationDuration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let fromView = transitionContext.viewController(forKey: .from)!.view!
        let toView = transitionContext.viewController(forKey: .to)!.view!

        let isPresentingDrawer = toView == view

        let drawerView = isPresentingDrawer ? toView : fromView

        state.animationDuration = transitionDuration(using: transitionContext)

///       The presentation of drawer happens in two steps
///        1. Present the hosting view (trasnparent) without animation
///        2. Expand drawer view with animation (depending on the client's preference)
///        The animation is delegated to swiftUI framework instead of UIKit. The intent of overriding `UIViewControllerTransitioningDelegate` is to provide UIKit client interfaces
        if isPresentingDrawer {
            UIView.animate(withDuration: Constant.disabledAnimationDuration, animations: {
                transitionContext.containerView.addSubview(drawerView)
                drawerView.frame = UIScreen.main.bounds
            }, completion: { [weak self] _ in
                if let strongSelf = self {
                    if !(strongSelf.drawer.isPresentationGestureActive) {
                        strongSelf.state.isExpanded = true
                    }
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            })
        } else {
            state.isExpanded = false
            transitionInProgress = true
            transitionHandler = { [weak self] in
                if let strongSelf = self {
                    guard strongSelf.state.isExpanded == false, strongSelf.transitionInProgress == true else {
                        // verify state after transition is completed
                        return
                    }
                    drawerView.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    strongSelf.transitionInProgress = false
                }
            }
        }
    }
}
