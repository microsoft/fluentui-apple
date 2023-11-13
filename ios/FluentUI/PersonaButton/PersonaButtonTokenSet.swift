//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Pre-defined sizes of the persona button
@objc public enum MSFPersonaButtonSize: Int, CaseIterable {
    case small
    case large

    var avatarSize: MSFAvatarSize {
        switch self {
        case .large:
            return .size72
        case .small:
            return .size56
        }
    }

    var shouldShowSubtitle: Bool {
        switch self {
        case .large:
            return true
        case .small:
            return false
        }
    }
}

/// Design token set for the `PersonaButton` control.
public class PersonaButtonTokenSet: ControlTokenSet<PersonaButtonTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// The background color for the `PersonaButton`.
        case backgroundColor

        /// The color to use for the control's primary label.
        case labelColor

        /// The `FontInfo` to use for the control's primary label.
        case labelFont

        /// The color to use for the control's secondary label.
        case sublabelColor

        /// The `FontInfo` to use for the control's secondary label.
        case sublabelFont
    }

    init(size: @escaping () -> MSFPersonaButtonSize) {
        self.size = size
        super.init { [size] token, theme in
            switch token {
            case .backgroundColor:
                return .uiColor { theme.color(.background1) }

            case .labelColor:
                return .uiColor { theme.color(.foreground1) }

            case .labelFont:
                return .uiFont {
                    switch size() {
                    case .small:
                        return theme.typography(.caption1)
                    case .large:
                        return theme.typography(.body2)
                    }
                }

            case .sublabelColor:
                return .uiColor { theme.color(.foreground3) }

            case .sublabelFont:
                return .uiFont { theme.typography(.caption1) }
            }
        }
    }

    /// `MSFPersonaButtonSize` enumeration value that will define pre-defined values for fonts and spacing.
    var size: () -> MSFPersonaButtonSize
}

// MARK: Constants

extension PersonaButtonTokenSet {
    /// How much space should be reserved to the left and right of the control's `Avatar`.
    static func horizontalAvatarPadding(_ size: MSFPersonaButtonSize) -> CGFloat {
        switch size {
        case .small:
            return GlobalTokens.spacing(.size160)
        case .large:
            return GlobalTokens.spacing(.size80)
        }
    }

    /// The amount of space between the control's `Avatar` and text labels.
    static func avatarInterspace(_ size: MSFPersonaButtonSize) -> CGFloat {
        switch size {
        case .small:
            return GlobalTokens.spacing(.size80)
        case .large:
            return GlobalTokens.spacing(.size120)
        }
    }

    /// How much space should be reserved to the left and right of the control's labels.
    static let horizontalTextPadding: CGFloat = GlobalTokens.spacing(.size20)

    /// How much padding to add above the `Avatar` and below the lowest text label.
    static let verticalPadding: CGFloat = GlobalTokens.spacing(.size80)
}
