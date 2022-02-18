//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Design token set for the `AvatarGroup` control
open class AvatarGroupTokens: ControlTokens {

    /// Defines the style of the `Avatar` controls in the `AvatarGroup`.
    public internal(set) var style: MSFAvatarGroupStyle = .stack

    /// Defines the size of the `Avatar` controls in the `AvatarGroup`.
    public internal(set) var size: MSFAvatarSize = .large

    // MARK: - Design Tokens

    /// CGFloat that defines the space between  the `Avatar` controls hosted by the `AvatarGroup`.
    open var interspace: CGFloat {
        switch style {
        case .stack:
            switch size {
            case .xsmall, .small:
                return -globalTokens.spacing[.xxxSmall]
            case .medium:
                return -globalTokens.spacing[.xxSmall]
            case .large:
                return -globalTokens.spacing[.xSmall]
            case .xlarge, .xxlarge:
                return -globalTokens.spacing[.small]
            }
        case .pile:
            switch size {
            case .xsmall, .small:
                return globalTokens.spacing[.xxSmall]
            case .medium, .large, .xlarge, .xxlarge:
                return globalTokens.spacing[.xSmall]
            }
        }
    }

    /// CGFloat that defines the thickness of the space between the `Avatar` and its ring.
    open var ringInnerGap: CGFloat {
        switch size {
        case .xsmall, .small, .medium, .large, .xlarge:
            return globalTokens.borderSize[.thick]
        case .xxlarge:
            return globalTokens.borderSize[.thicker]
        }
    }

    /// CGFloat that defines the thickness of the ring around the `Avatar`.
    open var ringThickness: CGFloat {
        switch size {
        case .xsmall, .small, .medium, .large, .xlarge:
            return globalTokens.borderSize[.thick]
        case .xxlarge:
            return globalTokens.borderSize[.thicker]
        }
    }

    /// CGFloat that defines the thickness of the space around the ring of the `Avatar`.
    open var ringOuterGap: CGFloat {
        switch size {
        case .xsmall, .small, .medium, .large, .xlarge:
            return globalTokens.borderSize[.thick]
        case .xxlarge:
            return globalTokens.borderSize[.thicker]
        }
    }
}
