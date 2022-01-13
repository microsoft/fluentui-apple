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

    /// Creates an instance of `PersonaButtonTokens` with optional token value overrides.
    public convenience init(size: MSFPersonaButtonSize,
                            avatarInterspace: CGFloat?  = nil,
                            backgroundColor: DynamicColor?  = nil,
                            horizontalAvatarPadding: CGFloat?  = nil,
                            horizontalTextPadding: CGFloat?  = nil,
                            labelColor: DynamicColor?  = nil,
                            labelFont: FontInfo?  = nil,
                            sublabelColor: DynamicColor?  = nil,
                            sublabelFont: FontInfo?  = nil,
                            verticalPadding: CGFloat?  = nil) {
        self.init(size: size)

        // Overrides
        if let avatarInterspace = avatarInterspace {
            self.avatarInterspace = avatarInterspace
        }
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
        if let horizontalAvatarPadding = horizontalAvatarPadding {
            self.horizontalAvatarPadding = horizontalAvatarPadding
        }
        if let horizontalTextPadding = horizontalTextPadding {
            self.horizontalTextPadding = horizontalTextPadding
        }
        if let labelColor = labelColor {
            self.labelColor = labelColor
        }
        if let labelFont = labelFont {
            self.labelFont = labelFont
        }
        if let sublabelColor = sublabelColor {
            self.sublabelColor = sublabelColor
        }
        if let sublabelFont = sublabelFont {
            self.sublabelFont = sublabelFont
        }
        if let verticalPadding = verticalPadding {
            self.verticalPadding = verticalPadding
        }
    }

    init(size: MSFPersonaButtonSize) {
        self.size = size
        super.init()
    }

    var size: MSFPersonaButtonSize

    // MARK: - Design Tokens

    lazy var avatarInterspace: CGFloat = {
        switch size {
        case .small:
            return globalTokens.spacing[.xSmall]
        case .large:
            return globalTokens.spacing[.small]
        }
    }()

    lazy var backgroundColor: DynamicColor = aliasTokens.backgroundColors[.neutral1]

    lazy var horizontalAvatarPadding: CGFloat = {
        switch size {
        case .small:
            return globalTokens.spacing[.medium]
        case .large:
            return globalTokens.spacing[.xSmall]
        }
    }()

    lazy var horizontalTextPadding: CGFloat = globalTokens.spacing[.xxxSmall]

    lazy var labelColor: DynamicColor = aliasTokens.foregroundColors[.neutral1]

    lazy var labelFont: FontInfo = {
        switch size {
        case .small:
            return aliasTokens.typography[.caption1]
        case .large:
            return aliasTokens.typography[.body2]
        }
    }()

    lazy var sublabelColor: DynamicColor = aliasTokens.foregroundColors[.neutral3]

    lazy var sublabelFont: FontInfo = aliasTokens.typography[.caption1]

    lazy var verticalPadding: CGFloat = globalTokens.spacing[.xSmall]
}
