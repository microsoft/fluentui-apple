//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc public extension UIBarButtonItem {
	private struct AssociatedKeys {
		static var redDotValue: UInt8 = 0
	}

	static let redDotValueDidChangeNotification = NSNotification.Name(rawValue: "UIBarButtonItemRedDotValueDidChangeNotification")

	/// This Bool indicate if we need to display red dot on top right cornet of button.
	/// Red dot will be override by badge value, in case user set for badge value and red dot, it will give preference to badge value.
	@objc var shouldShowRedDot: Bool {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.redDotValue) as? Bool ?? false
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.redDotValue, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			NotificationCenter.default.post(name: UIBarButtonItem.redDotValueDidChangeNotification, object: self)
		}
	}

	/// Use this method on bar button item's instance to set the red to visibility value.
	/// - Parameters:
	///   - shouldShowRedDot: Bool value indicating if we need to show red dot OR not.
	@objc func showRedDot(_ shouldShowRedDot: Bool) {
		self.shouldShowRedDot = shouldShowRedDot
	}
}
