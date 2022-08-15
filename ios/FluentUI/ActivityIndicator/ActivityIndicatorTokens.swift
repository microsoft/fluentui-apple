//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// Pre-defined sizes of the Activity Indicator.
@objc public enum MSFActivityIndicatorSize: Int, CaseIterable {
    case xSmall
    case small
    case medium
    case large
    case xLarge
}

/// Design token set for the `ActivityIndicator` control.
open class ActivityIndicatorTokens: ControlTokens {
    /// MSFActivityIndicatorSize enumeration value that will define pre-defined values for side and thickness.
    public internal(set) var size: MSFActivityIndicatorSize = .large

    // MARK: - Design Tokens

    /// The default color of the Activity Indicator.
    open var defaultColor: DynamicColor { aliasTokens.foregroundColors[.neutral4] }

    /// The value for the side of the square frame of an Activity Indicator.
    open var side: CGFloat {
        switch size {
        case .xSmall:
            return 12
        case .small:
            return 16
        case .medium:
            return 24
        case .large:
            return 32
        case .xLarge:
            return 36
        }
    }

    /// The value for the thickness of the ActivityIndicator ring.
    open var thickness: CGFloat {
        switch size {
        case .xSmall, .small:
            return 1
        case .medium:
            return 2
        case .large:
            return 3
        case .xLarge:
            return 4
        }
    }
}
