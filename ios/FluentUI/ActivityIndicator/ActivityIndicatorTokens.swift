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
public class ActivityIndicatorTokens: ControlTokens {
    /// Creates an instance of `ActivityIndicatorTokens` with optional token value overrides.
    /// - Parameters:
    ///   - size: MSFActivityIndicatorSize enumeration value that will define pre-defined values for side and thickness.
    ///   - defaultColor: The default color of the Activity Indicator.
    ///   - side: The value for the side of the square frame of an Activity Indicator.
    ///   - thickness: The value for the thickness of the ActivityIndicator ring.
    public init(size: MSFActivityIndicatorSize,
                defaultColor: DynamicColor? = nil,
                side: CGFloat? = nil,
                thickness: CGFloat? = nil) {

        self.size = size
        super.init()

        // Optional overrides
        if let defaultColor = defaultColor {
            self.defaultColor = defaultColor
        }
        if let side = side {
            self.side = side
        }
        if let thickness = thickness {
            self.thickness = thickness
        }
    }

    let size: MSFActivityIndicatorSize

    // MARK: - Design Tokens

    lazy var defaultColor: DynamicColor = aliasTokens.foregroundColors[.neutral4]

    lazy var side: CGFloat = {
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
    }()

    lazy var thickness: CGFloat = {
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
    }()
}
