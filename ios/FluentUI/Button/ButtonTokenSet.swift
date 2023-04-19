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
    case floatingAccent
    case floatingSubtle

    public var isFloating: Bool {
        switch self {
        case .floatingAccent, .floatingSubtle:
            return true
        default:
            return false
        }
    }
}

// MARK: ButtonSizeCategory

@objc(MSFButtonSizeCategory)
public enum ButtonSizeCategory: Int, CaseIterable {
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

        /// Defines the shadow of the button
        case shadowRest

        /// Defines the shadow of the button when focused, disabled, or pressed
        case shadowPressed
    }

    init(style: @escaping () -> ButtonStyle,
         size: @escaping () -> ButtonSizeCategory) {
        self.style = style
        self.size = size
        super.init { [style, size] token, theme in
            switch token {
            case .backgroundColor:
                return .uiColor {
                    switch style() {
                    case .accent, .floatingAccent:
                        return theme.color(.brandBackground1)
                    case .outline, .subtle, .dangerOutline, .dangerSubtle:
                        return .clear
                    case .danger:
                        return theme.color(.dangerBackground2)
                    case .floatingSubtle:
                        return theme.color(.background1)
                    }
                }
            case .backgroundFocusedColor:
                return .uiColor {
                    switch style() {
                    case .accent, .floatingAccent:
                        return theme.color(.brandBackground1Selected)
                    case .outline, .subtle, .dangerOutline, .dangerSubtle:
                        return .clear
                    case .danger:
                        return theme.color(.dangerBackground2)
                    case .floatingSubtle:
                        return theme.color(.background1)
                    }
                }
            case .backgroundDisabledColor:
                return .uiColor {
                    switch style() {
                    case .accent, .danger, .floatingAccent, .floatingSubtle:
                        return theme.color(.background5)
                    case .outline, .subtle, .dangerOutline, .dangerSubtle:
                        return .clear
                    }
                }
            case .backgroundPressedColor:
                return .uiColor {
                    switch style() {
                    case .accent, .floatingAccent:
                        return theme.color(.brandBackground1Pressed)
                    case .outline, .subtle, .dangerOutline, .dangerSubtle:
                        return .clear
                    case .danger:
                        return theme.color(.dangerBackground2)
                    case .floatingSubtle:
                        return theme.color(.background1Pressed)
                    }
                }
            case .borderColor:
                return .uiColor {
                    switch style() {
                    case .accent, .subtle, .danger, .dangerSubtle, .floatingAccent, .floatingSubtle:
                        return .clear
                    case .outline:
                        return theme.color(.brandStroke1)
                    case .dangerOutline:
                        return theme.color(.dangerForeground2)
                    }
                }
            case .borderFocusedColor:
                return .uiColor {
                    switch style() {
                    case .accent, .subtle, .danger, .dangerSubtle, .floatingAccent, .floatingSubtle:
                        return .clear
                    case .outline, .dangerOutline:
                        return theme.color(.strokeFocus2)
                    }
                }
            case .borderDisabledColor:
                return .uiColor {
                    switch style() {
                    case .accent, .subtle, .danger, .dangerSubtle, .floatingAccent, .floatingSubtle:
                        return .clear
                    case .outline, .dangerOutline:
                        return theme.color(.strokeDisabled)
                    }
                }
            case .borderPressedColor:
                return .uiColor {
                    switch style() {
                    case .accent, .subtle, .danger, .dangerSubtle, .floatingAccent, .floatingSubtle:
                        return .clear
                    case .outline:
                        return theme.color(.brandStroke1Pressed)
                    case .dangerOutline:
                        return theme.color(.dangerForeground2)
                    }
                }
            case .borderWidth:
                return .float {
                    switch style() {
                    case .accent, .subtle, .danger, .dangerSubtle, .floatingAccent, .floatingSubtle:
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
                return .uiColor {
                    switch style() {
                    case .accent, .floatingAccent:
                        return theme.color(.foregroundOnColor)
                    case .outline, .subtle:
                        return theme.color(.brandForeground1)
                    case .danger:
                        return theme.color(.foregroundLightStatic)
                    case .dangerOutline, .dangerSubtle:
                        return theme.color(.dangerForeground2)
                    case .floatingSubtle:
                        return theme.color(.foreground2)
                    }
                }
            case .foregroundDisabledColor:
                return .uiColor { theme.color(.foregroundDisabled1) }
            case .foregroundPressedColor:
                return .uiColor {
                    switch style() {
                    case .accent, .floatingAccent:
                        return theme.color(.foregroundOnColor)
                    case .outline, .subtle:
                        return theme.color(.brandForeground1Pressed)
                    case .danger:
                        return theme.color(.foregroundLightStatic)
                    case .dangerOutline, .dangerSubtle:
                        return theme.color(.dangerForeground2)
                    case .floatingSubtle:
                        return theme.color(.foreground2)
                    }
                }
            case .titleFont:
                return .uiFont {
                    switch size() {
                    case .large:
                        return theme.typography(.body1Strong, adjustsForContentSizeCategory: !style().isFloating)
                    case .medium, .small:
                        return style().isFloating ? theme.typography(.body2Strong, adjustsForContentSizeCategory: false) : theme.typography(.caption1Strong)
                    }
                }
            case .shadowRest:
                return .shadowInfo { style().isFloating ? theme.shadow(.shadow08) : theme.shadow(.clear) }
            case .shadowPressed:
                return .shadowInfo { style().isFloating ? theme.shadow(.shadow02) : theme.shadow(.clear) }

            }
        }
    }

    var style: () -> ButtonStyle
    var size: () -> ButtonSizeCategory
}

extension ButtonTokenSet {
    /// The value for the horizontal padding between the content of the button and the frame.
    static func horizontalPadding(style: ButtonStyle, size: ButtonSizeCategory) -> CGFloat {
        if style.isFloating {
            switch size {
            case .large:
                return GlobalTokens.spacing(.size160)
            case .medium, .small:
                return GlobalTokens.spacing(.size120)
            }
        } else {
            switch size {
            case .large:
                return GlobalTokens.spacing(.size200)
            case .medium:
                return GlobalTokens.spacing(.size120)
            case .small:
                return GlobalTokens.spacing(.size80)
            }
        }
    }

    /// The value for the right padding between the content of the button and the frame for a FAB button with an icon and text.
    static func fabAlternativePadding(_ size: ButtonSizeCategory) -> CGFloat {
        switch size {
        case .large:
            return GlobalTokens.spacing(.size200)
        case .medium, .small:
            return GlobalTokens.spacing(.size160)
        }
    }

    /// The minimum value for the height of the content of the button.
    static func minContainerHeight(style: ButtonStyle, size: ButtonSizeCategory) -> CGFloat {
        if style.isFloating {
            switch size {
            case .large:
                return 56
            case .medium, .small:
                return 48
            }
        } else {
            switch size {
            case .large:
                return 52
            case .medium:
                return 40
            case .small:
                return 28
            }
        }
    }

    /// The value for the spacing between the title and image.
    static func titleImageSpacing(style: ButtonStyle, size: ButtonSizeCategory) -> CGFloat {
        if style.isFloating {
            return GlobalTokens.spacing(.size80)
        } else {
            switch size {
            case .large, .medium:
                return GlobalTokens.spacing(.size80)
            case .small:
                return GlobalTokens.spacing(.size40)
            }
        }
    }
}
