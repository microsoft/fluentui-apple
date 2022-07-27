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
open class ActivityIndicatorTokenSet: ControlTokenSet<ActivityIndicatorTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// The default color of the Activity Indicator.
        case defaultColor

        /// The value for the side of the square frame of an Activity Indicator.
        case side

        /// The value for the thickness of the ActivityIndicator ring.
        case thickness
    }

    /// MSFActivityIndicatorSize enumeration value that will define pre-defined values for side and thickness.
    public internal(set) var size: MSFActivityIndicatorSize = .large

    override func defaultValue(_ token: Tokens) -> ControlTokenValue {
        switch token {
        case .defaultColor:
            return .dynamicColor { self.aliasTokens.foregroundColors[.neutral4] }

        case .side:
            return .float {
                switch self.size {
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

        case .thickness:
            return .float {
                switch self.size {
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
    }
}
