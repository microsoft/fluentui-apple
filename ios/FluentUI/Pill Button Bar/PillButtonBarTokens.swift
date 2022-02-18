//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Design token set for the `PillButtonBar` control
open class PillButtonBarTokens: ControlTokens {
    /// Maximum spacing between `PillButton` controls
    open var maxButtonsSpacing: CGFloat { 10 }

    /// Minimum spacing between `PillButton` controls
    open var minButtonsSpacing: CGFloat { globalTokens.spacing[.xSmall] }

    /// Minimum width of the last button that must be showing on screen when the `PillButtonBar` loads or redraws
    open var minButtonVisibleWidth: CGFloat { globalTokens.spacing[.large] }

    /// Minimum width of a `PillButton`
    open var minButtonWidth: CGFloat { 56 }

    /// Minimum height of the `PillButtonBar`
    open var minHeight: CGFloat { 28 }

    /// Offset from the leading edge when the `PillButtonBar` loads or redraws
    open var sideInset: CGFloat { globalTokens.spacing[.medium] }
}
