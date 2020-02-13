//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

extension UIView {
    var left: CGFloat {
        get { return frame.minX }
        set { frame.origin.x = newValue }
    }
    var right: CGFloat {
        get { return frame.maxX }
        set { frame.origin.x = newValue - width }
    }
    var top: CGFloat {
        get { return frame.minY }
        set { frame.origin.y = newValue }
    }
    var bottom: CGFloat {
        get { return frame.maxY }
        set { frame.origin.y = newValue - height }
    }
    var width: CGFloat {
        get { return frame.width }
        set { frame.size.width = newValue }
    }
    var height: CGFloat {
        get { return frame.height }
        set { frame.size.height = newValue }
    }

    var directionalSafeAreaInsets: NSDirectionalEdgeInsets {
        let insets = safeAreaInsets
        let isRTL = effectiveUserInterfaceLayoutDirection == .rightToLeft
        return NSDirectionalEdgeInsets(
            top: insets.top,
            leading: isRTL ? insets.right : insets.left,
            bottom: insets.bottom,
            trailing: isRTL ? insets.left : insets.right
        )
    }

    private var contentWidth: CGFloat {
        return (self as? UIScrollView)?.contentSize.width ?? bounds.width
    }

    @objc func fitIntoSuperview(usingConstraints: Bool = false, usingLeadingTrailing: Bool = true, margins: UIEdgeInsets = .zero, autoWidth: Bool = false, autoHeight: Bool = false) {
        guard let superview = superview else {
            return
        }
        if usingConstraints {
            translatesAutoresizingMaskIntoConstraints = false
            if usingLeadingTrailing {
                leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: margins.left).isActive = true
            } else {
                leftAnchor.constraint(equalTo: superview.leftAnchor, constant: margins.left).isActive = true
            }
            if autoWidth {
                if usingLeadingTrailing {
                    trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -margins.right).isActive = true
                } else {
                    rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -margins.right).isActive = true
                }
            } else {
                widthAnchor.constraint(equalTo: superview.widthAnchor, constant: -(margins.left + margins.right)).isActive = true
            }
            topAnchor.constraint(equalTo: superview.topAnchor, constant: margins.top).isActive = true
            if autoHeight {
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -margins.bottom).isActive = true
            } else {
                heightAnchor.constraint(equalTo: superview.heightAnchor, constant: -(margins.top + margins.bottom)).isActive = true
            }
        } else {
            translatesAutoresizingMaskIntoConstraints = true
            frame = superview.bounds.inset(by: margins)
            autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }

    @objc func fitIntoSuperview() {
        fitIntoSuperview(usingConstraints: false, usingLeadingTrailing: true, margins: .zero, autoWidth: false, autoHeight: false)
    }

    func layer(withRoundedCorners corners: UIRectCorner, radius: CGFloat) -> CALayer {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        ).cgPath
        return layer
    }

    func centerInSuperview(horizontally: Bool = true, vertically: Bool = true) {
        guard let superview = superview else {
            assertionFailure("View must have a superview")
            return
        }

        if horizontally {
            left = UIScreen.main.roundDownToDevicePixels(0.5 * (superview.width - width))
        }

        if vertically {
            top = UIScreen.main.roundDownToDevicePixels(0.5 * (superview.height - height))
        }
    }

    func findSuperview(of aClass: AnyClass) -> UIView? {
        guard let superview = superview else {
            return nil
        }

        if superview.isKind(of: aClass) {
            return superview
        }

        return superview.findSuperview(of: aClass)
    }

    func findContainingViewController() -> UIViewController? {
        if let nextResponder = next as? UIViewController {
            return nextResponder
        }

        if let nextResponder = next as? UIView {
            return nextResponder.findContainingViewController()
        }

        return nil
    }

    func flipSubviewsForRTL() {
        if effectiveUserInterfaceLayoutDirection == .rightToLeft {
            subviews.forEach { $0.flipForRTL() }
        }
    }

    func flipForRTL() {
        frame = superview?.flipRectForRTL(frame) ?? frame
    }

    func flipRectForRTL(_ rect: CGRect) -> CGRect {
        var newRect = rect
        if effectiveUserInterfaceLayoutDirection == .rightToLeft {
            newRect.origin.x = contentWidth - rect.origin.x - rect.width
        }
        return newRect
    }

    /// Removes all subviews from the caller
    func removeAllSubviews() {
        subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
    }
}

// MARK: - Show/Hide safety methods

// UIView.isHidden has a bug where a series of repeated calls with the same parameter can "glitch" the view into a permanent shown/hidden state
// i.e. repeatedly trying to hide a UIView that is already in the hidden state
// by adding a check to the isHidden property prior to setting, we avoid such problematic scenarios
extension UIView {
    /// Sets the isHidden property to false, if the UIView is already hidden
    func safelyShow() {
        guard self.isHidden == true else {
            return
        }
        self.isHidden = false
    }

    /// Sets the isHidden property to true, if the UIView is already showing
    func safelyHide() {
        guard self.isHidden == false else {
            return
        }
        self.isHidden = true
    }
}

// MARK: - Animatable Show/Hide

extension UIView {
    /// isHidden is not an animatable property
    /// this method uses the alpha property, which is animatable
    ///
    /// - Parameter duration: duration of the show animation
    func animatedShow(duration: Double) {
        self.animatedShow(duration: duration, completion: nil)
    }

    /// isHidden is not an animatable property
    /// this method uses the alpha property, which is animatable
    ///
    /// - Parameter duration: duration of the hide animation
    func animatedHide(duration: Double) {
        animatedHide(duration: duration, completion: nil)
    }

    func animatedShow(duration: Double, completion: (() -> Void)?) {
        self.alpha = 0.0
        self.safelyShow()
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        }, completion: { (_) in
            completion?()
        })
    }

    func animatedHide(duration: Double, completion: (() -> Void)?) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        }, completion: { (_) in
            self.safelyHide()
            completion?()
        })
    }
}

// MARK: - NSLayoutConstraint and Autolayout Convenience Methods

extension UIView {
    //Uses autolayout to constrain the provided view as a matching subview of the receiver
    func contain(view: UIView) {
        NSLayoutConstraint.contain(view: view, in: self, withInsets: .zero, respectingSafeAreaInsets: false)
    }

    //Uses autolayout to constrain the provided view as a matching subview of the receiver, with insets
    func contain(view: UIView, withInsets insets: UIEdgeInsets) {
        NSLayoutConstraint.contain(view: view, in: self, withInsets: insets, respectingSafeAreaInsets: false)
    }

    //Uses autolayout to constrain the provided view as a matching subview of the receiver, with insets and optionally respecting the safe area insets on iOS 11.0+
    func contain(view: UIView, withInsets insets: UIEdgeInsets, respectingSafeAreaInsets respectsSafeAreaInsets: Bool) {
        NSLayoutConstraint.contain(view: view, in: self, withInsets: insets, respectingSafeAreaInsets: respectsSafeAreaInsets)
    }

    //Uses autolayout to constrain the provided view at the center of the receiver
    func center(view: UIView) {
        NSLayoutConstraint.center(view: view, in: self)
    }
}
