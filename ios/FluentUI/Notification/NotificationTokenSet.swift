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

        /// The value for the horizontal padding between the elements within a notification and its frame
        case horizontalPadding

        /// The value for the vertical padding between the elements within a multi-line notification and its frame
        case verticalPadding

        /// The value for the horizontal padding between the elements within a single-line notification and its frame
        case verticalPaddingForOneLine

        /// The value for the horizontal spacing between the elements within a notification
        case horizontalSpacing

        /// The value for the minimum height of a multi-line notification
        case minimumHeight

        /// The value for the minimum height of a single-line notification
        case minimumHeightForOneLine

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

        /// The font for footnote text within a notification
        case footnoteTextFont
    }

    init(style: @escaping () -> MSFNotificationStyle) {
        self.style = style
        super.init { [style] token, theme in
            switch token {
            case .backgroundColor:
                return .dynamicColor {
                    switch style() {
                    case .primaryToast:
                        return theme.globalTokens.brandColors[.tint40]
                    case .neutralToast:
                        return DynamicColor(light: ColorValue(0xF7F7F7),
                                            dark: ColorValue(0x393939))
                    case .primaryBar:
                        return DynamicColor(light: theme.globalTokens.brandColors[.tint40].light,
                                            dark: theme.globalTokens.brandColors[.tint10].dark)
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
                        return DynamicColor(light: theme.globalTokens.brandColors[.shade10].light,
                                            dark: theme.globalTokens.brandColors[.shade30].dark)
                    case .neutralToast:
                        return DynamicColor(light: ColorValue(0x393939),
                                            dark: ColorValue(0xF7F7F7))
                    case .primaryBar:
                        return DynamicColor(light: theme.globalTokens.brandColors[.shade20].light,
                                            dark: ColorValue(0x000000))
                    case .primaryOutlineBar:
                        return DynamicColor(light: theme.globalTokens.brandColors[.primary].light,
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
                        return DynamicColor(light: theme.globalTokens.brandColors[.shade10].light,
                                            dark: theme.globalTokens.brandColors[.shade30].dark)
                    case .neutralToast:
                        return DynamicColor(light: ColorValue(0x393939),
                                            dark: ColorValue(0xF7F7F7))
                    case .primaryBar:
                        return DynamicColor(light: theme.globalTokens.brandColors[.shade20].light,
                                            dark: ColorValue(0x000000))
                    case .primaryOutlineBar:
                        return DynamicColor(light: theme.globalTokens.brandColors[.primary].light,
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
                        return theme.globalTokens.borderRadius[.xLarge]
                    case false:
                        return theme.globalTokens.borderSize[.none]
                    }
                }

            case .presentationOffset:
                return .float {
                    switch style().isToast {
                    case true:
                        return theme.globalTokens.spacing[.medium]
                    case false:
                        return theme.globalTokens.spacing[.none]
                    }
                }

            case .bottomPresentationPadding:
                return .float { 20.0 }

            case .horizontalPadding:
                return .float { 19.0 }

            case .verticalPadding:
                return .float { 14.0 }

            case .verticalPaddingForOneLine:
                return .float { 18.0 }

            case .horizontalSpacing:
                return .float { 19.0 }

            case .minimumHeight:
                return .float { 64.0 }

            case .minimumHeightForOneLine:
                return .float { 56.0 }

            case .outlineColor:
                return .dynamicColor {
                    switch style() {
                    case .primaryToast, .neutralToast, .primaryBar, .neutralBar, .dangerToast, .warningToast:
                        return DynamicColor(light: ColorValue.clear)
                    case .primaryOutlineBar:
                        return theme.aliasTokens.strokeColors[.neutral1]
                    }
                }

            case .outlineWidth:
                return .float { theme.globalTokens.borderSize[.thin] }

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

            case .footnoteTextFont:
                return .fontInfo { theme.aliasTokens.typography[.caption1] }
            }
        }
    }

    /// Defines the style of the notification.
    var style: () -> MSFNotificationStyle
}
