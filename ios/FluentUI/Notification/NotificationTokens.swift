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
    public internal(set) var style: MSFNotificationStyle = .primaryToast

    // MARK: - Design Tokens

    /// The background color of the notification
    open var backgroundColor: DynamicColor {
        switch style {
        case .primaryToast, .primaryBar:
            return aliasTokens.colors[.brandBackground4]
        case .neutralToast:
            return aliasTokens.colors[.background4]
        case .primaryOutlineBar:
            return aliasTokens.colors[.background1]
        case .neutralBar:
            return aliasTokens.colors[.background5]
        case .dangerToast:
            return aliasTokens.sharedColors[.dangerBackground1]
        case .warningToast:
            return aliasTokens.sharedColors[.warningBackground1]
        }
    }

    /// The color of the notification's foreground elements like text and icons
    open var foregroundColor: DynamicColor {
        switch style {
        case .primaryToast, .primaryBar:
            return aliasTokens.colors[.brandForeground4]
        case .neutralToast, .neutralBar:
            return aliasTokens.colors[.foreground2]
        case .primaryOutlineBar:
            return aliasTokens.colors[.brandForeground1]
        case .dangerToast:
            return aliasTokens.sharedColors[.dangerForeground1]
        case .warningToast:
            return aliasTokens.sharedColors[.warningForeground1]
        }
    }

    /// The color of the notification's icon image
    open var imageColor: DynamicColor {
        return foregroundColor
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
        case .primaryToast, .neutralToast, .primaryBar, .neutralBar, .dangerToast, .warningToast:
            return DynamicColor(light: ColorValue.clear)
        case .primaryOutlineBar:
            return aliasTokens.colors[.stroke2]
        }
    }

    /// The width of the outline around the frame of a notification
    open var outlineWidth: CGFloat { GlobalTokens.borderSize(.thin) }

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
    /// The font for footnote text within a notification
    open var footnoteTextFont: FontInfo { aliasTokens.typography[.caption1] }
}
