//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: ButtonStyle

@objc(MSFButtonStyle)
public enum ButtonStyle: Int, CaseIterable {
    case primaryFilled
    case primaryOutline
    case dangerFilled
    case dangerOutline
    case secondaryOutline
    case tertiaryOutline
    case borderless

    var hasBorders: Bool {
        switch self {
        case .dangerOutline, .primaryOutline, .secondaryOutline, .tertiaryOutline:
            return true
        case .borderless, .dangerFilled, .primaryFilled:
            return false
        }
    }

    var isDangerStyle: Bool {
        switch self {
        case .dangerFilled, .dangerOutline:
            return true
        case .borderless, .primaryFilled, .primaryOutline, .secondaryOutline, .tertiaryOutline:
            return false
        }
    }

    var isFilledStyle: Bool {
        switch self {
        case .dangerFilled, .primaryFilled:
            return true
        case .borderless, .dangerOutline, .primaryOutline, .secondaryOutline, .tertiaryOutline:
            return false
        }
    }
}

/// Design token set for the `Button` control.
public class ButtonTokenSet :ControlTokenSet<ButtonTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// Defines the background color of the button
        case backgroundColor
        /// Defines the border color of the button
        case borderColor
        /// Defines the size of the border around the button
        case borderSize
        /// Defines the radius of the corners of the button
        case cornerRadius
        /// Defines the colors of the text and icon of the button
        case foregroundColor
        /// Defines the font of the title of the button
        case titleFont
    }

    init(style: @escaping () -> ButtonStyle) {
        self.style = style
        super.init { [style] token, theme in
            switch token {
            case .backgroundColor:
                return .buttonDynamicColors {
                    switch style() {
                    case .primaryFilled:
                        return .init(
                            rest: theme.aliasTokens.backgroundColors[.brandRest],
                            hover: theme.aliasTokens.backgroundColors[.brandHover],
                            pressed: theme.aliasTokens.backgroundColors[.brandPressed],
                            selected: theme.aliasTokens.backgroundColors[.brandSelected],
                            disabled: theme.aliasTokens.backgroundColors[.brandDisabled]
                        )
                    case .primaryOutline, .dangerOutline, .secondaryOutline, .tertiaryOutline, .borderless:
                        return .init(
                            rest: DynamicColor(light: ColorValue.clear),
                            hover: DynamicColor(light: ColorValue.clear),
                            pressed: DynamicColor(light: ColorValue.clear),
                            selected: DynamicColor(light: ColorValue.clear),
                            disabled: DynamicColor(light: ColorValue.clear)
                        )
                    case .dangerFilled:
                        return .init(
                            // dangerPrimary
                            rest: DynamicColor(light: ColorValue(0xD92C2C),
                                               dark: ColorValue(0xE83A3A)),
                            hover: DynamicColor(light: ColorValue(0xDD4242) /* dangerTint10.any */,
                                                dark: ColorValue(0x8B2323) /* dangerTint20.dark */),
                            pressed: DynamicColor(light: ColorValue(0xDD4242) /* dangerTint10.any */,
                                                  dark: ColorValue(0x8B2323) /* dangerTint20.dark */),
                            selected: DynamicColor(light: ColorValue(0xDD4242) /* dangerTint10.any */,
                                                   dark: ColorValue(0x8B2323) /* dangerTint20 */),
                            // surfaceQuaternary
                            disabled: DynamicColor(light: ColorValue(0xE1E1E1) /* gray100*/,
                                                   dark: ColorValue(0x404040) /* gray600 */)
                        )
                    }
                }
            case .borderColor:
                return .buttonDynamicColors {
                    switch style() {
                    case .primaryFilled, .dangerFilled, .borderless:
                        return .init(
                            rest: DynamicColor(light: ColorValue.clear),
                            hover: DynamicColor(light: ColorValue.clear),
                            pressed: DynamicColor(light: ColorValue.clear),
                            selected: DynamicColor(light: ColorValue.clear),
                            disabled: DynamicColor(light: ColorValue.clear)
                        )
                    case .primaryOutline, .secondaryOutline, .tertiaryOutline:
                        return .init(
                            rest: theme.aliasTokens.backgroundColors[.brandRest],
                            hover: theme.aliasTokens.backgroundColors[.brandHover],
                            pressed: theme.aliasTokens.backgroundColors[.brandPressed],
                            selected: theme.aliasTokens.backgroundColors[.brandSelected],
                            disabled: theme.aliasTokens.backgroundColors[.brandDisabled]
                        )
                    case .dangerOutline:
                        return .init(
                            // dangerTint10
                            rest: DynamicColor(light: ColorValue(0xDD4242),
                                               dark: ColorValue(0xCC3333)),
                            // dangerTint30
                            hover: DynamicColor(light: ColorValue(0xF4B9B9),
                                                dark: ColorValue(0x461111)),
                            // dangerTint30
                            pressed: DynamicColor(light: ColorValue(0xF4B9B9),
                                                  dark: ColorValue(0x461111)),
                            // dangerTint30
                            selected: DynamicColor(light: ColorValue(0xF4B9B9),
                                                   dark: ColorValue(0x461111)),
                            // surfaceQuaternary
                            disabled: DynamicColor(light: ColorValue(0xE1E1E1) /* gray100*/,
                                                   dark: ColorValue(0x404040) /* gray600 */)
                        )
                    }
                }
            case .borderSize:
                return .float {
                    switch style() {
                    case .primaryFilled, .dangerFilled, .borderless:
                        return GlobalTokens.borderSize(.none)
                    case .primaryOutline, .dangerOutline, .secondaryOutline, .tertiaryOutline:
                        return GlobalTokens.borderSize(.thin)
                    }
                }
            case .cornerRadius:
                return .float {
                    switch style() {
                    case .primaryFilled, .primaryOutline, .dangerFilled, .dangerOutline, .secondaryOutline, .borderless:
                        return GlobalTokens.borderRadius(.large)
                    case .tertiaryOutline:
                        return 5.0
                    }
                }
            case .foregroundColor:
                return .buttonDynamicColors {
                    switch style() {
                    case .primaryFilled, .dangerFilled:
                        return .init(
                            rest: theme.aliasTokens.foregroundColors[.neutralInverted],
                            hover: theme.aliasTokens.foregroundColors[.neutralInverted],
                            pressed: theme.aliasTokens.foregroundColors[.neutralInverted],
                            selected: theme.aliasTokens.foregroundColors[.neutralInverted],
                            disabled: theme.aliasTokens.foregroundColors[.neutralInverted]
                        )
                    case .primaryOutline, .secondaryOutline, .tertiaryOutline, .borderless:
                        return .init(
                            rest: theme.aliasTokens.foregroundColors[.brandRest],
                            hover: theme.aliasTokens.foregroundColors[.brandHover],
                            pressed: theme.aliasTokens.foregroundColors[.brandPressed],
                            selected: theme.aliasTokens.foregroundColors[.brandSelected],
                            disabled: theme.aliasTokens.foregroundColors[.brandDisabled]
                        )
                    case .dangerOutline:
                        return .init(
                            // dangerPrimary
                            rest: DynamicColor(light: ColorValue(0xD92C2C),
                                               dark: ColorValue(0xE83A3A)),
                            // dangerTint20
                            hover: DynamicColor(light: ColorValue(0xE87979),
                                                dark: ColorValue(0x8B2323)),
                            // dangerTint20
                            pressed: DynamicColor(light: ColorValue(0xE87979),
                                                  dark: ColorValue(0x8B2323)),
                            // dangerTint20
                            selected: DynamicColor(light: ColorValue(0xE87979),
                                                   dark: ColorValue(0x8B2323)),
                            // textDisabled
                            disabled: DynamicColor(light: ColorValue(0xACACAC) /* gray300 */,
                                                   lightHighContrast: ColorValue(0x6E6E6E) /* gray500 */,
                                                   dark: ColorValue(0x404040) /* gray600 */,
                                                   darkHighContrast: ColorValue(0x919191) /* gray400 */)
                        )
                    }
                }
            case .titleFont:
                return .fontInfo {
                    switch style() {
                    case .primaryFilled, .primaryOutline, .dangerFilled, .dangerOutline, .borderless:
                        return theme.aliasTokens.typography[.body2]
                    case .secondaryOutline, .tertiaryOutline:
                        return theme.aliasTokens.typography[.caption1]
                    }
                }
            }
        }
    }

    var style: () -> ButtonStyle
}

extension ButtonTokenSet {
    /// The value for the horizontal padding between the content of the button and the frame.
    static func horizontalPadding(_ style: ButtonStyle) -> CGFloat {
        switch style {
        case .dangerFilled, .dangerOutline, .primaryFilled, .primaryOutline:
            return GlobalTokens.spacing(.large)
        case .secondaryOutline:
            return 14.0
        case .borderless:
            return GlobalTokens.spacing(.small)
        case .tertiaryOutline:
            return GlobalTokens.spacing(.xSmall)
        }
    }

    /// The minimum value for the height of the content of the button.
    static func minContainerHeight(_ style: ButtonStyle) -> CGFloat {
        switch style {
        case .borderless, .dangerFilled, .dangerOutline, .primaryFilled, .primaryOutline:
            return 20
        case .secondaryOutline, .tertiaryOutline:
            return 18
        }
    }

    /// The value for the spacing between the title and image.
    static func titleImageSpacing(_ style: ButtonStyle) -> CGFloat {
        switch style {
        case .dangerFilled, .dangerOutline, .primaryFilled, .primaryOutline:
            return 10
        case .secondaryOutline, .borderless:
            return GlobalTokens.spacing(.xSmall)
        case .tertiaryOutline:
            return GlobalTokens.spacing(.none)
        }
    }

    /// The value for the vertical padding between the content of the button and the frame.
    static func verticalPadding(_ style: ButtonStyle) -> CGFloat {
        switch style {
        case .dangerFilled, .dangerOutline, .primaryFilled, .primaryOutline:
            return GlobalTokens.spacing(.medium)
        case .secondaryOutline:
            return 10
        case .borderless:
            return 7
        case .tertiaryOutline:
            return 5
        }
    }
}
