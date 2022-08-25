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
    public internal(set) var size: MSFAvatarSize = .size40

    // MARK: - Design Tokens

    /// CGFloat that defines the space between  the `Avatar` controls hosted by the `AvatarGroup`.
    open var interspace: CGFloat {
        switch style {
        case .stack:
            switch size {
            case .size16, .size24:
                return -GlobalTokens.spacing(.xxxSmall)
            case .size32:
                return -GlobalTokens.spacing(.xxSmall)
            case .size40:
                return -GlobalTokens.spacing(.xSmall)
            case .size56, .size72:
                return -GlobalTokens.spacing(.small)
            }
        case .pile:
            switch size {
            case .size16, .size24:
                return GlobalTokens.spacing(.xxSmall)
            case .size32, .size40, .size56, .size72:
                return GlobalTokens.spacing(.xSmall)
            }
        }
    }
}
