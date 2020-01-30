//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objcMembers
public final class MSBarButtonItems: NSObject {
    public static func confirm(target: Any?, action: Selector?) -> UIBarButtonItem {
        let image = UIImage.staticImageNamed(OfficeUIFabricFramework.usesFluentIcons ? "checkmark-24x24" : "checkmark-blue-25x25")?.withRenderingMode(.alwaysTemplate)
        let landscapeImage = UIImage.staticImageNamed(OfficeUIFabricFramework.usesFluentIcons ? "checkmark-thin-20x20" : "checkmark-blue-thin-20x20")?.withRenderingMode(.alwaysTemplate)

        let button = UIBarButtonItem(image: image, landscapeImagePhone: landscapeImage, style: .plain, target: target, action: action)
        button.accessibilityLabel = "Accessibility.Done.Label".localized
        button.tintColor = MSColors.BarButtonItem.primary
        return button
    }

    private override init() {
        super.init()
    }
}
