//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSTooltip

/// A styled tooltip that is presented anchored to a view.
open class MSTooltip: NSObject {
    @objc(MSTooltipArrowDirection)
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

    @objc(MSTooltipDismissMode)
    public enum DismissMode: Int {
        case tapAnywhere
        case tapOnTooltip
        case tapOnTooltipOrAnchor
    }

    private struct Constants {
        static let animationDuration: TimeInterval = 0.1
        static let defaultMargin: CGFloat = 16.0
    }

    @objc public static let defaultScreenMargins = UIEdgeInsets(top: Constants.defaultMargin, left: Constants.defaultMargin, bottom: Constants.defaultMargin, right: Constants.defaultMargin)

    @objc public static let shared = MSTooltip()

    /// The alignment of the text in the tooltip. Defaults to natural alignment (left for LTR languages, right for RTL languages).
    @objc public var textAlignment: NSTextAlignment = .natural
    /// Whether a tooltip is currently showing.
    @objc public private(set) var isShowing: Bool = false

    private var tooltipView: MSTooltipView?
    private var onTap: (() -> Void)?
    private var gestureView: UIView?
    private var dismissMode: DismissMode = .tapAnywhere

    private override init() { }

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
    @objc public func show(with message: String, for anchorView: UIView, preferredArrowDirection: ArrowDirection = .down, offset: CGPoint = CGPoint(x: 0, y: 0), screenMargins: UIEdgeInsets = defaultScreenMargins, dismissOn dismissMode: DismissMode = .tapAnywhere, onTap: (() -> Void)? = nil) {
        hide()

        guard let window = anchorView.window else {
            fatalError("Can't find anchorView's window")
        }

        let boundingRect = window.bounds.inset(by: window.safeAreaInsets).inset(by: screenMargins)
        let positionController = MSTooltipPositionController(anchorView: anchorView, message: message, boundingRect: boundingRect, preferredArrowDirection: preferredArrowDirection, offset: offset, arrowMargin: MSTooltipView.backgroundCornerRadius, arrowWidth: MSTooltipView.arrowSize.width)
        let tooltipView = MSTooltipView(message: message, textAlignment: textAlignment, positionController: positionController)

        self.tooltipView = tooltipView
        tooltipView.accessibilityViewIsModal = true

        self.onTap = onTap

        self.dismissMode = UIAccessibility.isVoiceOverRunning ? .tapOnTooltip : dismissMode

        let gestureView = MSTouchForwardingView(frame: window.bounds)
        self.gestureView = gestureView
        switch self.dismissMode {
        case .tapAnywhere:
            window.addSubview(tooltipView)
            window.addSubview(gestureView)
            gestureView.onTouches = { _ in
                self.handleTapGesture()
            }
        case .tapOnTooltip, .tapOnTooltipOrAnchor:
            window.addSubview(gestureView)
            window.addSubview(tooltipView)
            gestureView.forwardsTouches = false
            tooltipView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
            if self.dismissMode == .tapOnTooltipOrAnchor {
                gestureView.passthroughView = anchorView
                gestureView.onPassthroughViewTouches = { _ in
                    self.handleTapGesture()
                }
            }
        }

        // Layout tooltip
        tooltipView.frame = positionController.tooltipRect

        // Animate tooltip
        tooltipView.alpha = 0.0
        UIView.animate(withDuration: Constants.animationDuration, delay: 0.0, options: [.curveEaseOut], animations: {
            tooltipView.alpha = 1.0
        }, completion: { _ in
            UIAccessibility.post(notification: .screenChanged, argument: tooltipView)
        })

        isShowing = true

        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    /// Hides the currently shown tooltip.
    @objc public func hide() {
        gestureView?.removeFromSuperview()
        gestureView = nil

        guard let tooltipView = tooltipView else {
            return
        }

        // Animate tooltip
        UIView.animate(withDuration: Constants.animationDuration, delay: 0.0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
            tooltipView.alpha = 0.0
        }, completion: { _ in
            tooltipView.removeFromSuperview()
            UIAccessibility.post(notification: .screenChanged, argument: tooltipView.positionController.anchorView)
        })

        self.tooltipView = nil

        onTap = nil

        isShowing = false
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    @objc private func handleTapGesture() {
        onTap?()
        hide()
    }

    @objc private func orientationChanged(_ notification: Notification) {
        hide()
    }
}
