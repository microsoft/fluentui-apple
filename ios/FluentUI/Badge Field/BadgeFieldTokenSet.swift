//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public enum BadgeFieldToken: Int, TokenSetKey {
    /// The background color of the BadgeField.
    case backgroundColor

    /// The color of the BadgeField's label.
    case labelColor

    /// The color of the BadgeField's placeholder.
    case placeholderColor

    /// The color of the BadgeField's text field.
    case textFieldColor

    /// The font of the BadgeField's label.
    case labelFont

    /// The font of the BadgeField's placeholder.
    case placeholderFont

    /// The font of the BadgeField's text field.
    case textFieldFont
}

/// Design token set for the `BadgeField` control.
public class BadgeFieldTokenSet: ControlTokenSet<BadgeFieldToken> {
    init() {
        super.init { token, theme in
            switch token {
            case .backgroundColor:
                return .uiColor { theme.color(.background1) }
            case .labelColor, .placeholderColor, .textFieldColor:
                return .uiColor { theme.color(.foreground2) }
            case .labelFont, .placeholderFont, .textFieldFont:
                return .uiFont { theme.typography(.body1) }
            }
        }
    }
}

// MARK: Constants
extension BadgeFieldTokenSet {
    static let badgeMarginHorizontal: CGFloat = 5
    static let badgeMarginVertical: CGFloat = 5
    static let labelMarginRight: CGFloat = 5
    static let textFieldMinWidth: CGFloat = 100
}
