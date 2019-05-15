//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

public extension UIView {
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

    var safeAreaInsetsIfAvailable: UIEdgeInsets {
        if #available(iOS 11, *) {
            return safeAreaInsets
        } else {
            return .zero
        }
    }

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

    func flipSubviewsForRTL() {
        if effectiveUserInterfaceLayoutDirection == .rightToLeft {
            subviews.forEach { $0.flipForRTL() }
        }
    }

    func flipForRTL() {
        if effectiveUserInterfaceLayoutDirection == .rightToLeft, let superview = superview {
            left = superview.bounds.width - left - width
        }
    }
}
