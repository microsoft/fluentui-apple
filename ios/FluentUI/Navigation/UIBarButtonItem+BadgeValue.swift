//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc public extension UIBarButtonItem {
    private struct AssociatedKeys {
        static var badgeValue: String = "badgeValue"
        static var accessibilityLabelFormatString: String = "accessibilityLabelFormatString"
    }

    static let badgeValueDidChangeNotification = NSNotification.Name(rawValue: "UIBarButtonItemBadgeValueDidChangeNotification")

    /// The badge value will be displayed in a red oval above the UIBarButtonItem.
    /// Set the badge value to nil to hide the red oval.
    @objc var badgeValue: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.badgeValue) as? String ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.badgeValue, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            NotificationCenter.default.post(name: UIBarButtonItem.badgeValueDidChangeNotification, object: self)
        }
    }

    /// Convenience method to set the badge value to a number.
    /// If the number is zero, the badge value will be hidden.
    @objc func setBadgeNumber(_ number: UInt) {
        if number > 0 {
            badgeValue = NumberFormatter.localizedString(from: NSNumber(value: number), number: .none)
        } else {
            badgeValue = nil
        }
    }

    @objc var accessibilityLabelFormatString: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.accessibilityLabelFormatString) as? String ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.accessibilityLabelFormatString, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
