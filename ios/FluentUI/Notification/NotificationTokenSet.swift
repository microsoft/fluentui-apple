//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Pre-defined styles of the notification
@objc public enum MSFNotificationStyle: Int, CaseIterable {
    /// Floating notification with brand colored text and background.
    case primaryToast

    /// Floating notification with neutral colored text and background.
    case neutralToast

    /// Bar notification with brand colored text and background.
    case primaryBar

    /// Bar notification with brand colored text and neutral colored background.
    case primaryOutlineBar

    /// Bar notification with neutral colored text and brackground.
    case neutralBar

    /// Floating notification with red text and background.
    case dangerToast

    ///Floating notification with yellow text and background.
    case warningToast

    var isToast: Bool {
        switch self {
        case .primaryToast,
             .neutralToast,
             .dangerToast,
             .warningToast:
            return true
        case .primaryBar,
             .primaryOutlineBar,
             .neutralBar:
            return false
        }
    }

    var animationDurationForShow: TimeInterval { return isToast ? Constants.animationDurationForShowToast : Constants.animationDurationForShowBar }
    var animationDurationForHide: TimeInterval { return Constants.animationDurationForHide }
    var animationDampingRatio: CGFloat { return isToast ? Constants.animationDampingRatioForToast : 1 }

    var needsFullWidth: Bool { return !isToast }
    var needsSeparator: Bool { return  self == .primaryOutlineBar }
    var supportsTitle: Bool { return isToast }
    var supportsImage: Bool { return isToast }
    var shouldAlwaysShowActionButton: Bool { return isToast }

    private struct Constants {
        static let animationDurationForShowToast: TimeInterval = 0.6
        static let animationDurationForShowBar: TimeInterval = 0.3
        static let animationDurationForHide: TimeInterval = 0.25
        static let animationDampingRatioForToast: CGFloat = 0.5
    }
}

/// Design token set for the `Notification` control.
public class NotificationTokenSet: ControlTokenSet<NotificationTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// The background color of the notification
        case backgroundColor

        /// The color of the notification's foreground elements like text and icons
        case foregroundColor

        /// The color of the notification's icon image
        case imageColor

        /// The value for the corner radius of the frame of the notification
        case cornerRadius

        /// The value for the presentation offset of the notification
        case presentationOffset

        /// The value for the bottom padding between the notification and its anchor view
        case bottomPresentationPadding

        /// The color of the outline around the frame of a notification
        case outlineColor

        /// The width of the outline around the frame of a notification
        case outlineWidth

        /// The `ShadowInfo` for this notification
        case shadow

        /// The font for bold text within a notification
        case boldTextFont

        /// The font for regular text within a notification
        case regularTextFont
    }

    init(style: @escaping () -> MSFNotificationStyle) {
        self.style = style
        super.init { [style] token, theme in
            switch token {
            case .backgroundColor:
                return .dynamicColor {
                    switch style() {
                    case .primaryToast:
                        return theme.aliasTokens.brandColors[.tint40]
                    case .neutralToast:
                        return DynamicColor(light: ColorValue(0xF7F7F7),
                                            dark: ColorValue(0x393939))
                    case .primaryBar:
                        return DynamicColor(light: theme.aliasTokens.brandColors[.tint40].light,
                                            dark: theme.aliasTokens.brandColors[.tint10].dark)
                    case .primaryOutlineBar:
                        return DynamicColor(light: ColorValue(0xFFFFFF),
                                            dark: ColorValue(0x393939))
                    case .neutralBar:
                        return DynamicColor(light: ColorValue(0xDFDFDF),
                                            dark: ColorValue(0x393939))
                    case .dangerToast:
                        return DynamicColor(light: ColorValue(0xFDF6F6),
                                            dark: ColorValue(0x3F1011))
                    case .warningToast:
                        return DynamicColor(light: ColorValue(0xFFFBD6),
                                            dark: ColorValue(0x4C4400))
                    }
                }

            case .foregroundColor:
                return .dynamicColor {
                    switch style() {
                    case .primaryToast:
                        return DynamicColor(light: theme.aliasTokens.brandColors[.shade10].light,
                                            dark: theme.aliasTokens.brandColors[.shade30].dark)
                    case .neutralToast:
                        return DynamicColor(light: ColorValue(0x393939),
                                            dark: ColorValue(0xF7F7F7))
                    case .primaryBar:
                        return DynamicColor(light: theme.aliasTokens.brandColors[.shade20].light,
                                            dark: ColorValue(0x000000))
                    case .primaryOutlineBar:
                        return DynamicColor(light: theme.aliasTokens.brandColors[.primary].light,
                                            dark: ColorValue(0xF7F7F7))
                    case .neutralBar:
                        return DynamicColor(light: ColorValue(0x090909),
                                            dark: ColorValue(0xF7F7F7))
                    case .dangerToast:
                        return DynamicColor(light: ColorValue(0xBC2F34),
                                            dark: ColorValue(0xDC5F63))
                    case .warningToast:
                        return DynamicColor(light: ColorValue(0x4C4400),
                                            dark: ColorValue(0xFDEA3D))
                    }
                }

            case .imageColor:
                return .dynamicColor {
                    switch style() {
                    case .primaryToast:
                        return DynamicColor(light: theme.aliasTokens.brandColors[.shade10].light,
                                            dark: theme.aliasTokens.brandColors[.shade30].dark)
                    case .neutralToast:
                        return DynamicColor(light: ColorValue(0x393939),
                                            dark: ColorValue(0xF7F7F7))
                    case .primaryBar:
                        return DynamicColor(light: theme.aliasTokens.brandColors[.shade20].light,
                                            dark: ColorValue(0x000000))
                    case .primaryOutlineBar:
                        return DynamicColor(light: theme.aliasTokens.brandColors[.primary].light,
                                            dark: ColorValue(0xF7F7F7))
                    case .neutralBar:
                        return DynamicColor(light: ColorValue(0x090909),
                                            dark: ColorValue(0xF7F7F7))
                    case .dangerToast:
                        return DynamicColor(light: ColorValue(0xBC2F34),
                                            dark: ColorValue(0xDC5F63))
                    case .warningToast:
                        return DynamicColor(light: ColorValue(0x4C4400),
                                            dark: ColorValue(0xFDEA3D))
                    }
                }

            case .cornerRadius:
                return .float {
                    switch style().isToast {
                    case true:
                        return GlobalTokens.borderRadius(.xLarge)
                    case false:
                        return GlobalTokens.borderSize(.none)
                    }
                }

            case .presentationOffset:
                return .float {
                    switch style().isToast {
                    case true:
                        return GlobalTokens.spacing(.medium)
                    case false:
                        return GlobalTokens.spacing(.none)
                    }
                }

            case .bottomPresentationPadding:
                return .float { GlobalTokens.spacing(.medium) }

            case .outlineColor:
                return .dynamicColor {
                    switch style() {
                    case .primaryToast, .neutralToast, .primaryBar, .neutralBar, .dangerToast, .warningToast:
                        return DynamicColor(light: ColorValue.clear)
                    case .primaryOutlineBar:
                        return theme.aliasTokens.strokeColors[.neutral2]
                    }
                }

            case .outlineWidth:
                return .float { GlobalTokens.borderSize(.thin) }

            case .shadow:
                return .shadowInfo {
                    if style().isToast {
                        return theme.aliasTokens.shadow[.shadow16]
                    } else {
                        return theme.aliasTokens.shadow[.clear]
                    }
                }

            case .boldTextFont:
                return .fontInfo { theme.aliasTokens.typography[.body2Strong] }

            case .regularTextFont:
                return .fontInfo { theme.aliasTokens.typography[.body2] }
            }
        }
    }

    /// Defines the style of the notification.
    var style: () -> MSFNotificationStyle
}
