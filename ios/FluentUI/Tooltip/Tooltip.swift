//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: Tooltip
// Tooltip Hierarchy:
//
// TooltipViewController (handles view-changing events like device rotation, multi-windows, content size changes, etc.)
// |--TooltipView (placed based on anchor view location and passed in origin offset, sized based on contents)
// |  |--backgroundView (rectangular view that holds tooltip contents)
// |    |--title
// |    |--message
// |  |--arrowImageView (tip of tooltip view)
// |--|--layer (ambient and key shadows added as sublayers)
/// A styled tooltip that is presented anchored to a view.
@objc(MSFTooltip)
open class Tooltip: NSObject, TokenizedControlInternal {

    /// Displays a tooltip based on the current settings, pointing to the supplied anchorView.
    /// If another tooltip view is already showing, it will be dismissed and the new tooltip will be shown.
    ///
    /// - Parameters:
    ///   - message: The text to be displayed on the new tooltip view.
    ///   - title: The optional bolded text to be displayed above the message on the new tooltip view.
    ///   - anchorView: The view to point to with the new tooltip's arrow.
    ///   - hostViewController: The view controller that should host the Tooltip. If not set, the default is the window's root view controller.
    ///   - preferredArrowDirection: The preferrred direction for the tooltip's arrow. Only the arrow's axis is guaranteed; the direction may be changed based on available space between the anchorView and the screen's margins. Defaults to down.
    ///   - offset: An offset from the tooltip's default position.
    ///   - dismissMode: The mode of tooltip dismissal. Defaults to tapping anywhere.
    ///   - onTap: An optional closure used to do work after the user taps
    @objc public func show(with message: String,
                           title: String?,
                           for anchorView: UIView,
                           in hostViewController: UIViewController? = nil,
                           preferredArrowDirection: ArrowDirection = .down,
                           offset: CGPoint = CGPoint(x: 0, y: 0),
                           dismissOn dismissMode: DismissMode = .tapAnywhere,
                           onTap: (() -> Void)? = nil) {
        hide()

        guard let window = anchorView.window else {
            preconditionFailure("Can't find anchorView's window")
        }

        tooltipViewController = TooltipViewController(anchorView: anchorView,
                                                      hostViewController: hostViewController,
                                                      message: message,
                                                      title: title,
                                                      textAlignment: textAlignment,
                                                      preferredArrowDirection: preferredArrowDirection,
                                                      offset: offset,
                                                      arrowMargin: tokenSet[.backgroundCornerRadius].float,
                                                      tokenSet: tokenSet)
        self.anchorView = anchorView
        guard let tooltipViewController = tooltipViewController,
              let tooltipView = tooltipViewController.view,
              let hostVC = hostViewController ?? window.rootViewController,
              let hostView = hostVC.view else {
            return
        }

        // Connect tokenSet
        tokenSet.registerOnUpdate(for: tooltipView) { [weak self] in
            self?.tooltipViewController?.updateAppearance()
        }

        hostVC.addChild(tooltipViewController)
        self.onTap = onTap
        self.dismissMode = UIAccessibility.isVoiceOverRunning ? .tapOnTooltip : dismissMode
        let gestureView = TouchForwardingView(frame: window.bounds)
        self.gestureView = gestureView
        switch self.dismissMode {
        case .tapAnywhere:
            hostView.addSubview(tooltipView)
            hostView.addSubview(gestureView)
            gestureView.onTouches = { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.handleTapGesture()
            }
        case .tapOnTooltip, .tapOnTooltipOrAnchor:
            hostView.addSubview(gestureView)
            hostView.addSubview(tooltipView)
            gestureView.forwardsTouches = false
            tooltipView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
            if self.dismissMode == .tapOnTooltipOrAnchor {
                gestureView.passthroughView = anchorView
                gestureView.onPassthroughViewTouches = { [weak self] _ in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.handleTapGesture()
                }
            }
        }
        tooltipViewController.didMove(toParent: hostVC)

        // Animate tooltip
        tooltipView.alpha = 0.0
        UIView.animate(withDuration: Constants.animationDuration, delay: 0.0, options: [.curveEaseOut], animations: {
            tooltipView.alpha = 1.0
        }, completion: { _ in
            UIAccessibility.post(notification: .screenChanged, argument: tooltipView)
        })

        isShowing = true
    }

    /// Displays a tooltip based on the current settings, pointing to the supplied anchorView.
    /// If another tooltip view is already showing, it will be dismissed and the new tooltip will be shown.
    ///
    /// - Parameters:
    ///   - message: The text to be displayed on the new tooltip view.
    ///   - title: The optional bolded text to be displayed above the message on the new tooltip view.
    ///   - anchorView: The view to point to with the new tooltip's arrow.
    ///   - preferredArrowDirection: The preferrred direction for the tooltip's arrow. Only the arrow's axis is guaranteed; the direction may be changed based on available space between the anchorView and the screen's margins. Defaults to down.
    ///   - offset: An offset from the tooltip's default position.
    ///   - dismissMode: The mode of tooltip dismissal. Defaults to tapping anywhere.
    ///   - onTap: An optional closure used to do work after the user taps
    @objc public func show(with message: String,
                           title: String?,
                           for anchorView: UIView,
                           preferredArrowDirection: ArrowDirection = .down,
                           offset: CGPoint = CGPoint(x: 0, y: 0),
                           dismissOn dismissMode: DismissMode = .tapAnywhere,
                           onTap: (() -> Void)? = nil) {
        show(with: message,
             title: title,
             for: anchorView,
             in: nil,
             preferredArrowDirection: preferredArrowDirection,
             offset: offset,
             dismissOn: dismissMode,
             onTap: onTap)
    }

    /// Displays a tooltip based on the current settings, pointing to the supplied anchorView.
    /// If another tooltip view is already showing, it will be dismissed and the new tooltip will be shown.
    ///
    /// - Parameters:
    ///   - message: The text to be displayed on the new tooltip view.
    ///   - anchorView: The view to point to with the new tooltip's arrow.
    ///   - preferredArrowDirection: The preferrred direction for the tooltip's arrow. Only the arrow's axis is guaranteed; the direction may be changed based on available space between the anchorView and the screen's margins. Defaults to down.
    ///   - offset: An offset from the tooltip's default position.
    ///   - dismissMode: The mode of tooltip dismissal. Defaults to tapping anywhere.
    ///   - onTap: An optional closure used to do work after the user taps
    @objc public func show(with message: String,
                           for anchorView: UIView,
                           preferredArrowDirection: ArrowDirection = .down,
                           offset: CGPoint = CGPoint(x: 0, y: 0),
                           dismissOn dismissMode: DismissMode = .tapAnywhere,
                           onTap: (() -> Void)? = nil) {
        show(with: message,
             title: nil,
             for: anchorView,
             in: nil,
             preferredArrowDirection: preferredArrowDirection,
             offset: offset,
             dismissOn: dismissMode,
             onTap: onTap)
    }

    /// Displays a tooltip based on the current settings, pointing to the supplied anchorView.
    /// If another tooltip view is already showing, it will be dismissed and the new tooltip will be shown.
    ///
    /// - Parameters:
    ///   - message: The text to be displayed on the new tooltip view.
    ///   - anchorView: The view to point to with the new tooltip's arrow.
    ///   - preferredArrowDirection: The preferrred direction for the tooltip's arrow. Only the arrow's axis is guaranteed; the direction may be changed based on available space between the anchorView and the screen's margins. Defaults to down.
    ///   - offset: An offset from the tooltip's default position.
    ///   - screenMargins: The margins from the window's safe area insets used for laying out the tooltip. Defaults to 16.0 pts on all sides.
    ///   - dismissMode: The mode of tooltip dismissal. Defaults to tapping anywhere.
    ///   - onTap: An optional closure used to do work after the user taps
    @available(*, deprecated, renamed: "show(with:for:preferredArrowDirection:offset:dismissOn:onTap:)", message: "Screen margins value has been tokenized. Passing in that param no longer has any effect and it will be removed in a future update.")
    @objc public func show(with message: String,
                           for anchorView: UIView,
                           preferredArrowDirection: ArrowDirection = .down,
                           offset: CGPoint = CGPoint(x: 0, y: 0),
                           screenMargins: UIEdgeInsets = defaultScreenMargins,
                           dismissOn dismissMode: DismissMode = .tapAnywhere,
                           onTap: (() -> Void)? = nil) {
        show(with: message,
             title: nil,
             for: anchorView,
             preferredArrowDirection: preferredArrowDirection,
             offset: offset,
             dismissOn: dismissMode,
             onTap: onTap)
    }

    /// Hides the currently shown tooltip.
    @objc public func hide() {
        gestureView?.removeFromSuperview()
        gestureView = nil

        guard let tooltipView = tooltipViewController?.view else {
            return
        }

        tooltipViewController?.willMove(toParent: nil)

        // Animate tooltip
        UIView.animate(withDuration: Constants.animationDuration, delay: 0.0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
            tooltipView.alpha = 0.0
        }, completion: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            tooltipView.removeFromSuperview()
            UIAccessibility.post(notification: .screenChanged, argument: strongSelf.anchorView)
        })

        tooltipViewController?.removeFromParent()
        tooltipViewController = nil

        tokenSet.deregisterOnUpdate()

        onTap = nil

        isShowing = false
    }

    required public init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc(MSFTooltipArrowDirection)
    public enum ArrowDirection: Int {
        case up, down, left, right

        var isVertical: Bool {
            switch self {
            case .up, .down:
                return true
            case .left, .right:
                return false
            }
        }

        var opposite: ArrowDirection {
            switch self {
            case .up:
                return .down
            case .down:
                return .up
            case .left:
                return .right
            case .right:
                return .left
            }
        }
    }

    @objc(MSFTooltipDismissMode)
    public enum DismissMode: Int {
        case tapAnywhere
        case tapOnTooltip
        case tapOnTooltipOrAnchor
    }

    @available(*, deprecated, message: "Screen margins value has been tokenized. Setting this var no longer has any effect and it will be removed in a future update.")
    @objc public static let defaultScreenMargins = UIEdgeInsets(top: Constants.defaultMargin, left: Constants.defaultMargin, bottom: Constants.defaultMargin, right: Constants.defaultMargin)

    @objc public static let shared = Tooltip()

    /// The alignment of the text in the tooltip. Defaults to natural alignment (left for LTR languages, right for RTL languages).
    @objc public var textAlignment: NSTextAlignment = .natural
    /// Whether a tooltip is currently showing.
    @objc public private(set) var isShowing: Bool = false

    // MARK: - TokenizedControl
    public typealias TokenSetKeyType = TooltipTokenSet.Tokens
    public var tokenSet: TooltipTokenSet = .init()
    var fluentTheme: FluentTheme {
        // Use anchor view to get theme since tooltip view will most likely be nil
        guard let anchorView = anchorView else {
            return FluentTheme.shared
        }
        return anchorView.fluentTheme
    }

    private override init() {
        super.init()
    }

    @objc private func handleTapGesture() {
        onTap?()
        hide()
    }

    private func updateAppearance() {
        tooltipViewController?.updateAppearance()
    }

    private struct Constants {
        static let animationDuration: TimeInterval = 0.1
        static let defaultMargin: CGFloat = 16.0
    }

    private var tooltipViewController: TooltipViewController?
    private weak var anchorView: UIView?
    private var onTap: (() -> Void)?
    private var gestureView: UIView?
    private var dismissMode: DismissMode = .tapAnywhere
}
