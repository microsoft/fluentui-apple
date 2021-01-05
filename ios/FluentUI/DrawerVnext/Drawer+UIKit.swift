//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

// MARK: Drawer + UIViewControllerTransitioningDelegate

extension DrawerVnext: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

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

        // delegate animation to swiftui by changing state
        if isPresentingDrawer {
            transitionContext.containerView.addSubview(drawerView)
            drawerView.frame = UIScreen.main.bounds
            DispatchQueue.main.asyncAfter(deadline: .now() + state.animationDuration) { [weak self] in
                if let strongSelf = self {
                    strongSelf.state.isExpanded = isPresentingDrawer
                }
                transitionContext.completeTransition(true)
            }
        } else {
            self.state.isExpanded = isPresentingDrawer
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

@objc(MSFDrawerVnextControllerDelegate)
public protocol DrawerVnextControllerDelegate: AnyObject {
    /// Called when a user opens/closes the drawer  to change its expanded state. Use `isExpanded` property to get the current state.
    @objc optional func drawerDidChangeState(state: DrawerState, controller: UIViewController)
}

/// ` DrawerVnext` is UIKit wrapper that exposes the SwiftUI Drawer implementation
@objc(MSFDrawerVnext)
open class DrawerVnext: UIHostingController<Drawer<DrawerContentViewController>> {

    private var drawer: Drawer<DrawerContentViewController>

    public weak var delegate: DrawerVnextControllerDelegate?

    @objc open var state: DrawerState {
        return self.rootView.state
    }

    @objc public init(contentViewController: UIViewController) {
        let drawer = Drawer(content: DrawerContentViewController(contentViewController: contentViewController))
        self.drawer = drawer
        super.init(rootView: drawer)

        transitioningDelegate = self
        view.backgroundColor = .clear
        modalPresentationStyle = .overFullScreen

        addDelegateNotification()
    }

    @objc required dynamic public init?(coder aDecoder: NSCoder) {
        let drawer = Drawer(content: DrawerContentViewController(contentViewController: UIViewController()))
        self.drawer = drawer
        super.init(coder: aDecoder)
    }

    private func addDelegateNotification() {
        self.drawer = self.drawer.didChangeState({ [weak self] in
            if let strongSelf = self {
                strongSelf.delegate?.drawerDidChangeState?(state: strongSelf.state, controller: strongSelf)
                if !strongSelf.drawer.state.isExpanded {
                    strongSelf.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
}

/// `DrawerContentViewController` is SwiftUI wrapper classes that embeds a UIViewController used to host UIKit content as a SwiftUI componenet
public struct DrawerContentViewController: UIViewControllerRepresentable {

    private var contentView: UIViewController

    init(contentViewController: UIViewController) {
        self.contentView = contentViewController
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        return contentView
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    public typealias UIViewControllerType = UIViewController
}
