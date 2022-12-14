//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: ButtonStyle

@objc(MSFButtonStyle)
public enum ButtonStyle: Int, CaseIterable {
    case accent
    case outline
    case subtle
    case danger
    case dangerOutline
    case dangerSubtle
}

// MARK: ButtonSize

@objc(MSFButtonSize)
public enum ButtonSize: Int, CaseIterable {
    case large
    case medium
    case small
}

/// Design token set for the `Button` control.
public class ButtonTokenSet: ControlTokenSet<ButtonTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// Defines the background color of the button
        case backgroundColor

        /// Defines the background color of the button when focused
        case backgroundFocusedColor

        /// Defines the background color of the button when disabled
        case backgroundDisabledColor

        /// Defines the background color of the button when pressed
        case backgroundPressedColor

        /// Defines the border color of the button
        case borderColor

        /// Defines the border color of the button when focused
        case borderFocusedColor

        /// Defines the border color of the button when disabled
        case borderDisabledColor

        /// Defines the border color of the button when pressed
        case borderPressedColor

        /// Defines the width of the border around the button
        case borderWidth

        /// Defines the radius of the corners of the button
        case cornerRadius

        /// Defines the colors of the text and icon of the button
        case foregroundColor

        /// Defines the colors of the text and icon of the button when disabled
        case foregroundDisabledColor

        /// Defines the colors of the text and icon of the button when pressed
        case foregroundPressedColor

        /// Defines the font of the title of the button
        case titleFont
    }

    init(style: @escaping () -> ButtonStyle,
         size: @escaping () -> ButtonSize) {
        self.style = style
        self.size = size
        super.init { [style, size] token, theme in
            switch token {
            case .backgroundColor:
                return .dynamicColor {
                    switch style() {
                    case .accent:
                        return theme.aliasTokens.colors[.brandBackground1]
                    case .outline, .subtle, .dangerOutline, .dangerSubtle:
                        return DynamicColor(light: ColorValue.clear)
                    case .danger:
                        return theme.aliasTokens.sharedColors[.dangerBackground2]
                    }
                }
            case .backgroundFocusedColor:
                return .dynamicColor {
                    switch style() {
                    case .accent:
                        return theme.aliasTokens.colors[.brandBackground1Selected]
                    case .outline, .subtle, .dangerOutline, .dangerSubtle:
                        return DynamicColor(light: ColorValue.clear)
                    case .danger:
                        return theme.aliasTokens.sharedColors[.dangerBackground2]
                    }
                }
            case .backgroundDisabledColor:
                return .dynamicColor {
                    switch style() {
                    case .accent, .danger:
                        return theme.aliasTokens.colors[.background5]
                    case .outline, .subtle, .dangerOutline, .dangerSubtle:
                        return DynamicColor(light: ColorValue.clear)
                    }
                }
            case .backgroundPressedColor:
                return .dynamicColor {
                    switch style() {
                    case .accent:
                        return theme.aliasTokens.colors[.brandBackground1Pressed]
                    case .outline, .subtle, .dangerOutline, .dangerSubtle:
                        return DynamicColor(light: ColorValue.clear)
                    case .danger:
                        return theme.aliasTokens.sharedColors[.dangerBackground2]
                    }
                }
            case .borderColor:
                return .dynamicColor {
                    switch style() {
                    case .accent, .subtle, .danger, .dangerSubtle:
                        return DynamicColor(light: ColorValue.clear)
                    case .outline:
                        return theme.aliasTokens.colors[.brandStroke1]
                    case .dangerOutline:
                        return theme.aliasTokens.sharedColors[.dangerForeground2]
                    }
                }
            case .borderFocusedColor:
                return .dynamicColor {
                    switch style() {
                    case .accent, .subtle, .danger, .dangerSubtle:
                        return DynamicColor(light: ColorValue.clear)
                    case .outline:
                        return theme.aliasTokens.colors[.strokeFocus2]
                    case .dangerOutline:
                        return theme.aliasTokens.sharedColors[.dangerForeground2]
                    }
                }
            case .borderDisabledColor:
                return .dynamicColor {
                    switch style() {
                    case .accent, .subtle, .danger, .dangerSubtle:
                        return DynamicColor(light: ColorValue.clear)
                    case .outline, .dangerOutline:
                        return theme.aliasTokens.colors[.strokeDisabled]
                    }
                }
            case .borderPressedColor:
                return .dynamicColor {
                    switch style() {
                    case .accent, .subtle, .danger, .dangerSubtle:
                        return DynamicColor(light: ColorValue.clear)
                    case .outline:
                        return theme.aliasTokens.colors[.brandStroke1Pressed]
                    case .dangerOutline:
                        return theme.aliasTokens.sharedColors[.dangerForeground2]
                    }
                }
            case .borderWidth:
                return .float {
                    switch style() {
                    case .accent, .subtle, .danger, .dangerSubtle:
                        return GlobalTokens.stroke(.widthNone)
                    case .outline, .dangerOutline:
                        return GlobalTokens.stroke(.width10)
                    }
                }
            case .cornerRadius:
                return .float {
                    switch size() {
                    case .large:
                        return GlobalTokens.corner(.radius120)
                    case .medium, .small:
                        return GlobalTokens.corner(.radius80)
                    }
                }
            case .foregroundColor:
                return .dynamicColor {
                    switch style() {
                    case .accent:
                        return theme.aliasTokens.colors[.foregroundOnColor]
                    case .outline, .subtle:
                        return theme.aliasTokens.colors[.brandForeground1]
                    case .danger:
                        return theme.aliasTokens.colors[.foregroundLightStatic]
                    case .dangerOutline, .dangerSubtle:
                        return theme.aliasTokens.sharedColors[.dangerForeground2]
                    }
                }
            case .foregroundDisabledColor:
                return .dynamicColor { theme.aliasTokens.colors[.foregroundDisabled1] }
            case .foregroundPressedColor:
                return .dynamicColor {
                    switch style() {
                    case .accent:
                        return theme.aliasTokens.colors[.foregroundOnColor]
                    case .outline, .subtle:
                        return theme.aliasTokens.colors[.brandForeground1Pressed]
                    case .danger:
                        return theme.aliasTokens.colors[.foregroundLightStatic]
                    case .dangerOutline, .dangerSubtle:
                        return theme.aliasTokens.sharedColors[.dangerForeground2]
                    }
                }
            case .titleFont:
                return .fontInfo {
                    switch size() {
                    case .large:
                        return theme.aliasTokens.typography[.body1Strong]
                    case .medium, .small:
                        return theme.aliasTokens.typography[.caption1Strong]
                    }
                }
            }
        }
    }

    var style: () -> ButtonStyle
    var size: () -> ButtonSize
}

extension ButtonTokenSet {
    /// The value for the horizontal padding between the content of the button and the frame.
    static func horizontalPadding(_ size: ButtonSize) -> CGFloat {
        switch size {
        case .large:
            return GlobalTokens.spacing(.size200)
        case .medium:
            return GlobalTokens.spacing(.size120)
        case .small:
            return GlobalTokens.spacing(.size80)
        }
    }

    /// The minimum value for the height of the content of the button.
    static func minContainerHeight(_ size: ButtonSize) -> CGFloat {
        switch size {
        case .large:
            return 52
        case .medium:
            return 40
        case .small:
            return 28
        }
    }

    /// The value for the spacing between the title and image.
    static func titleImageSpacing(_ size: ButtonSize) -> CGFloat {
        switch size {
        case .large, .medium:
            return GlobalTokens.spacing(.size80)
        case .small:
            return GlobalTokens.spacing(.size40)
        }
    }
}
