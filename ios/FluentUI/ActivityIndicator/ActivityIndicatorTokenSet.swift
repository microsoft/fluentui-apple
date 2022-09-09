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
public class ActivityIndicatorTokenSet: ControlTokenSet<ActivityIndicatorTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// The default color of the Activity Indicator.
        case defaultColor

        /// The value for the thickness of the ActivityIndicator ring.
        case thickness
    }

    init(size: @escaping () -> MSFActivityIndicatorSize) {
        self.size = size
        super.init { [size] token, theme in
            switch token {
            case .defaultColor:
                return .dynamicColor { theme.aliasTokens.foregroundColors[.neutral4] }

            case .thickness:
                return .float {
                    switch size() {
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

    /// MSFActivityIndicatorSize enumeration value that will define pre-defined values for side and thickness.
    var size: () -> MSFActivityIndicatorSize

}

// MARK: - Constants

extension ActivityIndicatorTokenSet {
    static func sideLength(size: MSFActivityIndicatorSize) -> CGFloat {
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
}
