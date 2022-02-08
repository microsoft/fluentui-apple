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

/// Representation of design tokens to persona buttons at runtime which interfaces with the Design Token System auto-generated code.
/// Updating these properties causes the SwiftUI persona button to update its view automatically.
public class PersonaButtonTokens: ControlTokens {

    /// `MSFPersonaButtonSize` enumeration value that will define pre-defined values for fonts and spacing.
    public internal(set) var size: MSFPersonaButtonSize = .large

    // MARK: - Design Tokens

    /// The amount of space between the control's `Avatar` and text labels.
    open var avatarInterspace: CGFloat {
        switch size {
        case .small:
            return globalTokens.spacing[.xSmall]
        case .large:
            return globalTokens.spacing[.small]
        }
    }

    /// The background color for the `PersonaButton`.
    open var backgroundColor: DynamicColor { aliasTokens.backgroundColors[.neutral1] }

    /// How much space should be reserved to the left and right of the control's `Avatar`.
    open var horizontalAvatarPadding: CGFloat {
        switch size {
        case .small:
            return globalTokens.spacing[.medium]
        case .large:
            return globalTokens.spacing[.xSmall]
        }
    }

    /// How much space should be reserved to the left and right of the control's labels.
    open var horizontalTextPadding: CGFloat { globalTokens.spacing[.xxxSmall] }

    /// The `DynamicColor` to use for the control's primary label.
    open var labelColor: DynamicColor { aliasTokens.foregroundColors[.neutral1] }

    /// The `FontInfo` to use for the control's primary label.
    open var labelFont: FontInfo {
        switch size {
        case .small:
            return aliasTokens.typography[.caption1]
        case .large:
            return aliasTokens.typography[.body2]
        }
    }

    /// The `DynamicColor` to use for the control's secondary label.
    open var sublabelColor: DynamicColor { aliasTokens.foregroundColors[.neutral3] }

    /// The `FontInfo` to use for the control's secondary label.
    open var sublabelFont: FontInfo { aliasTokens.typography[.caption1] }

    /// How much padding to add above the `Avatar` and below the lowest text label.
    open var verticalPadding: CGFloat { globalTokens.spacing[.xSmall] }
}
