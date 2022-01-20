//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// Pre-defined spacings of the divider
@objc public enum MSFDividerSpacing: Int {
    case none
    case medium
}

/// Design token set for the `FluentDivider` control.
public class DividerTokens: ControlTokens {
    /// Creates an instance of `MSFDividerTokens`with optional token value overrides.
    /// - Parameters:
    ///   - spacing: MSFDividerSpacing enumeration value that will define pre-defined value for the padding
    ///   - padding: CGFloat that defines the padding around the Fluent Divider
    ///   - color: The color of the Fluent Divider
    public init(spacing: MSFDividerSpacing = .none,
                padding: CGFloat? = nil,
                color: DynamicColor? = nil) {
        self.spacing = spacing
        super.init()

        // Optional overrides
        if let padding = padding {
            self.padding = padding
        }

        if let color = color {
            self.color = color
        }
    }

    // MARK: - Design Tokens

    let spacing: MSFDividerSpacing

    lazy var padding: CGFloat = {
        switch spacing {
        case .none:
            return globalTokens.spacing[.none]
        case .medium:
            return globalTokens.spacing[.medium]
        }
    }()

    lazy var color: DynamicColor = aliasTokens.strokeColors[.neutral2]
}
