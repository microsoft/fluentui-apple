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

        /// Defines the color of the leading image.
        case leadingIconColor

        /// Defines the color of the placeholder text in the textfield.
        case placeholderColor

        /// Defines the color of the separator between the textfield and the bottom lablel
        case strokeColor

        /// Defines the color of the text in the title label.
        case titleLabelColor

        /// Defines the font of the text in the title label.
        case titleLabelFont

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
                        return theme.aliasTokens.colors[.foreground2]
                    case .error:
                        return theme.aliasTokens.colors[.dangerForeground1]
                    }
                }
            case .assistiveTextFont:
                return .fontInfo { theme.aliasTokens.typography[.caption2] }
            case .backgroundColor:
                return .dynamicColor { theme.aliasTokens.colors[.background1] }
            case .cursorColor:
                return .dynamicColor { theme.aliasTokens.colors[.foreground3] }
            case .inputTextColor:
                return .dynamicColor { theme.aliasTokens.colors[.foreground1] }
            case .inputTextFont:
                return .fontInfo { theme.aliasTokens.typography[.body1] }
            case .leadingIconColor:
                return .dynamicColor {
                    switch state() {
                    case .unfocused, .error:
                        return theme.aliasTokens.colors[.foreground2]
                    case .focused:
                        return theme.aliasTokens.colors[.brandForeground1]
                    }
                }
            case .placeholderColor:
                return .dynamicColor { theme.aliasTokens.colors[.foreground2] }
            case .strokeColor:
                return .dynamicColor {
                    switch state() {
                    case .unfocused:
                        return theme.aliasTokens.colors[.stroke1]
                    case .focused:
                        return theme.aliasTokens.colors[.brandForeground1]
                    case .error:
                        return theme.aliasTokens.colors[.dangerForeground1]
                    }
                }
            case .titleLabelColor:
                return .dynamicColor {
                    switch state() {
                    case .unfocused:
                        return theme.aliasTokens.colors[.foreground2]
                    case .focused:
                        return theme.aliasTokens.colors[.brandForeground1]
                    case .error:
                        return theme.aliasTokens.colors[.dangerForeground1]
                    }
                }
            case .titleLabelFont:
                return .fontInfo { theme.aliasTokens.typography[.caption2] }
            case .trailingIconColor:
                return .dynamicColor {
                    return theme.aliasTokens.colors[.foreground2]
                }
            }
        }
    }

    private var state: () -> FluentTextFieldState
}

extension TextFieldTokenSet {
    /// The value for the size of the leading and trailing icons.
    static let iconSize: CGFloat = GlobalTokens.icon(.size240)

    /// The value for the padding between the leading and trailing edges of the control and the content.
    static let horizontalPadding: CGFloat = GlobalTokens.spacing(.size160)

    /// The value for the padding between the top edge of the control and the content.
    static let topPadding: CGFloat = GlobalTokens.spacing(.size120)

    /// The value for the padding between the bottom edge of the control and the content.
    static let bottomPadding: CGFloat = GlobalTokens.spacing(.size40)

    /// The value for the spacing between the title label and the input or placeholder text.
    static let titleInputTextSpacing: CGFloat = GlobalTokens.spacing(.size120)

    /// The value for the spacing between the leading icon and the input or placeholder text.
    static let leadingIconInputTextSpacing: CGFloat = GlobalTokens.spacing(.size160)

    /// The value for the spacing between the input or placeholder text and the trailing icon.
    static let inputTextTrailingIconSpacing: CGFloat = GlobalTokens.spacing(.size80)

    /// The value for the spacing between the input or placeholder text and the separator.
    static let inputTextStrokeSpacing: CGFloat = GlobalTokens.spacing(.size120)

    /// The value for the spacing between the separator and the assistive text label.
    static let strokeAssistiveTextSpacing: CGFloat = GlobalTokens.spacing(.size40)
}
