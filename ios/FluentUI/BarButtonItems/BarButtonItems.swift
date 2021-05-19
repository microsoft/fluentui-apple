//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@available(*, deprecated, renamed: "BarButtonItems")
public typealias MSBarButtonItems = BarButtonItems

public final class BarButtonItems: NSObject {
    /// When adding this barButtonItem to the view, tint it with appropriate app color UIColor(light: Colors.primary(for: window), dark: Colors.textDominant)
    @objc public static func confirm(target: Any?, action: Selector?) -> UIBarButtonItem {
        let image = UIImage.staticImageNamed("checkmark-24x24")
        let landscapeImage = UIImage.staticImageNamed("checkmark-thin-20x20")

        let button = UIBarButtonItem(image: image, landscapeImagePhone: landscapeImage, style: .plain, target: target, action: action)
        button.accessibilityLabel = "Accessibility.Done.Label".localized
        return button
    }

    /// When adding this barButtonItem to the view, tint it with appropriate app color UIColor(light: Colors.primary(for: window), dark: Colors.textDominant)
    @objc public static func cancel(target: Any?, action: Selector?) -> UIBarButtonItem {
        let image = UIImage.staticImageNamed("dismiss-20x20")
        let landscapeImage = UIImage.staticImageNamed("dismiss-36x36")

        let button = UIBarButtonItem(image: image, landscapeImagePhone: landscapeImage, style: .plain, target: target, action: action)
        button.accessibilityLabel = "Accessibility.Dismiss.Label".localized
        return button
    }

    private override init() {
        super.init()
    }
}
