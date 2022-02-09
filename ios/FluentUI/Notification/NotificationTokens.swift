//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Pre-defined styles of the notification
@objc public enum MSFNotificationStyle: Int, CaseIterable {
    case primaryToast
    case neutralToast
    case primaryBar
    case primaryOutlineBar
    case neutralBar
    case dangerToast
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

public class NotificationTokens: ControlTokens {
    public internal(set) var style: MSFNotificationStyle = .primaryToast

    open var backgroundColor: DynamicColor {
        switch style {
        case .primaryToast:
            return globalTokens.brandColors[.tint40]
        case .neutralToast:
            return DynamicColor(light: ColorValue(0xF7F7F7), dark: ColorValue(0x393939))
        case .primaryBar:
            return DynamicColor(light: globalTokens.brandColors[.tint40].light, dark: globalTokens.brandColors[.tint10].dark)
        case .primaryOutlineBar:
            return DynamicColor(light: ColorValue(0xFFFFFF), dark: ColorValue(0x393939))
        case .neutralBar:
            return DynamicColor(light: ColorValue(0xDFDFDF), dark: ColorValue(0x393939))
        case .dangerToast:
            return DynamicColor(light: ColorValue(0xFDF6F6), dark: ColorValue(0x3F1011))
        case .warningToast:
            return DynamicColor(light: ColorValue(0xFFFBD6), dark: ColorValue(0x4C4400))
        }
    }

    open var foregroundColor: DynamicColor {
        switch style {
        case .primaryToast:
            return DynamicColor(light: globalTokens.brandColors[.shade10].light, dark: globalTokens.brandColors[.shade30].dark)
        case .neutralToast:
            return DynamicColor(light: ColorValue(0x393939), dark: ColorValue(0xF7F7F7))
        case .primaryBar:
            return DynamicColor(light: globalTokens.brandColors[.shade20].light, dark: ColorValue(0x000000))
        case .primaryOutlineBar:
            return DynamicColor(light: globalTokens.brandColors[.primary].light, dark: ColorValue(0xF7F7F7))
        case .neutralBar:
            return DynamicColor(light: ColorValue(0x090909), dark: ColorValue(0xF7F7F7))
        case .dangerToast:
            return DynamicColor(light: ColorValue(0xBC2F34), dark: ColorValue(0xDC5F63))
        case .warningToast:
            return DynamicColor(light: ColorValue(0x4C4400), dark: ColorValue(0xFDEA3D))
        }
    }

    open var cornerRadius: CGFloat {
        switch style.isToast {
        case true:
            return globalTokens.borderRadius[.xLarge]
        case false:
            return globalTokens.borderSize[.none]
        }
    }

    open var presentationOffset: CGFloat {
        switch style.isToast {
        case true:
            return globalTokens.spacing[.medium]
        case false:
            return globalTokens.spacing[.none]
        }
    }

    open var horizontalPadding: CGFloat = 19.0
    open var verticalPadding: CGFloat = 14.0
    open var verticalPaddingForOneLine: CGFloat = 18.0
    open var horizontalSpacing: CGFloat = 19.0
    open var minimumHeight: CGFloat = 64.0
    open var minimumHeightForOneLine: CGFloat = 56.0

    open var outlineColor: DynamicColor {
        switch style {
        case .primaryToast, .neutralToast, .primaryBar, .neutralBar, .dangerToast, .warningToast:
            return DynamicColor(light: ColorValue.clear)
        case .primaryOutlineBar:
            return aliasTokens.strokeColors[.neutral1]
        }
    }

    open var outlineWidth: CGFloat { globalTokens.borderSize[.thin] }

    open var ambientShadowColor: DynamicColor {
        switch style.isToast {
        case true:
            return aliasTokens.shadow[.shadow16].colorOne
        case false:
            return DynamicColor(light: ColorValue.clear)
        }
    }

    open var ambientShadowBlur: CGFloat { aliasTokens.shadow[.shadow16].blurOne }
    open var ambientShadowOffsetX: CGFloat { aliasTokens.shadow[.shadow16].xOne }
    open var ambientShadowOffsetY: CGFloat { aliasTokens.shadow[.shadow16].yOne }

    open var perimeterShadowColor: DynamicColor {
        switch style.isToast {
        case true:
            return aliasTokens.shadow[.shadow16].colorTwo
        case false:
            return DynamicColor(light: ColorValue.clear)
        }
    }

    open var perimeterShadowBlur: CGFloat { aliasTokens.shadow[.shadow16].blurTwo }
    open var perimeterShadowOffsetX: CGFloat { aliasTokens.shadow[.shadow16].xTwo }
    open var perimeterShadowOffsetY: CGFloat { aliasTokens.shadow[.shadow16].yTwo }
    open var boldTextFont: FontInfo { aliasTokens.typography[.body2Strong] }
    open var regularTextFont: FontInfo { aliasTokens.typography[.body2] }
    open var footnoteTextFont: FontInfo { aliasTokens.typography[.caption1] }
}
