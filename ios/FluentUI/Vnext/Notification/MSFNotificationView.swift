//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// UIKit wrapper that exposes the SwiftUI `Notification` implementation
@objc open class MSFNotification: ControlHostingView {

    /// Creates a new MSFNotification instance.
    /// - Parameters:
    ///   - style: The MSFNotification value used by the Notification.
    ///   - message: The primary text to display in the Notification.
    @objc public init(style: MSFNotificationStyle,
                      message: String) {
        notification = NotificationViewSwiftUI(style: style, message: message)
        super.init(AnyView(notification))
    }

    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc public var state: MSFNotificationState {
        return notification.state
    }

    // MARK: - Show/Hide Methods

    public func showNotification(in view: UIView, completion: ((MSFNotification) -> Void)? = nil) {
        guard self.view.window == nil else {
            return
        }

        let style = notification.tokens.style
        let presentationOffset: CGFloat! = notification.tokens.presentationOffset
        if style.isToast, let currentToast = MSFNotification.currentToast, currentToast.view.window != nil {
            currentToast.hide {
                self.showNotification(in: view, completion: completion)
            }
            return
        }

        self.view.translatesAutoresizingMaskIntoConstraints = false
        if let anchorView = anchorView, anchorView.superview == view {
            view.insertSubview(self.view, belowSubview: anchorView)
        } else {
            view.addSubview(self.view)
        }

        let anchor = anchorView?.topAnchor ?? view.safeAreaLayoutGuide.bottomAnchor
        constraintWhenHidden = self.view.topAnchor.constraint(equalTo: anchor)
        constraintWhenShown = self.view.bottomAnchor.constraint(equalTo: anchor, constant: -presentationOffset)

        var constraints = [NSLayoutConstraint]()
        constraints.append(animated ? constraintWhenHidden : constraintWhenShown)
        if style.needsFullWidth {
            constraints.append(self.view.leadingAnchor.constraint(equalTo: view.leadingAnchor))
            constraints.append(self.view.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        } else {
            constraints.append(self.view.centerXAnchor.constraint(equalTo: view.centerXAnchor))
            constraints.append(self.view.widthAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.widthAnchor, constant: -2 * presentationOffset))
        }
        NSLayoutConstraint.activate(constraints)

        if style.isToast {
            MSFNotification.currentToast = self
        }

        let completionForShow = { (_: Bool) in
            UIAccessibility.post(notification: .layoutChanged, argument: self.view)
            completion?(self)
        }

        if animated {
        view.layoutIfNeeded()
            UIView.animate(withDuration: style.animationDurationForShow,
                           delay: 0,
                           usingSpringWithDamping: style.animationDampingRatio,
                           initialSpringVelocity: 0,
                           animations: {
                self.constraintWhenHidden.isActive = false
                self.constraintWhenShown.isActive = true
                view.layoutIfNeeded()
            }, completion: completionForShow)
        } else {
            completionForShow(true)
        }
    }

    @objc public func hide(after delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        let hideDelay: TimeInterval = {
            switch state.style {
            case .primaryToast, .primaryBar, .primaryOutlineBar, .neutralBar:
                return delay
            case .neutralToast, .dangerToast, .warningToast:
                return (delay == 0) ? delay : .infinity
            }
        }()

        guard self.view.window != nil && constraintWhenHidden != nil && hideDelay != .infinity else {
            return
        }

        guard hideDelay == 0 else {
            DispatchQueue.main.asyncAfter(deadline: .now() + hideDelay) { [weak self] in
                self?.hide(completion: completion)
            }
            return
        }

        if let completion = completion {
            completionsForHide.append(completion)
        }
        let completionForHide = {
            self.view.removeFromSuperview()
            if MSFNotification.currentToast == self {
                MSFNotification.currentToast = nil
            }
            UIAccessibility.post(notification: .layoutChanged, argument: nil)

            self.completionsForHide.forEach { $0() }
            self.completionsForHide.removeAll()
        }
        if animated && !isHiding {
            isHiding = true
            UIView.animate(withDuration: notification.tokens.style.animationDurationForHide, animations: {
                self.constraintWhenShown.isActive = false
                self.constraintWhenHidden.isActive = true
                self.view.superview?.layoutIfNeeded()
            }, completion: { _ in
                self.isHiding = false
                completionForHide()
            })
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
    private var notification: NotificationViewSwiftUI!
    private var isHiding: Bool = false
}
