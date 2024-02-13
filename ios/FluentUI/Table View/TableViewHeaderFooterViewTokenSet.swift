//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//
import UIKit

public enum TableViewHeaderFooterViewToken: Int, TokenSetKey {
    /// The background color in plain mode.
    case backgroundColorPlain

    /// The background color in grouped mode.
    case backgroundColorGrouped

    /// The color of the header/footer text.
    case textColor

    /// The font of the header/footer text.
    case textFont

    /// The color of the leading view.
    case leadingViewColor

    /// The color of the accessory button text.
    case accessoryButtonTextColor

    /// The font of the accessory button text.
    case accessoryButtonTextFont

    /// The color of the link text in the TableViewHeaderFooterViewTitleView.
    case linkTextColor
}

public class TableViewHeaderFooterViewTokenSet: ControlTokenSet<TableViewHeaderFooterViewToken> {
    init(style: @escaping () -> TableViewHeaderFooterView.Style,
         accessoryButtonStyle: @escaping () -> TableViewHeaderFooterView.AccessoryButtonStyle) {
        self.style = style
        self.accessoryButtonStyle = accessoryButtonStyle
        super.init { [style, accessoryButtonStyle] token, theme in
            switch token {
            case .backgroundColorPlain:
                return .uiColor { theme.color(.background1) }

            case .backgroundColorGrouped:
                return .uiColor { theme.color(.backgroundCanvas) }

            case .textColor:
                return .uiColor {
                    switch style() {
                    case .headerPrimary:
                        return theme.color(.foreground1)
                    case .header, .footer:
                        return theme.color(.foreground2)
                    }
                }

            case .textFont:
                return .uiFont {
                    switch style() {
                    case .headerPrimary:
                        return theme.typography(.body1Strong)
                    case .header:
                        return theme.typography(Compatibility.isDeviceIdiomVision() ? .body1Strong : .caption1)
                    case .footer:
                        return theme.typography(.caption1)
                    }
                }

            case .leadingViewColor:
                return .uiColor { theme.color(.foreground3) }

            case .accessoryButtonTextColor:
                return .uiColor {
                    switch accessoryButtonStyle() {
                    case .primary:
                        return theme.color(.brandForeground1)
                    case .regular:
                        return theme.color(.foreground2)
                    }
                }

            case .accessoryButtonTextFont:
                return .uiFont {
                    switch style() {
                    case .headerPrimary:
                        return theme.typography(.body2Strong)
                    case .header, .footer:
                        return theme.typography(.caption1Strong)
                    }
                }

            case .linkTextColor:
                return .uiColor { theme.color(.brandForeground1) }
            }
        }
    }

    /// Defines the style of the `TableViewHeaderFooterView`.
    var style: () -> TableViewHeaderFooterView.Style

    /// Defines the style of the accessory button.
    var accessoryButtonStyle: () -> TableViewHeaderFooterView.AccessoryButtonStyle
}

// MARK: Constants

extension TableViewHeaderFooterViewTokenSet {
    ///The horizontal margin of the HeaderFooter view.
    static let horizontalMargin: CGFloat = GlobalTokens.spacing(.size160)

    ///The default top margin for the title.
    static let titleDefaultTopMargin: CGFloat = GlobalTokens.spacing(.size240)

    /// The default bottom margin for the title.
    static let titleDefaultBottomMargin: CGFloat = GlobalTokens.spacing(.size80)

    /// The vertical divider margin for the title
    static let titleDividerVerticalMargin: CGFloat = 3

    /// The bottom margin for the accessory view.
    static let accessoryViewBottomMargin: CGFloat = GlobalTokens.spacing(.size20)

    /// The leading margin for the accessory view.
    static let accessoryViewMarginLeading: CGFloat = GlobalTokens.spacing(.size80)
}

public extension TableViewHeaderFooterView {
    /// The style of the accessory button in the TableView HeaderFooterView.
    @objc(MSFTableViewHeaderFooterViewAccessoryButtonStyle)
    enum AccessoryButtonStyle: Int {
        case primary
        case regular
    }

    /// Defines the visual style of the HeaderFooterView.
    @objc(MSFTableViewHeaderFooterViewStyle)
    enum Style: Int {
        case headerPrimary
        case header
        case footer
    }
}
