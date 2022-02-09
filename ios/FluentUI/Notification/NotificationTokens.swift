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
    /// Creates an instance of `NotificationTokens`.
    public override required init() {
        self.style = .primaryToast
        super.init()
    }

    public init (style: MSFNotificationStyle,
                 backgroundColor: DynamicColor? = nil,
                 foregroundColor: DynamicColor? = nil,
                 cornerRadius: CGFloat? = nil,
                 presentationOffset: CGFloat? = nil,
                 horizontalPadding: CGFloat? = nil,
                 verticalPadding: CGFloat? = nil,
                 verticalPaddingForOneLine: CGFloat? = nil,
                 horizontalSpacing: CGFloat? = nil,
                 minimumHeight: CGFloat? = nil,
                 minimumHeightForOneLine: CGFloat? = nil,
                 outlineColor: DynamicColor? = nil,
                 outlineWidth: CGFloat? = nil,
                 perimeterShadowColor: DynamicColor? = nil,
                 perimeterShadowBlur: CGFloat? = nil,
                 perimeterShadowOffsetX: CGFloat? = nil,
                 perimeterShadowOffsetY: CGFloat? = nil,
                 ambientShadowColor: DynamicColor? = nil,
                 ambientShadowBlur: CGFloat? = nil,
                 ambientShadowOffsetX: CGFloat? = nil,
                 ambientShadowOffsetY: CGFloat? = nil,
                 boldTextFont: FontInfo? = nil,
                 regularTextFont: FontInfo? = nil,
                 footnoteTextFont: FontInfo? = nil) {
        self.style = style
        super.init()

        // Overrides
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
        if let foregroundColor = foregroundColor {
            self.foregroundColor = foregroundColor
        }
        if let cornerRadius = cornerRadius {
            self.cornerRadius = cornerRadius
        }
        if let presentationOffset = presentationOffset {
            self.presentationOffset = presentationOffset
        }
        if let horizontalPadding = horizontalPadding {
            self.horizontalPadding = horizontalPadding
        }
        if let verticalPadding = verticalPadding {
            self.verticalPadding = verticalPadding
        }
        if let verticalPaddingForOneLine = verticalPaddingForOneLine {
            self.verticalPaddingForOneLine = verticalPaddingForOneLine
        }
        if let horizontalSpacing = horizontalSpacing {
            self.horizontalSpacing = horizontalSpacing
        }
        if let minimumHeight = minimumHeight {
            self.minimumHeight = minimumHeight
        }
        if let minimumHeightForOneLine = minimumHeightForOneLine {
            self.minimumHeightForOneLine = minimumHeightForOneLine
        }
        if let outlineColor = outlineColor {
            self.outlineColor = outlineColor
        }
        if let outlineWidth = outlineWidth {
            self.outlineWidth = outlineWidth
        }
        if let ambientShadowColor = ambientShadowColor {
            self.ambientShadowColor = ambientShadowColor
        }
        if let ambientShadowBlur = ambientShadowBlur {
            self.ambientShadowBlur = ambientShadowBlur
        }
        if let ambientShadowOffsetX = ambientShadowOffsetX {
            self.ambientShadowOffsetX = ambientShadowOffsetX
        }
        if let ambientShadowOffsetY = ambientShadowOffsetY {
            self.ambientShadowOffsetY = ambientShadowOffsetY
        }
        if let perimeterShadowColor = perimeterShadowColor {
            self.perimeterShadowColor = perimeterShadowColor
        }
        if let perimeterShadowBlur = perimeterShadowBlur {
            self.perimeterShadowBlur = perimeterShadowBlur
        }
        if let perimeterShadowOffsetX = perimeterShadowOffsetX {
            self.perimeterShadowOffsetX = perimeterShadowOffsetX
        }
        if let perimeterShadowOffsetY = perimeterShadowOffsetY {
            self.perimeterShadowOffsetY = perimeterShadowOffsetY
        }
        if let boldTextFont = boldTextFont {
            self.boldTextFont = boldTextFont
        }
        if let regularTextFont = regularTextFont {
            self.regularTextFont = regularTextFont
        }
        if let footnoteTextFont = footnoteTextFont {
            self.footnoteTextFont = footnoteTextFont
        }
    }

    var style: MSFNotificationStyle

    lazy var backgroundColor: DynamicColor = {
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
    }()

    lazy var foregroundColor: DynamicColor = {
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
    }()

    lazy var cornerRadius: CGFloat = {
        switch style.isToast {
        case true:
            return globalTokens.borderRadius[.xLarge]
        case false:
            return globalTokens.borderSize[.none]
        }
    }()

    lazy var presentationOffset: CGFloat = {
        switch style.isToast {
        case true:
            return globalTokens.spacing[.medium]
        case false:
            return globalTokens.spacing[.none]
        }
    }()

    lazy var horizontalPadding: CGFloat = 19.0
    lazy var verticalPadding: CGFloat = 14.0
    lazy var verticalPaddingForOneLine: CGFloat = 18.0
    lazy var horizontalSpacing: CGFloat = 19.0
    lazy var minimumHeight: CGFloat = 64.0
    lazy var minimumHeightForOneLine: CGFloat = 56.0

    lazy var outlineColor: DynamicColor = {
        switch style {
        case .primaryToast, .neutralToast, .primaryBar, .neutralBar, .dangerToast, .warningToast:
            return DynamicColor(light: ColorValue.clear)
        case .primaryOutlineBar:
            return aliasTokens.strokeColors[.neutral1]
        }
    }()

    lazy var outlineWidth: CGFloat = globalTokens.borderSize[.thin]

    lazy var ambientShadowColor: DynamicColor = {
        switch style.isToast {
        case true:
            return aliasTokens.shadow[.shadow16].colorOne
        case false:
            return DynamicColor(light: ColorValue.clear)
        }
    }()

    lazy var ambientShadowBlur: CGFloat = aliasTokens.shadow[.shadow16].blurOne
    lazy var ambientShadowOffsetX: CGFloat = aliasTokens.shadow[.shadow16].xOne
    lazy var ambientShadowOffsetY: CGFloat = aliasTokens.shadow[.shadow16].yOne

    lazy var perimeterShadowColor: DynamicColor = {
        switch style.isToast {
        case true:
            return aliasTokens.shadow[.shadow16].colorTwo
        case false:
            return DynamicColor(light: ColorValue.clear)
        }
    }()

    lazy var perimeterShadowBlur: CGFloat = aliasTokens.shadow[.shadow16].blurTwo
    lazy var perimeterShadowOffsetX: CGFloat = aliasTokens.shadow[.shadow16].xTwo
    lazy var perimeterShadowOffsetY: CGFloat = aliasTokens.shadow[.shadow16].yTwo
    lazy var boldTextFont: FontInfo = aliasTokens.typography[.body2Strong]
    lazy var regularTextFont: FontInfo = aliasTokens.typography[.body2]
    lazy var footnoteTextFont: FontInfo = aliasTokens.typography[.caption1]
}
