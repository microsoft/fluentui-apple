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
open class DividerTokens: ControlTokens {
    /// MSFDividerSpacing enumeration value that will define pre-defined value for the padding.
    public var spacing: MSFDividerSpacing {
        guard let state = state else { preconditionFailure() }
        return state.spacing
    }

    weak var state: MSFDividerState?

    // MARK: - Design Tokens

    /// Defines the padding around the Fluent Divider.
    open var padding: CGFloat {
        switch spacing {
        case .none:
            return globalTokens.spacing[.none]
        case .medium:
            return globalTokens.spacing[.medium]
        }
    }

    /// The color of the Fluent Divider
    open var color: DynamicColor { aliasTokens.strokeColors[.neutral2] }
}
