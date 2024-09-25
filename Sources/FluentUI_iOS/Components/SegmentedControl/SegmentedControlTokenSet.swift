//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public enum SegmentedControlToken: Int, TokenSetKey {
    /// Defines the background color of the unselected segments of the `SegmentedControl`.
    case restTabColor

    /// Defines the background color of the selected segments of the `SegmentedControl`.
    case selectedTabColor

    /// Defines the background color of the unselected segments of the `SegmentedControl` when disabled.
    case disabledTabColor

    /// Defines the background color of the selected segments of the `SegmentedControl` when disabled.
    case disabledSelectedTabColor

    /// Defines the label color of the unselected segments of the `SegmentedControl`.
    case restLabelColor

    /// Defines the label color of the selected segments of the `SegmentedControl`.
    case selectedLabelColor

    /// Defines the label color of the unselected segments of the `SegmentedControl` when disabled.
    case disabledLabelColor

    /// Defines the label color of the selected segments of the `SegmentedControl` when disabled.
    case disabledSelectedLabelColor

    /// The color of the unread dot when the `SegmentedControl` is enabled.
    case enabledUnreadDotColor

    /// The color of the unread dot when the `SegmentedControl` is disabled.
    case disabledUnreadDotColor

    /// The distance of the content from the top and bottom of the `SegmentedControl`.
    case verticalInset

    /// The distance of the content from the leading and trailing edges of the `SegmentedControl`.
    case horizontalInset

    /// The distance of the unread dot from the trailing edge of the content of the `SegmentedControl`.
    case unreadDotOffsetX

    /// The distance of the unread dot from the top of the content of the `SegmentedControl`.
    case unreadDotOffsetY

    /// The size of the unread dot of the `SegmentedControl`
    case unreadDotSize

    /// The font used for the label of the `SegmentedControl`.
    case font
}

/// Design token set for the `SegmentedControl`.
public class SegmentedControlTokenSet: ControlTokenSet<SegmentedControlToken> {
    init(style: @escaping () -> SegmentedControlStyle) {
        self.style = style
        super.init { [style] token, theme in
            switch token {
            case .restTabColor:
                return .uiColor {
                    switch style() {
                    case .primaryPill, .neutralOverNavBarPill:
                        return UIColor(light: theme.color(.background5).light,
                                       dark: theme.color(.background5).dark)
                    case .neutralOverCanvasPill, .brandOverCanvasPill:
                        return theme.color(.background3)
                    case .onBrandPill, .brandOverNavBarPill:
                        return UIColor(light: theme.color(.brandBackground2).light,
                                       dark: theme.color(.background5).dark)
                    }
                }

            case .selectedTabColor:
                return .uiColor {
                    switch style() {
                    case .primaryPill, .neutralOverCanvasPill, .neutralOverNavBarPill:
                        return theme.color(.brandBackground1)
                    case .onBrandPill, .brandOverNavBarPill:
                        return UIColor(light: theme.color(.background3).light,
                                       dark: theme.color(.background5Selected).dark)
                    case .brandOverCanvasPill:
                        return UIColor(light: theme.color(.brandBackground1).light,
                                       dark: theme.color(.background3Selected).dark)
                    }
                }

            case .disabledTabColor:
                return .uiColor {
                    switch style() {
                    case .primaryPill, .neutralOverNavBarPill:
                        return UIColor(light: theme.color(.background5).light,
                                       dark: theme.color(.background5).dark)
                    case .neutralOverCanvasPill, .brandOverCanvasPill:
                        return UIColor(light: theme.color(.background3).light,
                                       dark: theme.color(.background3).dark)
                    case .onBrandPill, .brandOverNavBarPill:
                        return UIColor(light: theme.color(.brandBackground2).light,
                                       dark: theme.color(.background5).dark)
                    }
                }

            case .disabledSelectedTabColor:
                return .uiColor {
                    switch style() {
                    case .primaryPill, .neutralOverNavBarPill, .neutralOverCanvasPill:
                        return UIColor(light: theme.color(.brandBackground1).light,
                                       dark: theme.color(.brandBackground1).dark)
                    case .onBrandPill, .brandOverNavBarPill:
                        return UIColor(light: theme.color(.background1).light,
                                       dark: theme.color(.background5Selected).dark)
                    case .brandOverCanvasPill:
                        return UIColor(light: theme.color(.brandBackground1Selected).light,
                                       dark: theme.color(.background3Selected).dark)
                    }
                }

            case .restLabelColor:
                return .uiColor {
                    switch style() {
                    case .primaryPill, .neutralOverNavBarPill, .neutralOverCanvasPill:
                        return theme.color(.foreground2)
                    case .onBrandPill, .brandOverNavBarPill:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground2).dark)
                    case .brandOverCanvasPill:
                        return UIColor(light: theme.color(.brandForeground1).light,
                                       dark: theme.color(.foreground2).dark)
                    }
                }

            case .selectedLabelColor:
                return .uiColor {
                    switch style() {
                    case .primaryPill, .neutralOverNavBarPill, .neutralOverCanvasPill:
                        return theme.color(.foregroundOnColor)
                    case .onBrandPill, .brandOverNavBarPill:
                        return UIColor(light: theme.color(.brandForeground1).light,
                                       dark: theme.color(.foreground1).dark)
                    case .brandOverCanvasPill:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground1).dark)
                    }
                }

            case .disabledLabelColor, .disabledUnreadDotColor:
                return .uiColor {
                    switch style() {
                    case .primaryPill, .neutralOverNavBarPill, .neutralOverCanvasPill:
                        return theme.color(.foregroundDisabled1)
                    case .onBrandPill, .brandOverNavBarPill:
                        return UIColor(light: theme.color(.brandForegroundDisabled1).light,
                                       dark: theme.color(.foregroundDisabled1).dark)
                    case .brandOverCanvasPill:
                        return UIColor(light: theme.color(.brandForegroundDisabled2).light,
                                       dark: theme.color(.foregroundDisabled1).dark)
                    }
                }

            case .disabledSelectedLabelColor:
                return .uiColor {
                    switch style() {
                    case .primaryPill, .neutralOverNavBarPill, .neutralOverCanvasPill:
                        return theme.color(.brandForegroundDisabled1)
                    case .onBrandPill, .brandOverNavBarPill:
                        return UIColor(light: theme.color(.brandForegroundDisabled2).light,
                                       dark: theme.color(.foregroundDisabled2).dark)
                    case .brandOverCanvasPill:
                        return UIColor(light: theme.color(.brandForegroundDisabled1).light,
                                       dark: theme.color(.foregroundDisabled2).dark)
                    }
                }

            case .enabledUnreadDotColor:
                return .uiColor {
                    switch style() {
                    case .primaryPill, .neutralOverNavBarPill, .neutralOverCanvasPill, .brandOverCanvasPill:
                        return UIColor(light: theme.color(.brandForeground1).light,
                                       dark: theme.color(.foreground1).dark)
                    case .onBrandPill, .brandOverNavBarPill:
                        return UIColor(light: theme.color(.foregroundOnColor).light,
                                       dark: theme.color(.foreground1).dark)
                    }
                }

            case .verticalInset:
                return .float { 6.0 }

            case .horizontalInset:
                return .float { GlobalTokens.spacing(.size160) }

            case .unreadDotOffsetX:
                return .float { 6.0 }

            case .unreadDotOffsetY:
                return .float { 3.0 }

            case .unreadDotSize:
                return .float { 6.0 }

            case .font:
                return .uiFont { theme.typography(.body2, adjustsForContentSizeCategory: false) }
            }
        }
    }

    /// Defines the style of the `SegmentedControl`.
    var style: () -> SegmentedControlStyle
}

// MARK: Constants
extension SegmentedControlTokenSet {
    static let pillButtonCornerRadius: CGFloat = 16
    static let pillContainerHorizontalInset: CGFloat = 16
}

@objc(MSFSegmentedControlStyle)
public enum SegmentedControlStyle: Int {
    /// Segments are shown as labels inside a pill for use with a neutral or white background. Selection is indicated by a thumb under the selected label.
    @available(*, deprecated, message: "primaryPill is now deprecated. Please use neutralOverNavBarPill.")
    case primaryPill
    /// Segments are shown as labels inside a pill for use on a branded background that features a prominent brand color in light mode and a muted grey in dark mode.
    /// Selection is indicated by a thumb under the selected label.
    @available(*, deprecated, message: "onBrandPill is now deprecated. Please use brandOverNavBarPill.")
    case onBrandPill

    /// Segments are shown as labels inside a pill for use with a neutral or white backround,
    /// when the buttons should be a prominent brand color in light mode and a muted grey in dark mode.
    case brandOverCanvasPill

    /// Segments are shown as labels inside a pill for use with branded Navigation Bar where the background features
    /// a prominent brand color in light mode and a muted gray in dark mode.
    case brandOverNavBarPill

    /// Segments are shown as labels inside a pill for use with a neutral or white background.
    case neutralOverCanvasPill

    /// Segments are shown as labels inside a pill for use with a non-brand-colored Navigation Bar.
    case neutralOverNavBarPill
}
