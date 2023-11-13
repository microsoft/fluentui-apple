//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Style to draw the `CardNudge` control.
@objc public enum MSFCardNudgeStyle: Int, CaseIterable {
    /// Drawn with a shaded background and no outline.
    case standard

    /// Drawn with a neutral background and a thin outline.
    case outline
}

/// Design token set for the `CardNudge` control.
public class CardNudgeTokenSet: ControlTokenSet<CardNudgeTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// The  color applied to the accent text and icon
        case accentColor

        /// The background color of the`CardNudge` control
        case backgroundColor

        /// The background color of the action button and main icon
        case buttonBackgroundColor

        /// The foreground color of the action button and main icon
        case buttonForegroundColor

        /// The color of the outline of the`CardNudge` control
        case outlineColor

        /// The color of the subtitle text and dismiss icon
        case subtitleTextColor

        /// The color of the title text
        case textColor

        /// The circle radius of the main icon
        case circleRadius

        /// The corner radius of the action button and the`CardNudge` control
        case cornerRadius

        /// The width of the`CardNudge` control outline
        case outlineWidth

        /// The font applied to the title text and action button text
        case titleFont

        /// The font applied to the subtitle text and the accent text
        case subtitleFont
    }

    init(style: @escaping () -> MSFCardNudgeStyle) {
        self.style = style
        super.init { [style] token, theme in
            switch token {
            case .accentColor:
                return .uiColor {
                    theme.color(.brandForeground1)
                }

            case .backgroundColor:
                switch style() {
                case .standard:
                    return .uiColor {
                        theme.color(.backgroundCanvas)
                    }
                case .outline:
                    return .uiColor {
                        theme.color(.background1)
                    }
                }

            case .buttonBackgroundColor:
                return .uiColor {
                    theme.color(.brandBackgroundTint)
                }

            case .buttonForegroundColor:
                return .uiColor {
                    theme.color(.brandForegroundTint)
                }

            case .circleRadius:
                return .float {
                    GlobalTokens.corner(.radiusCircular)
                }

            case .cornerRadius:
                return .float {
                    GlobalTokens.corner(.radius120)
                }

            case .outlineColor:
                switch style() {
                case .standard:
                    return .uiColor {
                        theme.color(.backgroundCanvas)
                    }
                case .outline:
                    return .uiColor {
                        theme.color(.stroke2)
                    }
                }

            case .outlineWidth:
                return .float {
                    GlobalTokens.stroke(.width10)
                }

            case .subtitleTextColor:
                return .uiColor {
                    theme.color(.foreground2)
                }

            case .textColor:
                return .uiColor {
                    theme.color(.foreground1)
                }

            case .titleFont:
                return .uiFont {
                    theme.typography(.body2Strong)
                }

            case .subtitleFont:
                return .uiFont {
                    theme.typography(.caption1)
                }
            }
        }
    }

    // Required state value
    var style: () -> MSFCardNudgeStyle
}

// MARK: - Constants

extension CardNudgeTokenSet {
    static let iconSize: CGFloat = GlobalTokens.icon(.size240)
    static let circleSize: CGFloat = GlobalTokens.icon(.size400)
    static let accentIconSize: CGFloat = GlobalTokens.icon(.size120)
    static let accentPadding: CGFloat = GlobalTokens.spacing(.size40)

    static let horizontalPadding: CGFloat = GlobalTokens.spacing(.size160)
    static let verticalPadding: CGFloat = GlobalTokens.spacing(.size80)
    static let buttonInnerPaddingHorizontal: CGFloat = GlobalTokens.spacing(.size120)
    static let interTextVerticalPadding: CGFloat = GlobalTokens.spacing(.size20)
    static let mainContentVerticalPadding: CGFloat = GlobalTokens.spacing(.size120)

    static let minimumHeight: CGFloat = 56.0
}
