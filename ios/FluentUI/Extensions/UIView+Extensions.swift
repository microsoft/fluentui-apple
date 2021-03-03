//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

extension UIView {
    func fitIntoSuperview(usingConstraints: Bool = false, usingLeadingTrailing: Bool = true, margins: UIEdgeInsets = .zero, autoWidth: Bool = false, autoHeight: Bool = false) {
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

    func fitIntoSuperview() {
        fitIntoSuperview(usingConstraints: false, usingLeadingTrailing: true, margins: .zero, autoWidth: false, autoHeight: false)
    }

    func centerInSuperview(horizontally: Bool = true, vertically: Bool = true) {
        guard let superview = superview else {
            assertionFailure("View must have a superview")
            return
        }

        if horizontally {
            frame.origin.x = UIScreen.main.roundDownToDevicePixels(0.5 * (superview.frame.width - frame.width))
        }

        if vertically {
            frame.origin.y = UIScreen.main.roundDownToDevicePixels(0.5 * (superview.frame.height - frame.height))
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
            let contentWidth = (self as? UIScrollView)?.contentSize.width ?? bounds.width
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

// MARK: - NSLayoutConstraint and Autolayout Convenience Methods

extension UIView {
    //Uses autolayout to constrain the provided view as a matching subview of the receiver, with insets and optionally respecting the safe area insets on iOS 11.0+
    func contain(view: UIView, withInsets insets: UIEdgeInsets = .zero, respectingSafeAreaInsets respectsSafeAreaInsets: Bool = false) {
        NSLayoutConstraint.contain(view: view, in: self, withInsets: insets, respectingSafeAreaInsets: respectsSafeAreaInsets)
    }
}
