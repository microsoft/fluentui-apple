//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// Representation of design tokens for the Indeterminate Progress Bar.
public class IndeterminateProgressBarTokens: ControlTokens {

    /// Progress bar's background color.
    open var backgroundColor: DynamicColor { aliasTokens.backgroundColors[.surfaceQuaternary] }

    /// Progress bar's gradient color.
    open var gradientColor: DynamicColor { globalTokens.brandColors[.primary] }

    /// Progress bar's height.
    open var height: CGFloat { 2 }
}
