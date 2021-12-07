//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// UIKit wrapper that exposes the SwiftUI `Notification` implementation
@objc open class MSFNotification: NSObject, FluentUIWindowProvider {

    /// The UIView representing the Notification.
    @objc open var view: UIView {
        return hostingController.view
    }

    /// Creates a new MSFNotification instance.
    /// - Parameters:
    ///   - style: The MSFNotification value used by the Notification.
    ///   - message: The primary text to display in the Notification.
    ///   - theme: The FluentUIStyle instance representing the theme to be overriden for this Notification.
    @objc public init(style: MSFNotificationStyle,
                      message: String,
                      theme: FluentUIStyle? = nil) {
        super.init()

        notification = NotificationViewSwiftUI(style: style, message: message, dismissAction: { self.hide() })
        hostingController = FluentUIHostingController(rootView: AnyView(notification
                                                                            .windowProvider(self)
                                                                            .modifyIf(theme != nil, { notification in
                                                                                notification.customTheme(theme!)
                                                                            })))
        hostingController.view.backgroundColor = UIColor.clear
        hostingController.disableSafeAreaInsets()
    }

    public var state: MSFNotificationState {
        get {
            return notification.state
        }

        set {
            notification.state = newValue as! MSFNotificationStateImpl
        }
    }

    public var style: MSFNotificationStyle {
        get {
            return notification.state.style
        }

        set {
            notification.state.style = newValue
            notification.tokens.style = newValue
        }
    }

    public var delayTime: TimeInterval = 2

    // MARK: - FluentUIWindowProvider

    var window: UIWindow? {
        return self.view.window
    }

    // MARK: - Show/Hide Methods

    public func showNotification(in view: UIView, completion: ((MSFNotification) -> Void)? = nil) {
        if isShown {
            return
        }

        let style = notification.tokens.style
        let presentationOffset: CGFloat! = notification.tokens.presentationOffset
        if style.isToast, let currentToast = MSFNotification.currentToast {
            currentToast.hide {
                self.showNotification(in: view, completion: completion)
            }
            return
        }

        hostingController = FluentUIHostingController(rootView: AnyView(notification
                                                                                .windowProvider(self)
                                                                           ))
        hostingController.disableSafeAreaInsets()
        var hostingControllerView: UIView! = hostingController.view
        hostingControllerView = hostingController.view
        hostingControllerView.translatesAutoresizingMaskIntoConstraints = false
        if let anchorView = anchorView, anchorView.superview == view {
            view.insertSubview(hostingControllerView, belowSubview: anchorView)
        } else {
            view.addSubview(hostingControllerView)
        }

        let anchor = anchorView?.topAnchor ?? view.safeAreaLayoutGuide.bottomAnchor
        constraintWhenHidden = hostingControllerView.topAnchor.constraint(equalTo: anchor)
        constraintWhenShown = hostingControllerView.bottomAnchor.constraint(equalTo: anchor, constant: -presentationOffset)

        var constraints = [NSLayoutConstraint]()
        constraints.append(animated ? constraintWhenHidden : constraintWhenShown)
        if style.needsFullWidth {
            constraints.append(hostingControllerView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
            constraints.append(hostingControllerView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        } else {
            constraints.append(hostingControllerView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
            constraints.append(hostingControllerView.widthAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.widthAnchor, constant: -2 * presentationOffset))
        }
        NSLayoutConstraint.activate(constraints)

        isShown = true
        if style.isToast {
            MSFNotification.currentToast = self
        }

        let completionForShow = { (_: Bool) in
            UIAccessibility.post(notification: .layoutChanged, argument: hostingControllerView)
            completion?(self)
        }

        if animated {
        view.layoutIfNeeded()
            UIView.animate(withDuration: style.animationDurationForShow, delay: 0, usingSpringWithDamping: style.animationDampingRatio, initialSpringVelocity: 0, animations: {
                self.constraintWhenHidden.isActive = false
                self.constraintWhenShown.isActive = true
                view.layoutIfNeeded()
            }, completion: completionForShow)
        } else {
            completionForShow(true)
        }
    }

    @objc public func hide(after delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        if !isShown || delay == .infinity {
            return
        }

        if delay > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.hide(completion: completion)
            }
            return
        }

        let hostingControllerView = self.hostingController.view
        if let completion = completion {
            completionsForHide.append(completion)
        }
        let completionForHide = {
            hostingControllerView?.removeFromSuperview()
            self.isShown = false
            if MSFNotification.currentToast == self {
                MSFNotification.currentToast = nil
            }
            UIAccessibility.post(notification: .layoutChanged, argument: nil)

            self.completionsForHide.forEach { $0() }
            self.completionsForHide.removeAll()
        }
        if animated {
            if !isHiding {
                isHiding = true
                UIView.animate(withDuration: notification.tokens.style.animationDurationForHide, animations: {
                    self.constraintWhenShown.isActive = false
                    self.constraintWhenHidden.isActive = true
                    hostingControllerView?.superview?.layoutIfNeeded()
                }, completion: { _ in
                    self.isHiding = false
                    completionForHide()
                })
            }
        }
    }

    // MARK: - Private variables

    private static var allowsMultipleToasts: Bool = false
    private static var currentToast: MSFNotification? {
        didSet {
            if allowsMultipleToasts {
                currentToast = nil
            }
        }
    }

    private var anchorView: UIView?
    private var animated: Bool = true
    private var completionsForHide: [() -> Void] = []
    private var constraintWhenHidden: NSLayoutConstraint!
    private var constraintWhenShown: NSLayoutConstraint!
    private var hostingController: FluentUIHostingController!
    private var notification: NotificationViewSwiftUI!
    private var isHiding: Bool = false
    private var isShown: Bool = false
}
