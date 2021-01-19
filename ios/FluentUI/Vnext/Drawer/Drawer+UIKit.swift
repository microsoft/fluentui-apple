//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

// MARK: Drawer + UIViewControllerTransitioningDelegate

extension MSFDrawerVnext: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    enum Constant {
        static let linearAnimationDuration: TimeInterval = 0.25
        static let disabledAnimationDuration: TimeInterval = 0
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

        // Delegate animation to swiftui by changing state
        if isPresentingDrawer {
            transitionContext.containerView.addSubview(drawerView)
            drawerView.frame = UIScreen.main.bounds
            DispatchQueue.main.asyncAfter(deadline: .now() + state.animationDuration) { [weak self] in
                if let strongSelf = self {
                    if !strongSelf.drawer.isPresentationGestureActive {
                        strongSelf.state.isExpanded = true
                    }
                }
                transitionContext.completeTransition(true)
            }
        } else {
            self.state.isExpanded = false
            DispatchQueue.main.asyncAfter(deadline: .now() + state.animationDuration) {
                drawerView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

// MARK: - DrawerVnext

@objc public protocol MSFDrawerVnextControllerDelegate: AnyObject {
    /// Called when a user opens/closes the drawer  to change its expanded state. Use `isExpanded` property to get the current state.
    @objc optional func drawerDidChangeState(state: MSFDrawerState, controller: UIViewController)
}

/// ` DrawerVnext` is UIKit wrapper that exposes the SwiftUI Drawer implementation
@objc(MSFDrawerVnext)
open class MSFDrawerVnext: UIHostingController<AnyView>, FluentUIWindowProvider {

    public var window: UIWindow? {
        return self.view.window
    }

    /// Set this delegate to recieve updates when drawer's state changes
    /// @see `DrawerVnextControllerDelegate`
    public weak var delegate: MSFDrawerVnextControllerDelegate?

    /// Represents the drawer's state with properties to configure its behavior.
    /// @see `DrawerState`
    @objc open var state: MSFDrawerState {
        return self.drawer.state
    }

    @objc public init(contentViewController: UIViewController,
                      theme: FluentUIStyle? = nil) {
        let drawer = MSFDrawerView(content: UIViewControllerAdapter(contentViewController))
        self.drawer = drawer
        super.init(rootView: theme != nil ? AnyView(drawer.usingTheme(theme!)) : AnyView(drawer))

        drawer.tokens.windowProvider = self
        transitioningDelegate = self
        view.backgroundColor = .clear
        modalPresentationStyle = .overFullScreen

        addDelegateNotification()
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

    private var drawer: MSFDrawerView<UIViewControllerAdapter>

    private func addDelegateNotification() {
        self.drawer = self.drawer.didChangeState({ [weak self] in
            if let strongSelf = self {
                guard let isDrawerExpanded = strongSelf.drawer.state.isExpanded else {
                    return
                }
                strongSelf.delegate?.drawerDidChangeState?(state: strongSelf.state, controller: strongSelf)
                if !isDrawerExpanded {
                    strongSelf.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
}
