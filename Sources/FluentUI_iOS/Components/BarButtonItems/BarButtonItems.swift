//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public final class BarButtonItems: NSObject {

    /// The accessibility label that should be applied for the done bar button.
    /// A temporary change so that consumers who use SwiftUI for a toolbar can avoid duplicated resources until support of a swiftUI control is available.
    @objc public static let doneButtonAccessibilityLabel: String = "Accessibility.Done.Label".localized

    /// When adding this barButtonItem to the view, tint it with appropriate app color UIColor(light: Colors.primary(for: window), dark: Colors.textDominant)
    @objc static func confirm(target: Any?, action: Selector?) -> UIBarButtonItem {
        let image = UIImage.staticImageNamed("checkmark-24x24")
        let landscapeImage = UIImage.staticImageNamed("checkmark-thin-20x20")

        let button = UIBarButtonItem(image: image, landscapeImagePhone: landscapeImage, style: .plain, target: target, action: action)
        button.accessibilityLabel = doneButtonAccessibilityLabel
        return button
    }

    private override init() {
        super.init()
    }
}
