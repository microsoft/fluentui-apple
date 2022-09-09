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
            return .xxlarge
        case .small:
            return .xlarge
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

        /// The `DynamicColor` to use for the control's primary label.
        case labelColor

        /// The `FontInfo` to use for the control's primary label.
        case labelFont

        /// The `DynamicColor` to use for the control's secondary label.
        case sublabelColor

        /// The `FontInfo` to use for the control's secondary label.
        case sublabelFont
    }

    init(size: @escaping () -> MSFPersonaButtonSize) {
        self.size = size
        super.init { [size] token, theme in
            switch token {
            case .backgroundColor:
                return .dynamicColor { theme.aliasTokens.backgroundColors[.neutral1] }

            case .labelColor:
                return .dynamicColor { theme.aliasTokens.foregroundColors[.neutral1] }

            case .labelFont:
                return .fontInfo {
                    switch size() {
                    case .small:
                        return theme.aliasTokens.typography[.caption1]
                    case .large:
                        return theme.aliasTokens.typography[.body2]
                    }
                }

            case .sublabelColor:
                return .dynamicColor { theme.aliasTokens.foregroundColors[.neutral3] }

            case .sublabelFont:
                return .fontInfo { theme.aliasTokens.typography[.caption1] }
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
            return GlobalTokens.spacing(.medium)
        case .large:
            return GlobalTokens.spacing(.xSmall)
        }
    }

    /// The amount of space between the control's `Avatar` and text labels.
    static func avatarInterspace(_ size: MSFPersonaButtonSize) -> CGFloat {
        switch size {
        case .small:
            return GlobalTokens.spacing(.xSmall)
        case .large:
            return GlobalTokens.spacing(.small)
        }
    }

    /// How much space should be reserved to the left and right of the control's labels.
    static let horizontalTextPadding: CGFloat = GlobalTokens.spacing(.xxxSmall)

    /// How much padding to add above the `Avatar` and below the lowest text label.
    static let verticalPadding: CGFloat = GlobalTokens.spacing(.xSmall)
}
