//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// Representation of design tokens for the Indeterminate Progress Bar.
public class IndeterminateProgressBarTokens: ControlTokens {

    /// Creates a new instance of the IndeterminateProgressBarTokens.
    /// - Parameters:
    ///   - backgroundColor: Optional override value of the background color.
    ///   - gradientColor: Optional override value of the gradient color.
    ///   - height: Optional override value of the height.
    public init(backgroundColor: DynamicColor? = nil,
                gradientColor: DynamicColor? = nil,
                height: CGFloat? = nil) {
        super.init()

        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }

        if let gradientColor = gradientColor {
            self.gradientColor = gradientColor
        }

        if let height = height {
            self.height = height
        }
    }

    lazy var backgroundColor: DynamicColor = aliasTokens.backgroundColors[.surfaceQuaternary]

    lazy var gradientColor: DynamicColor = globalTokens.brandColors[.primary]

    lazy var height: CGFloat = 2
}
