//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public extension UIColor {
    @objc convenience init(light: UIColor, lightHighContrast: UIColor? = nil, lightElevated: UIColor? = nil, lightElevatedHighContrast: UIColor? = nil, dark: UIColor? = nil, darkHighContrast: UIColor? = nil, darkElevated: UIColor? = nil, darkElevatedHighContrast: UIColor? = nil) {
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
    }
}
