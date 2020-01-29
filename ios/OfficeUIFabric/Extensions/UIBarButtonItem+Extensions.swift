//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

extension UIBarButtonItem {
    private struct Constants {
        static let horizontalPadding: CGFloat = 10
    }

    // TODO: reenable customview usage
    /// Constructs a UIButton instance from Self
    /// Used to construct custom NavigationBars/Buttons using NavigationItems
    /// UIBarButtonItem is not a UIView subclass, and is converted by UINavigationBar internally
    ///
    /// - Returns: a button with the relevant properties of the UIBarButtonItem
    func createButton() -> UIButton {
        let button = UIButton(type: .system)

        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: Constants.horizontalPadding, bottom: 0, right: Constants.horizontalPadding)
        button.tag = tag
        button.tintColor = tintColor
        button.titleLabel?.font = titleTextAttributes(for: .normal)?[.font] as? UIFont

        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setTitle(title, for: .normal)

        if let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }

        button.accessibilityIdentifier = accessibilityIdentifier
        button.accessibilityLabel = accessibilityLabel
        button.accessibilityHint = accessibilityHint

        return button
    }
}
