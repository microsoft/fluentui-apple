//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

// MARK: Drawer + UIViewControllerTransitioningDelegate

extension DrawerVnext: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let fromView = transitionContext.viewController(forKey: .from)!.view!
        let toView = transitionContext.viewController(forKey: .to)!.view!

        let isPresentingDrawer = toView == view

        let drawerView = isPresentingDrawer ? toView : fromView

        // delegate animation to swiftui by changing state
        if isPresentingDrawer {
            transitionContext.containerView.addSubview(drawerView)
            drawerView.frame = UIScreen.main.bounds
            // Added a static interval as currently swiftui doesn't have an animation completion callback
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
                if let strongSelf = self {
                    strongSelf.drawerState.isExpanded = isPresentingDrawer
                }
                transitionContext.completeTransition(true)
            }
        } else {
            self.drawerState.isExpanded = isPresentingDrawer
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
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

// MARK: DrawerModal

/// `DrawerModal` is SwiftUI wrapper classes that embeds a UIViewController used to host UIKit content as a SwiftUI componenet
public struct DrawerModal {

    public struct DrawerShimView: View {

        private var drawer: Drawer<DrawerContentViewController>

        // convenience callback from underlying drawer controller
        public var notifyDrawerStateChange: (DrawerStateChangedCompletionBlock)?
        public var drawerState: DrawerState {
            return drawer.state
        }

        init(contentViewController: UIViewController) {
            drawer = Drawer(content: DrawerContentViewController(contentViewController: contentViewController))
        }

        public var body: some View {
            ZStack {
                drawer
                    .didChangedState { value in
                        withAnimation {
                            drawer.viewModel.expand = value
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }

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
}

// MARK: DrawerVnext

@objc(MSFDrawerVnextControllerDelegate)
public protocol DrawerVnextControllerDelegate: AnyObject {
    /// Called when a user opens/closes the drawer  to change its expanded state. Use `isExpanded` property to get the current state.
    @objc optional func drawerDidChangeExpandedState(state: DrawerState, controller: UIViewController)
}

/// ` DrawerVnext` is UIKit wrapper that exposes the SwiftUI Drawer implementation
@objc(MSFDrawerVnext)
open class DrawerVnext: UIHostingController<DrawerModal.DrawerShimView> {

    private var drawerShimView: DrawerModal.DrawerShimView

    public weak var delegate: DrawerVnextControllerDelegate?

    @objc open var drawerState: DrawerState {
        return self.rootView.drawerState
    }

    @objc public init(contentViewController: UIViewController) {
        let drawerShimView = DrawerModal.DrawerShimView(contentViewController: contentViewController)
        self.drawerShimView = drawerShimView
        super.init(rootView: drawerShimView)

        transitioningDelegate = self
        view.backgroundColor = .clear
        modalPresentationStyle = .overFullScreen

        addDelegateNotification()
    }

    @objc required dynamic public init?(coder aDecoder: NSCoder) {
        let drawerShimView = DrawerModal.DrawerShimView(contentViewController: UIViewController())
        self.drawerShimView = drawerShimView
        super.init(coder: aDecoder)
    }

    private func addDelegateNotification() {
        self.drawerShimView.notifyDrawerStateChange = { [weak self] _ in
            if let strongSelf = self {
                strongSelf.delegate?.drawerDidChangeExpandedState?(state: strongSelf.drawerState, controller: strongSelf)
            }
        }
    }
}
