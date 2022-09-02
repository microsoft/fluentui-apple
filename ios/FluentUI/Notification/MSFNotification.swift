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
    @objc public convenience init(style: MSFNotificationStyle) {
        self.init(style: style, isFlexibleWidthToast: false)
    }

    /// Creates a new MSFNotification instance.
    /// - Parameters:
    ///   - style: The MSFNotification value used by the Notification.
    ///   - isFlexibleWidthToast: Whether the width of the toast is set based  on the width of the screen or on its contents
    @objc public init(style: MSFNotificationStyle,
                      isFlexibleWidthToast: Bool = false) {
        self.isFlexibleWidthToast = isFlexibleWidthToast && style.isToast
        notification = FluentNotification(style: style,
                                          shouldSelfPresent: false)
        super.init(AnyView(notification))
        let defaultDismissAction = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.hide()
        }
        notification.state.actionButtonAction = notification.state.showDefaultDismissActionButton ? defaultDismissAction : nil
    }

    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc public var state: MSFNotificationState {
        return notification.state
    }

    public var tokenSet: NotificationTokenSet {
        return notification.tokenSet
    }

    // MARK: - Show/Hide Methods
    /// `show` is used to present the view inside a container view:
    /// insert into layout and show with optional animation. Constraints are used for the view positioning.
    /// - Parameters:
    ///   - view: The container view where this view will be presented.
    ///   - anchorView: The view used as the bottom anchor for presentation
    ///   (notification view is always presented up from the anchor). When no anchor view is provided the
    ///   bottom anchor of the container's safe area is used.
    ///   - animated: Indicates whether to use animation during presentation or not.
    ///   - completion: The closure to be called after presentation is completed.
    ///   Can be used to call `hide` with a delay.
    @objc public func show(in view: UIView,
                           from anchorView: UIView? = nil,
                           animated: Bool = true,
                           completion: ((MSFNotification) -> Void)? = nil) {
        guard self.window == nil else {
            return
        }

        let style = notification.state.style
        let presentationOffset = notification.tokenSet[.presentationOffset].float
        if style.isToast, let currentToast = MSFNotification.currentToast, currentToast.window != nil {
            currentToast.hide {
                self.show(in: view,
                          from: anchorView,
                          animated: animated,
                          completion: completion)
            }
            return
        }

        self.translatesAutoresizingMaskIntoConstraints = false
        if let anchorView = anchorView, anchorView.superview == view {
            view.insertSubview(self, belowSubview: anchorView)
        } else {
            view.addSubview(self)
        }

        let anchor: NSLayoutYAxisAnchor
        if state.showFromBottom {
            anchor = anchorView?.topAnchor ?? view.safeAreaLayoutGuide.bottomAnchor
            constraintWhenHidden = self.topAnchor.constraint(equalTo: anchor)
            constraintWhenShown = self.bottomAnchor.constraint(equalTo: anchor, constant: -presentationOffset)
        } else {
            anchor = anchorView?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor
            constraintWhenHidden = self.bottomAnchor.constraint(equalTo: anchor)
            constraintWhenShown = self.topAnchor.constraint(equalTo: anchor, constant: presentationOffset)
        }

        var constraints = [NSLayoutConstraint]()
        constraints.append(animated ? constraintWhenHidden : constraintWhenShown)
        constraints.append(self.centerXAnchor.constraint(equalTo: view.centerXAnchor))

        let horizontalPadding = -2 * notification.tokenSet[.presentationOffset].float
        let widthAnchor = self.widthAnchor
        let viewWidthAnchor = view.widthAnchor
        if isFlexibleWidthToast {
            constraints.append(widthAnchor.constraint(lessThanOrEqualTo: viewWidthAnchor, constant: horizontalPadding))
        } else {
            let isHalfLength = state.style.isToast && traitCollection.horizontalSizeClass == .regular
            if isHalfLength {
                constraints.append(widthAnchor.constraint(equalTo: viewWidthAnchor, multiplier: 0.5))
            } else {
                constraints.append(widthAnchor.constraint(equalTo: viewWidthAnchor, constant: horizontalPadding))
            }
        }
        NSLayoutConstraint.activate(constraints)

        if style.isToast {
            MSFNotification.currentToast = self
        }

        let completionForShow = { (_: Bool) in
            UIAccessibility.post(notification: .layoutChanged, argument: self)
            completion?(self)
        }

        self.alpha = 0
        if animated {
            view.layoutIfNeeded()
            UIView.animate(withDuration: style.animationDurationForShow,
                           delay: 0,
                           usingSpringWithDamping: style.animationDampingRatio,
                           initialSpringVelocity: 0,
                           animations: {
                self.constraintWhenHidden.isActive = false
                self.constraintWhenShown.isActive = true
                self.alpha = 1
                view.layoutIfNeeded()
            }, completion: completionForShow)
        } else {
            completionForShow(true)
            self.alpha = 1
        }
    }

    /// `hide` is used to dismiss the presented view:
    /// hide with optional animation and remove from the container.
    /// - Parameters:
    ///   - delay: The delay used for the start of dismissal. Default is 0.
    ///   - animated: Indicates whether to use animation during dismissal or not.
    ///   - completion: The closure to be called after dismissal is completed.
    @objc public func hide(after delay: TimeInterval = 0,
                           animated: Bool = true,
                           completion: (() -> Void)? = nil) {
        guard self.window != nil && constraintWhenHidden != nil else {
            return
        }

        guard delay == 0 else {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.hide(completion: completion)
            }
            return
        }

        if let completion = completion {
            completionsForHide.append(completion)
        }
        let completionForHide = {
            self.removeFromSuperview()
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
                UIView.animate(withDuration: notification.state.style.animationDurationForHide, animations: {
                    self.constraintWhenShown.isActive = false
                    self.constraintWhenHidden.isActive = true
                    self.alpha = 0
                    self.superview?.layoutIfNeeded()
                }, completion: { _ in
                    self.isHiding = false
                    completionForHide()
                })
            }
        } else {
            self.alpha = 0
            completionForHide()
        }
    }

    @objc public static var allowsMultipleToasts: Bool = false
    var isFlexibleWidthToast: Bool

    // MARK: - Private variables
    private static var currentToast: MSFNotification? {
        didSet {
            if allowsMultipleToasts {
                currentToast = nil
            }
        }
    }

    private var completionsForHide: [() -> Void] = []
    private var constraintWhenHidden: NSLayoutConstraint!
    private var constraintWhenShown: NSLayoutConstraint!
    private var notification: FluentNotification!
    private var isHiding: Bool = false
}
