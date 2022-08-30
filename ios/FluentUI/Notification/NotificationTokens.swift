//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Pre-defined styles of the notification
@objc public enum MSFNotificationStyle: Int, CaseIterable {
    /// Floating notification with brand colored text and background.
    case accentToast

    /// Floating notification with neutral colored text and background.
    case neutralToast

    /// Bar notification with brand colored text and background.
    case accentBar

    /// Bar notification with brand colored text and neutral colored background.
    case subtleBar

    /// Bar notification with neutral colored text and brackground.
    case neutralBar

    /// Floating notification with red text and background.
    case dangerToast

    ///Floating notification with yellow text and background.
    case warningToast

    var isToast: Bool {
        switch self {
        case .accentToast,
             .neutralToast,
             .dangerToast,
             .warningToast:
            return true
        case .accentBar,
             .subtleBar,
             .neutralBar:
            return false
        }
    }

    var animationDurationForShow: TimeInterval { return isToast ? Constants.animationDurationForShowToast : Constants.animationDurationForShowBar }
    var animationDurationForHide: TimeInterval { return Constants.animationDurationForHide }
    var animationDampingRatio: CGFloat { return isToast ? Constants.animationDampingRatioForToast : 1 }

    private struct Constants {
        static let animationDurationForShowToast: TimeInterval = 0.6
        static let animationDurationForShowBar: TimeInterval = 0.3
        static let animationDurationForHide: TimeInterval = 0.25
        static let animationDampingRatioForToast: CGFloat = 0.5
    }
}

/// Design token set for the `Notification` control.
open class NotificationTokens: ControlTokens {
    /// Defines the style of the notification.
    public internal(set) var style: MSFNotificationStyle = .accentToast

    // MARK: - Design Tokens

    /// The background color of the notification
    open var backgroundColor: DynamicColor {
        switch style {
        case .accentToast:
            return aliasTokens.brandColors[.tint40]
        case .neutralToast:
            return DynamicColor(light: ColorValue(0xF7F7F7),
                                dark: ColorValue(0x393939))
        case .accentBar:
            return DynamicColor(light: aliasTokens.brandColors[.tint40].light,
                                dark: aliasTokens.brandColors[.tint10].dark)
        case .subtleBar:
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

    /// The color of the notification's foreground elements like text and icons
    open var foregroundColor: DynamicColor {
        switch style {
        case .accentToast:
            return DynamicColor(light: aliasTokens.brandColors[.shade10].light,
                                dark: aliasTokens.brandColors[.shade30].dark)
        case .neutralToast:
            return DynamicColor(light: ColorValue(0x393939),
                                dark: ColorValue(0xF7F7F7))
        case .accentBar:
            return DynamicColor(light: aliasTokens.brandColors[.shade20].light,
                                dark: ColorValue(0x000000))
        case .subtleBar:
            return DynamicColor(light: aliasTokens.brandColors[.primary].light,
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

    /// The color of the notification's icon image
    open var imageColor: DynamicColor {
        switch style {
        case .accentToast:
            return DynamicColor(light: aliasTokens.brandColors[.shade10].light,
                                dark: aliasTokens.brandColors[.shade30].dark)
        case .neutralToast:
            return DynamicColor(light: ColorValue(0x393939),
                                dark: ColorValue(0xF7F7F7))
        case .accentBar:
            return DynamicColor(light: aliasTokens.brandColors[.shade20].light,
                                dark: ColorValue(0x000000))
        case .subtleBar:
            return DynamicColor(light: aliasTokens.brandColors[.primary].light,
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

    /// The value for the corner radius of the frame of the notification
    open var cornerRadius: CGFloat {
        switch style.isToast {
        case true:
            return GlobalTokens.borderRadius(.xLarge)
        case false:
            return GlobalTokens.borderSize(.none)
        }
    }

    /// The value for the presentation offset of the notification
    open var presentationOffset: CGFloat {
        switch style.isToast {
        case true:
            return GlobalTokens.spacing(.medium)
        case false:
            return GlobalTokens.spacing(.none)
        }
    }

    /// The value for the bottom padding between the notification and its anchor view
    open var bottomPresentationPadding: CGFloat { GlobalTokens.spacing(.medium) }
    /// The value for the horizontal padding between the elements within a notification and its frame
    open var horizontalPadding: CGFloat { GlobalTokens.spacing(.medium) }
    /// The value for the vertical padding between the elements within a notification and its frame
    open var verticalPadding: CGFloat { GlobalTokens.spacing(.small) }
    /// The value for the horizontal spacing between the elements within a notification
    open var horizontalSpacing: CGFloat { GlobalTokens.spacing(.medium) }
    /// The value for the minimum height of a notification
    open var minimumHeight: CGFloat { 52.0 }

    /// The color of the outline around the frame of a notification
    open var outlineColor: DynamicColor {
        switch style {
        case .accentToast, .neutralToast, .accentBar, .neutralBar, .dangerToast, .warningToast:
            return DynamicColor(light: ColorValue.clear)
        case .subtleBar:
            return aliasTokens.strokeColors[.neutral2]
        }
    }

    /// The width of the outline around the frame of a notification
    open var outlineWidth: CGFloat { 0.5 }

    /// The color of the ambient shadow around a notification
    open var ambientShadowColor: DynamicColor {
        switch style.isToast {
        case true:
            return aliasTokens.shadow[.shadow16].colorOne
        case false:
            return DynamicColor(light: ColorValue.clear)
        }
    }

    /// The blur amount for the ambient shadow around a notification
    open var ambientShadowBlur: CGFloat { aliasTokens.shadow[.shadow16].blurOne }
    /// The X offset for the ambient shadow around a notification
    open var ambientShadowOffsetX: CGFloat { aliasTokens.shadow[.shadow16].xOne }
    /// The Y offset for the ambient shadow around a notification
    open var ambientShadowOffsetY: CGFloat { aliasTokens.shadow[.shadow16].yOne }

    /// The color of the perimeter shadow around a notification
    open var perimeterShadowColor: DynamicColor {
        switch style.isToast {
        case true:
            return aliasTokens.shadow[.shadow16].colorTwo
        case false:
            return DynamicColor(light: ColorValue.clear)
        }
    }

    /// The blur amount for the perimeter shadow around a notification
    open var perimeterShadowBlur: CGFloat { aliasTokens.shadow[.shadow16].blurTwo }
    /// The X offset for the perimeter shadow around a notification
    open var perimeterShadowOffsetX: CGFloat { aliasTokens.shadow[.shadow16].xTwo }
    /// The Y offset for the perimeter shadow around a notification
    open var perimeterShadowOffsetY: CGFloat { aliasTokens.shadow[.shadow16].yTwo }
    /// The font for bold text within a notification
    open var boldTextFont: FontInfo { aliasTokens.typography[.body2Strong] }
    /// The font for regular text within a notification
    open var regularTextFont: FontInfo { aliasTokens.typography[.body2] }
}
