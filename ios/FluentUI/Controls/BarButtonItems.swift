//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@available(*, deprecated, renamed: "BarButtonItems")
public typealias MSBarButtonItems = BarButtonItems

public final class BarButtonItems: NSObject {
    @objc static func confirm(target: Any?, action: Selector?) -> UIBarButtonItem {
        let image = UIImage.staticImageNamed("checkmark-24x24")
        let landscapeImage = UIImage.staticImageNamed("checkmark-thin-20x20")

        let button = UIBarButtonItem(image: image, landscapeImagePhone: landscapeImage, style: .plain, target: target, action: action)
        button.accessibilityLabel = "Accessibility.Done.Label".localized
        button.tintColor = MSColors.BarButtonItem.primary
        return button
    }

    private override init() {
        super.init()
    }
}
