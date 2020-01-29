//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc public extension UIColor {
    private struct AssociatedKeys {
        static var light: String = "light"
        static var lightHighContrast: String = "lightHighContrast"
    }

    /// Returns self on iOS 13 and later. For older iOS versions returns self for Regular Contrast mode or a specific color for Increased Contrast mode if it's defined either for this color or for one of its ancestors.
    var current: UIColor {
        if #available(iOS 13, *) {
            return self
        }
        if !UIAccessibility.isDarkerSystemColorsEnabled {
            return self
        }
        return lightHighContrast ?? light?.current ?? self
    }

    private var light: UIColor? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.light) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.light, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    private var lightHighContrast: UIColor? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.lightHighContrast) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.lightHighContrast, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    convenience init(light: UIColor, lightHighContrast: UIColor? = nil, lightElevated: UIColor? = nil, lightElevatedHighContrast: UIColor? = nil, dark: UIColor? = nil, darkHighContrast: UIColor? = nil, darkElevated: UIColor? = nil, darkElevatedHighContrast: UIColor? = nil) {
        // The following code requires Xcode 11, but there is no explicit condition for that, so using implicit check for Swift version
        #if swift(>=5.1)
        if #available(iOS 13, *) {
            self.init { traits -> UIColor in
                let getColorForContrast = { (default: UIColor?, highContrast: UIColor?) -> UIColor? in
                    if traits.accessibilityContrast == .high, let color = highContrast {
                        return color
                    }
                    return `default`
                }

                let getColor = { (default: UIColor?, highContrast: UIColor?, elevated: UIColor?, elevatedHighContrast: UIColor?) -> UIColor? in
                    if traits.userInterfaceLevel == .elevated,
                        let color = getColorForContrast(elevated, elevatedHighContrast) {
                        return color
                    }
                    return getColorForContrast(`default`, highContrast)
                }

                if traits.userInterfaceStyle == .dark,
                    let color = getColor(dark, darkHighContrast, darkElevated, darkElevatedHighContrast) {
                    return color
                }
                return getColor(light, lightHighContrast, lightElevated, lightElevatedHighContrast)!
            }
            return
        }
        #endif

        self.init(cgColor: light.cgColor)
        self.light = light
        if let lightHighContrast = lightHighContrast {
            self.lightHighContrast = lightHighContrast
        }
    }
}
