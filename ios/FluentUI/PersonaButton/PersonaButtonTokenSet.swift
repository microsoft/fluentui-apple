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
public class PersonaButtonTokenSet: ControlTokenSet<PersonaButtonTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// The amount of space between the control's `Avatar` and text labels.
        case avatarInterspace

        /// The background color for the `PersonaButton`.
        case backgroundColor

        /// How much space should be reserved to the left and right of the control's `Avatar`.
        case horizontalAvatarPadding

        /// How much space should be reserved to the left and right of the control's labels.
        case horizontalTextPadding

        /// The `DynamicColor` to use for the control's primary label.
        case labelColor

        /// The `FontInfo` to use for the control's primary label.
        case labelFont

        /// The `DynamicColor` to use for the control's secondary label.
        case sublabelColor

        /// The `FontInfo` to use for the control's secondary label.
        case sublabelFont

        /// How much padding to add above the `Avatar` and below the lowest text label.
        case verticalPadding
    }

    init(size: @escaping () -> MSFPersonaButtonSize) {
        self.size = size
        super.init()
    }

    @available(*, unavailable)
    required init() {
        preconditionFailure("init() has not been implemented")
    }

    override func defaultValue(_ token: Tokens) -> ControlTokenValue {
        switch token {
            /// The amount of space between the control's `Avatar` and text labels.
        case .avatarInterspace:
            return .float {
                switch self.size() {
                case .small:
                    return self.globalTokens.spacing[.xSmall]
                case .large:
                    return self.globalTokens.spacing[.small]
                }
            }

            /// The background color for the `PersonaButton`.
        case .backgroundColor:
            return .dynamicColor { self.aliasTokens.backgroundColors[.neutral1] }

            /// How much space should be reserved to the left and right of the control's `Avatar`.
        case .horizontalAvatarPadding:
            return .float {
                switch self.size() {
                case .small:
                    return self.globalTokens.spacing[.medium]
                case .large:
                    return self.globalTokens.spacing[.xSmall]
                }
            }

            /// How much space should be reserved to the left and right of the control's labels.
        case .horizontalTextPadding:
            return .float { self.globalTokens.spacing[.xxxSmall] }

            /// The `DynamicColor` to use for the control's primary label.
        case .labelColor:
            return .dynamicColor { self.aliasTokens.foregroundColors[.neutral1] }

            /// The `FontInfo` to use for the control's primary label.
        case .labelFont:
            return .fontInfo {
                switch self.size() {
                case .small:
                    return self.aliasTokens.typography[.caption1]
                case .large:
                    return self.aliasTokens.typography[.body2]
                }
            }

            /// The `DynamicColor` to use for the control's secondary label.
        case .sublabelColor:
            return .dynamicColor { self.aliasTokens.foregroundColors[.neutral3] }

            /// The `FontInfo` to use for the control's secondary label.
        case .sublabelFont:
            return .fontInfo { self.aliasTokens.typography[.caption1] }

            /// How much padding to add above the `Avatar` and below the lowest text label.
        case .verticalPadding:
            return .float { self.globalTokens.spacing[.xSmall] }
        }
    }

    /// `MSFPersonaButtonSize` enumeration value that will define pre-defined values for fonts and spacing.
    var size: () -> MSFPersonaButtonSize
}
