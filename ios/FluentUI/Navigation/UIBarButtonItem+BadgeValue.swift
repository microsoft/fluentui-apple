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
    /// - Parameters:
    ///   - badgeValue: Value that will be displayed in a red oval above the bar button item. Set the badgeValue to nil to hide the red oval.
    ///   - badgeAccessibilityLabel: Accessibility label for the badge. If present, then the overall accessibility label will be item's accessibility label concatenated with the badge's accessibility label, else only the item's accessibility label.
    @objc func setBadgeValue(_ badgeValue: String?, badgeAccessibilityLabel: String?) {
        self.badgeAccessibilityLabel = badgeAccessibilityLabel
        self.badgeValue = badgeValue
    }
}
