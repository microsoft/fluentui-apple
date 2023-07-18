//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public class BottomCommandingTokenSet: ControlTokenSet<BottomCommandingTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// The color of the background of the `BottomCommandingController`.
        case backgroundColor

        case heroDisabledColor

        case heroLabelFont

        case heroRestIconColor

        case heroRestLabelColor

        case heroSelectedColor

        case listIconColor

        case listLabelColor

        case listLabelFont

        case listSectionLabelColor

        case listSectionLabelFont

        case resizingHandleMarkColor

        case strokeColor

        case shadow
    }

    init() {
        super.init { token, theme in
            switch token {
            case .backgroundColor:
                return .uiColor { theme.color(.background1) }
            case .heroDisabledColor:
                return .uiColor { theme.color(.foregroundDisabled1) }
            case .heroLabelFont:
                return .uiFont { theme.typography(.caption2, adjustsForContentSizeCategory: false) }
            case .heroRestIconColor:
                return .uiColor { theme.color(.foreground3) }
            case .heroRestLabelColor:
                return .uiColor { theme.color(.foreground2) }
            case .heroSelectedColor:
                return .uiColor { theme.color(.brandForeground1) }
            case .listIconColor:
                return .uiColor { theme.color(.foreground2) }
            case .listLabelColor:
                return .uiColor { theme.color(.foreground1) }
            case .listLabelFont:
                return .uiFont { theme.typography(.body1) }
            case .listSectionLabelColor:
                return .uiColor { theme.color(.foreground2) }
            case .listSectionLabelFont:
                return .uiFont { theme.typography(.caption1) }
            case .resizingHandleMarkColor:
                return .uiColor { theme.color(.strokeAccessible) }
            case .strokeColor:
                return .uiColor { theme.color(.stroke2) }
            case .shadow:
                return .shadowInfo { theme.shadow(.shadow28) }
            }
        }
    }
}

extension BottomCommandingTokenSet {
    static let gridSpacing: CGFloat = GlobalTokens.spacing(.size80)
    static let cornerRadius: CGFloat = GlobalTokens.corner(.radius120)
    static let tabVerticalPadding: CGFloat = GlobalTokens.spacing(.size80)
    static let tabHorizontalPadding: CGFloat = GlobalTokens.spacing(.size160)
    static let strokeWidth: CGFloat = GlobalTokens.stroke(.width05)
    static let handleHeaderHeight: CGFloat = GlobalTokens.spacing(.size120)
}
