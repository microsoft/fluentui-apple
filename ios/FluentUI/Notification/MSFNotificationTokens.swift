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

class MSFNotificationTokens: MSFTokensBase {
    public var backgroundColor: UIColor!
    public var foregroundColor: UIColor!
    public var cornerRadius: CGFloat!
    public var presentationOffset: CGFloat!
    public var horizontalPadding: CGFloat!
    public var verticalPadding: CGFloat!
    public var verticalPaddingForOneLine: CGFloat!
    public var horizontalSpacing: CGFloat!
    public var minimumHeight: CGFloat!
    public var minimumHeightForOneLine: CGFloat!
    public var shadowColor: CGColor!
    public var shadowBlur: CGFloat!
    public var shadowOffsetX: CGFloat!
    public var shadowOffsetY: CGFloat!

    var style: MSFNotificationStyle

    init(style: MSFNotificationStyle) {
        self.style = style

        super.init()

        self.themeAware = true
        updateForCurrentTheme()
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }

    override func updateForCurrentTheme() {
        let currentTheme = theme
        var appearanceProxy: AppearanceProxyType

        switch style {
        case .primaryToast:
            appearanceProxy = currentTheme.MSFNotificationTokens
        case .neutralToast:
            appearanceProxy = currentTheme.MSFNeutralToastNotificationTokens
        case .primaryBar:
            appearanceProxy = currentTheme.MSFPrimaryBarNotificationTokens
        case .primaryOutlineBar:
            appearanceProxy = currentTheme.MSFPrimaryOutlineBarNotificationTokens
        case .neutralBar:
            appearanceProxy = currentTheme.MSFNeutralBarNotificationTokens
        case .dangerToast:
            appearanceProxy = currentTheme.MSFDangerToastNotificationTokens
        case .warningToast:
            appearanceProxy = currentTheme.MSFWarningToastNotificationTokens
        }

        backgroundColor = appearanceProxy.backgroundColor
        foregroundColor = appearanceProxy.foregroundColor
        cornerRadius = appearanceProxy.cornerRadius
        presentationOffset = appearanceProxy.presentationOffSet
        horizontalPadding = appearanceProxy.horizontalPadding
        verticalPadding = appearanceProxy.verticalPadding
        verticalPaddingForOneLine = appearanceProxy.verticalPaddingForOneLine
        horizontalSpacing = appearanceProxy.horizontalSpacing
        minimumHeight = appearanceProxy.minimumHeight
        minimumHeightForOneLine = appearanceProxy.minimumHeightForOneLine
        shadowColor = appearanceProxy.shadowColor.cgColor
        shadowBlur = appearanceProxy.shadowBlur
        shadowOffsetX = appearanceProxy.shadowOffsetX
        shadowOffsetY = appearanceProxy.shadowOffsetY
    }
}
