//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import UIKit

/**
 AccessibleViewDelegate is used to pass responsibility for built in accessibility methods from a view to its parent view controller.
 Each AccessibleViewDelegate method is meant to be called in the native accessibility method of the view that has the same name as AccessibleViewDelegate method prefix (eg. accessibilityActivate -> accessibilityActivateForAccessibleView)
 All AccessibleViewDelegate method are optionals
 */

@objc public protocol AccessibleViewDelegate {
    @objc optional func accessibilityValueForAccessibleView(_ accessibleView: UIView) -> String?
    @objc optional func accessibilityLabelForAccessibleView(_ accessibleView: UIView) -> String?
    @objc optional func accessibilityActivateForAccessibleView(_ accessibleView: UIView) -> Bool
    @objc optional func accessibilityIncrementForAccessibleView(_ accessibleView: UIView)
    @objc optional func accessibilityDecrementForAccessibleView(_ accessibleView: UIView)
    @objc optional func accessibilityPerformMagicTapForAccessibleView(_ accessibleView: UIView) -> Bool
    @objc optional func accessibilityElementsForAccessibleView(_ accessibleView: UIView) -> [AnyObject]?
}

@objc public protocol AccessibleTableViewDelegate: AccessibleViewDelegate {
    @objc optional func accessibilityValueForRowAtIndexPath(_ indexPath: IndexPath, forTableView: UITableView) -> String?
}
