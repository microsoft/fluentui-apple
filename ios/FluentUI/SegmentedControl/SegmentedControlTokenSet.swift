//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Design token set for the `SegmentedControl`.
public class SegmentedControlTokenSet: ControlTokenSet<SegmentedControlTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
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

    init(style: @escaping () -> SegmentedControlStyle) {
        self.style = style
        super.init()
    }

    @available(*, unavailable)
    required init() {
        preconditionFailure("init() has not been implemented")
    }

    override func defaultValue(_ token: Tokens) -> ControlTokenValue {
        switch token {
        case .restTabColor:
            return .dynamicColor {
                switch self.style() {
                case .primaryPill:
                    return DynamicColor(light: self.aliasTokens.backgroundColors[.neutral4].light,
                                        dark: self.aliasTokens.backgroundColors[.neutral3].dark)
                case .onBrandPill:
                    return DynamicColor(light: self.aliasTokens.backgroundColors[.brandHover].light,
                                        dark: self.aliasTokens.backgroundColors[.neutral3].dark)
                }
            }

        case .selectedTabColor:
            return .dynamicColor {
                switch self.style() {
                case .primaryPill:
                    return self.aliasTokens.foregroundColors[.brandRest]
                case .onBrandPill:
                    return DynamicColor(light: self.aliasTokens.backgroundColors[.neutral1].light,
                                        dark: self.globalTokens.neutralColors[.grey32])
                }
            }

        case .disabledTabColor:
            return .dynamicColor {
                switch self.style() {
                case .primaryPill:
                    return DynamicColor(light: self.globalTokens.neutralColors[.grey94],
                                        dark: self.globalTokens.neutralColors[.grey8])
                case .onBrandPill:
                    return DynamicColor(light: self.globalTokens.brandColors[.shade20].light,
                                        dark: self.globalTokens.neutralColors[.grey8])
                }
            }

        case .disabledSelectedTabColor:
            return .dynamicColor {
                switch self.style() {
                case .primaryPill:
                    return DynamicColor(light: self.globalTokens.neutralColors[.grey80],
                                        dark: self.globalTokens.neutralColors[.grey30])
                case .onBrandPill:
                    return DynamicColor(light: self.globalTokens.neutralColors[.white],
                                        dark: self.globalTokens.neutralColors[.grey30])
                }
            }

        case .restLabelColor:
            return .dynamicColor {
                switch self.style() {
                case .primaryPill:
                    return DynamicColor(light: self.aliasTokens.foregroundColors[.neutral3].light,
                                        dark: self.aliasTokens.foregroundColors[.neutral2].dark)
                case .onBrandPill:
                    return DynamicColor(light: self.aliasTokens.foregroundColors[.neutralInverted].light,
                                        dark: self.aliasTokens.foregroundColors[.neutral2].dark)
                }
            }

        case .selectedLabelColor:
            return .dynamicColor {
                switch self.style() {
                case .primaryPill:
                    return DynamicColor(light: self.aliasTokens.backgroundColors[.neutral1].light,
                                        dark: self.aliasTokens.foregroundColors[.neutralInverted].dark)
                case .onBrandPill:
                    return DynamicColor(light: self.aliasTokens.foregroundColors[.brandRest].light,
                                        dark: self.aliasTokens.foregroundColors[.neutral1].dark)
                }
            }

        case .disabledLabelColor, .disabledUnreadDotColor:
            return .dynamicColor {
                switch self.style() {
                case .primaryPill:
                    return DynamicColor(light: self.globalTokens.neutralColors[.grey70],
                                        dark: self.globalTokens.neutralColors[.grey26])
                case .onBrandPill:
                    return DynamicColor(light: self.globalTokens.brandColors[.shade10].light,
                                        dark: self.globalTokens.neutralColors[.grey26])
                }
            }

        case .disabledSelectedLabelColor:
            return .dynamicColor {
                switch self.style() {
                case .primaryPill:
                    return DynamicColor(light: self.globalTokens.neutralColors[.grey94],
                                        dark: self.globalTokens.neutralColors[.grey44])
                case .onBrandPill:
                    return DynamicColor(light: self.globalTokens.neutralColors[.grey74],
                                        dark: self.globalTokens.neutralColors[.grey44])
                }
            }

        case .enabledUnreadDotColor:
            return .dynamicColor {
                switch self.style() {
                case .primaryPill:
                    return self.aliasTokens.foregroundColors[.brandRest]
                case .onBrandPill:
                    return DynamicColor(light: self.aliasTokens.foregroundColors[.neutralInverted].light,
                                        dark: self.aliasTokens.foregroundColors[.neutral2].dark)
                }
            }

        case .verticalInset:
            return .float { 6.0 }

        case .horizontalInset:
            return .float { self.globalTokens.spacing[.medium] }

        case .unreadDotOffsetX:
            return .float { 6.0 }

        case .unreadDotOffsetY:
            return .float { 3.0 }

        case .unreadDotSize:
            return .float { 6.0 }

        case .font:
            return .fontInfo { self.aliasTokens.typography[.body2] }
        }
    }

    /// Defines the style of the `SegmentedControl`.
    var style: () -> SegmentedControlStyle
}

@objc(MSFSegmentedControlStyle)
public enum SegmentedControlStyle: Int {
    /// Segments are shows as labels inside a pill for use with a neutral or white background. Selection is indicated by a thumb under the selected label.
    case primaryPill
    /// Segments are shows as labels inside a pill for use on a branded background that features a prominent brand color in light mode and a muted grey in dark mode.
    /// Selection is indicated by a thumb under the selected label.
    case onBrandPill
}
