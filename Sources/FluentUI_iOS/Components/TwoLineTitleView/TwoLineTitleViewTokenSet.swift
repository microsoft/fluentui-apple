//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public enum TwoLineTitleViewToken: Int, TokenSetKey {
    /// Describes the color of the subtitle.
    case subtitleColor

    /// Describes the font used for the subtitle.
    case subtitleFont

    /// Describes the color of the title.
    case titleColor

    /// Describes the font used for the title.
    case titleFont
}

/// Design token set for the `TwoLineTitleView` control.
public class TwoLineTitleViewTokenSet: ControlTokenSet<TwoLineTitleViewToken> {
    init(style: @escaping () -> TwoLineTitleView.Style) {
        super.init { [style] token, theme in
            switch token {
            case .subtitleColor:
                return .uiColor {
                    switch style() {
                    case .primary:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground2).dark)
                    case .system:
                        return theme.color(.foreground2)
                    }
                }
            case .subtitleFont:
                return .uiFont {
                    theme.typography(Self.defaultSubtitleFont)
                }
            case .titleColor:
                return .uiColor {
                    switch style() {
                    case .primary:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground1).dark)
                    case .system:
                        return theme.color(.foreground1)
                    }
                }
            case .titleFont:
                return .uiFont {
                    theme.typography(Self.defaultTitleFont)
                }
            }
        }
    }
}

extension TwoLineTitleViewTokenSet {
    static let textColorAnimationDuration: TimeInterval = 0.2

    static func textColorAlpha(highlighted: Bool) -> CGFloat {
        highlighted ? 0.4 : 1
    }

    static let defaultTitleFont: FluentTheme.TypographyToken = .body1Strong
    static let defaultSubtitleFont: FluentTheme.TypographyToken = .caption1

    static let minimumTouchSize: CGSize = EasyTapButton.minimumTouchSize

    static let titleImageSizeToken: GlobalTokens.IconSizeToken = .size160
    static let subtitleImageSizeToken: GlobalTokens.IconSizeToken = .size120

    static let titleStackSpacing = GlobalTokens.spacing(.size40)
    static let leadingImageAndTitleSpacing = GlobalTokens.spacing(.size80)
}
