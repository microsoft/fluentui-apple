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

    static let badgePropertiesDidChangeNotification = NSNotification.Name(rawValue: "UIBarButtonItemBadgePropertiesDidChangeNotification")

    @objc internal var badgeValue: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.badgeValue) as? String ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.badgeValue, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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

    @objc func setBadgeValue(_ badgeValue: String?, badgeAccessibilityLabel: String?) {
        self.badgeValue = badgeValue
        self.badgeAccessibilityLabel = (badgeValue ?? "").appending(badgeAccessibilityLabel ?? "")
        NotificationCenter.default.post(name: UIBarButtonItem.badgePropertiesDidChangeNotification, object: self)
    }
}
