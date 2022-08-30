//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// Design token set for the `ActivityIndicator` control.
open class HeadsUpDisplayTokens: ControlTokens {

    /// The color of the squared background of the Heads-up display.
    open var backgroundColor: DynamicColor { aliasTokens.colors[.backgroundInverted] }

    /// The color of the activity indicator presented by the Heads-up display.
    open var activityIndicatorColor: DynamicColor { aliasTokens.colors[.foreground2] }

    /// The color of the label presented by the Heads-up display.
    open var labelColor: DynamicColor { aliasTokens.colors[.foregroundInverted1] }

    /// The corner radius of the squared background of the Heads-up display.
    open var cornerRadius: CGFloat {
        return globalTokens.borderRadius[.medium]
    }

    /// The distance between the label and image contents from the left and right edges of the squared background of the Heads-up display.
    open var horizontalPadding: CGFloat {
        return globalTokens.spacing[.small]
    }

    /// The distance between the label and image contents from the top and bottom edges of the squared background of the Heads-up display.
    open var verticalPadding: CGFloat {
        return globalTokens.spacing[.large]
    }

    /// The distance between the top of the hud panel and the activity indicator
    open var topPadding: CGFloat {
        return globalTokens.spacing[.large]
    }

    /// The distance between the bottom of the hud panel and the label
    open var bottomPadding: CGFloat {
        return globalTokens.spacing[.medium]
    }

    /// The minimum value for the side of the squared background of the Heads-up display.
    open var minSize: CGFloat {
        return 100
    }

    /// The maximum value for the side of the squared background of the Heads-up display.
    open var maxSize: CGFloat {
        return 192
    }
}
