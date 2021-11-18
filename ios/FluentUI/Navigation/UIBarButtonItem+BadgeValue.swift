//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc public extension UIBarButtonItem {
    private struct AssociatedKeys {
        static var badgeValue: String = "badgeValue"
        static var badgeAccessibilityLabel: String = "badgeAccessibilityLabel"
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

    @objc internal var badgeAccessibilityLabel: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.badgeAccessibilityLabel) as? String ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.badgeAccessibilityLabel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// Use this method on bar button item's instance to set the badge value and badge accessibility label.
    /// Set the badge value to nil to hide the red oval.
    /// Complete badge accessibility label would be the concatenation of the badge value and badge accessibility label.
    /// Complete accessibility label for the item in the navigation bar would be item's accessibility label concatenated with the complete badge accessibility label.
    @objc func setBadgeValue(_ badgeValue: String?, badgeAccessibilityLabel: String?) {
        self.badgeAccessibilityLabel = (badgeValue ?? "").appending(badgeAccessibilityLabel ?? "")
        self.badgeValue = badgeValue
    }
}
