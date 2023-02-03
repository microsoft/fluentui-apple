//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import CoreFoundation

/// The predefined states of the `FluentTextField`.
public enum FluentTextFieldState: Int, CaseIterable {
    case unfocused
    case focused
    case error
}

/// Design token set for the `FluentTextField` control.
public class TextFieldTokenSet: ControlTokenSet<TextFieldTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// Defines the color of the text in the bottom label.
        case assistiveTextColor

        /// Defines the font of the  text in the bottom label.
        case assistiveTextFont

        /// Defines the background color of the entire control.
        case backgroundColor

        /// Defines the color of the cursor in the textfield.
        case cursorColor

        /// Defines the color of the input text in the textfield.
        case inputTextColor

        /// Defines the font of the input and placeholder text in the textfield.
        case inputTextFont

        /// Defines the color of the text in the top label.
        case labelColor

        /// Defines the font of the text in the top label.
        case labelFont

        /// Defines the color of the leading image.
        case leadingIconColor

        /// Defines the color of the placeholder text in the textfield.
        case placeholderColor

        /// Defines the color of the separator between the textfield and the bottom lablel
        case strokeColor

        /// Defines the color of the trailing icon in the textfield.
        case trailingIconColor
    }

    init(state: @escaping () -> FluentTextFieldState) {
        self.state = state
        super.init { [state] token, theme in
            switch token {
            case .assistiveTextColor:
                return .dynamicColor {
                    switch state() {
                    case .unfocused, .focused:
                        // Foreground 2
                        return DynamicColor(light: GlobalTokens.neutralColors(.grey38),
                                            dark: GlobalTokens.neutralColors(.grey84))
                    case .error:
                        // Danger foreground 1
                        return DynamicColor(light: GlobalTokens.sharedColors(.red, .shade10),
                                            dark: GlobalTokens.sharedColors(.red, .tint30))
                    }
                }
            case .assistiveTextFont:
                return .fontInfo { theme.aliasTokens.typography[.caption2] }
            case .backgroundColor:
                return .dynamicColor {
                    // Background 1
                    DynamicColor(light: GlobalTokens.neutralColors(.white),
                                 dark: GlobalTokens.neutralColors(.black),
                                 darkElevated: GlobalTokens.neutralColors(.grey4))
                }
            case .cursorColor:
                return .dynamicColor {
                    // Foreground 3
                    DynamicColor(light: GlobalTokens.neutralColors(.grey50),
                                 dark: GlobalTokens.neutralColors(.grey68))
                }
            case .inputTextColor:
                return .dynamicColor {
                    // Foreground 1
                    DynamicColor(light: GlobalTokens.neutralColors(.grey14),
                                 dark: GlobalTokens.neutralColors(.white))
                }
            case .inputTextFont:
                return .fontInfo { theme.aliasTokens.typography[.body1] }
            case .labelColor:
                return .dynamicColor {
                    switch state() {
                    case .unfocused:
                        // Foreground 2
                        return DynamicColor(light: GlobalTokens.neutralColors(.grey38),
                                            dark: GlobalTokens.neutralColors(.grey84))
                    case .focused:
                        return theme.aliasTokens.foregroundColors[.brandRest]
                    case .error:
                        // Danger foreground 1
                        return DynamicColor(light: GlobalTokens.sharedColors(.red, .shade10),
                                            dark: GlobalTokens.sharedColors(.red, .tint30))
                    }
                }
            case .labelFont:
                return .fontInfo { theme.aliasTokens.typography[.caption2] }
            case .leadingIconColor:
                return .dynamicColor {
                    switch state() {
                    case .unfocused, .error:
                        // Foreground 2
                        return DynamicColor(light: GlobalTokens.neutralColors(.grey38),
                                            dark: GlobalTokens.neutralColors(.grey84))
                    case .focused:
                        return theme.aliasTokens.foregroundColors[.brandRest]
                    }
                }
            case .placeholderColor:
                return .dynamicColor {
                    // Foreground 2
                    return DynamicColor(light: GlobalTokens.neutralColors(.grey38),
                                        dark: GlobalTokens.neutralColors(.grey84))
                }
            case .strokeColor:
                return .dynamicColor {
                    switch state() {
                    case .unfocused:
                        // Stroke 1
                        return DynamicColor(light: GlobalTokens.neutralColors(.grey82),
                                            dark: GlobalTokens.neutralColors(.grey30),
                                            darkElevated: GlobalTokens.neutralColors(.grey36))
                    case .focused:
                        return theme.aliasTokens.foregroundColors[.brandRest]
                    case .error:
                        // Danger foreground 1
                        return DynamicColor(light: GlobalTokens.sharedColors(.red, .shade10),
                                            dark: GlobalTokens.sharedColors(.red, .tint30))
                    }
                }
            case .trailingIconColor:
                return .dynamicColor {
                    // Foreground 2
                    return DynamicColor(light: GlobalTokens.neutralColors(.grey38),
                                        dark: GlobalTokens.neutralColors(.grey84))
                }
            }
        }
    }

    var state: () -> FluentTextFieldState
}

extension TextFieldTokenSet {
    /// The value for the size of the leading and trailing icons.
    static func iconSize() -> CGFloat {
        return GlobalTokens.iconSize(.medium)
    }

    /// The value for the padding between the leading and trailing edges of the control and the content.
    static func horizontalPadding() -> CGFloat {
        return GlobalTokens.spacing(.medium)
    }

    /// The value for the padding between the top edge of the control and the content.
    static func topPadding() -> CGFloat {
        return GlobalTokens.spacing(.small)
    }

    /// The value for the padding between the bottom edge of the control and the content.
    static func bottomPadding() -> CGFloat {
        return GlobalTokens.spacing(.xxSmall)
    }

    /// The value for the spacing between the top label and the input or placeholder text.
    static func labelInputTextSpacing() -> CGFloat {
        return GlobalTokens.spacing(.small)
    }

    /// The value for the spacing between the leading icon and the input or placeholder text.
    static func leadingIconInputTextSpacing() -> CGFloat {
        return GlobalTokens.spacing(.medium)
    }

    /// The value for the spacing between the input or placeholder text and the trailing icon.
    static func inputTextTrailingIconSpacing() -> CGFloat {
        return GlobalTokens.spacing(.xSmall)
    }

    /// The value for the spacing between the input or placeholder text and the separator.
    static func inputTextStrokeSpacing() -> CGFloat {
        return GlobalTokens.spacing(.small)
    }

    /// The value for the spacing between the separator and the assistive text label.
    static func strokeAssistiveTextSpacing() -> CGFloat {
        return GlobalTokens.spacing(.xxSmall)
    }
}
