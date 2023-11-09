//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public enum BottomCommandingToken: Int, TokenSetKey {
    /// Defines the color of the background of the `BottomCommandingController`.
    case backgroundColor

    /// Defines the corner radius of the `BottomCommandingController`.
    case cornerRadius

    /// Defines the color of the disabled hero items of the `BottomCommandingController`.
    case heroDisabledColor

    /// Defines the font of the hero items of the `BottomCommandingController`.
    case heroLabelFont

    /// Defines the color of the icon of the hero items of the `BottomCommandingController`.
    case heroRestIconColor

    /// Defines the color of the label of the hero items of the `BottomCommandingController`.
    case heroRestLabelColor

    /// Defines the color of the hero item of the `BottomCommandingController` when `isOn` is true.
    case heroSelectedColor

    /// Defines the color of the icons in the list of the `BottomCommandingController`.
    case listIconColor

    /// Defines the color of the labels in the list of the `BottomCommandingController`.
    case listLabelColor

    /// Defines the font of the items in the list of the `BottomCommandingController`.
    case listLabelFont

    /// Defines the color of the section labels in the list of the `BottomCommandingController`.
    case listSectionLabelColor

    /// Defines the font of the section labels in the list of the `BottomCommandingController`.
    case listSectionLabelFont

    /// Defines the color of the resizing handle of the `BottomCommandingController`.
    case resizingHandleMarkColor

    /// Defines the color of the separator in the `BottomCommandingController`.
    case strokeColor

    /// Defines the shadows used by the `BottomCommandingController`.
    case shadow
}

public class BottomCommandingTokenSet: ControlTokenSet<BottomCommandingToken> {
    init() {
        super.init { token, theme in
            switch token {
            case .backgroundColor:
                return .uiColor { theme.color(.background2) }
            case .cornerRadius:
                return .float { GlobalTokens.corner(.radius120) }
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
    static let bottomBarTopSpacing: CGFloat = GlobalTokens.spacing(.size200)
    static let gridSpacing: CGFloat = GlobalTokens.spacing(.size80)
    static let tabVerticalPadding: CGFloat = GlobalTokens.spacing(.size80)
    static let tabHorizontalPadding: CGFloat = GlobalTokens.spacing(.size160)
    static let strokeWidth: CGFloat = GlobalTokens.stroke(.width05)
    static let handleHeaderHeight: CGFloat = GlobalTokens.spacing(.size120)
}
