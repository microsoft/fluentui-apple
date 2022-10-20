//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Design token set for the `Tooltip` control.
public class TooltipTokenSet: ControlTokenSet<TooltipTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// The color of the body of the tooltip.
        case tooltipColor
        /// The color of the text within the tooltip.
        case textColor
        /// The margins from the window's safe area insets used for laying out the tooltip.
        case shadowInfo
        /// The radius for the corners of the tooltip.
        case backgroundCornerRadius
        /// The TextStyle of the message label.
        case messageLabelTextStyle
        /// The TextStyle of the title label.
        case titleLabelTextStyle
        /// The horizontal padding between the text and edges of the tooltip.
        case paddingHorizontal
        /// The vertical padding between the text and edges of the tooltip with both a title and message.
        case paddingVerticalWithTitle
        /// The vertical padding between the text and edges of the tooltip with just a message.
        case paddingVerticalWithoutTitle
        /// The vertical spacing between the title and message.
        case spacingVertical
        /// The maximum width of the tooltip.
        case maximumWidth
        /// The height of the arrow of the tooltip.
        case arrowHeight
        /// The width of the arrow of the tooltip.
        case arrowWidth
    }

    init() {
        super.init { token, theme in
            switch token {
            case .tooltipColor:
                return .dynamicColor { DynamicColor(light: GlobalTokens.neutralColors(.grey14),
                                                    dark: GlobalTokens.neutralColors(.grey24))
                }
            case .textColor:
                return .dynamicColor { DynamicColor(light: GlobalTokens.neutralColors(.white)) }
            case .shadowInfo:
                return .shadowInfo { theme.aliasTokens.shadow[.shadow16] }
            case .backgroundCornerRadius:
                return .float { GlobalTokens.borderRadius(.large) }
            case .messageLabelTextStyle:
                return .fontInfo { theme.aliasTokens.typography[.body2] }
            case .titleLabelTextStyle:
                return .fontInfo { theme.aliasTokens.typography[.body1Strong] }
            case .paddingHorizontal,
                    .paddingVerticalWithTitle:
                return .float { GlobalTokens.spacing(.small) }
            case .paddingVerticalWithoutTitle,
                    .spacingVertical:
                return .float { GlobalTokens.spacing(.xSmall) }
            case .maximumWidth:
                return .float { 250.0 }
            case .arrowHeight:
                return .float { 7.0 }
            case .arrowWidth:
                return .float { 14.0 }
            }
        }
    }
}
