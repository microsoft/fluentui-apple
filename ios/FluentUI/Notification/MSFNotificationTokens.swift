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
        return self == .primaryToast || self == .neutralToast || self == .dangerToast || self == .warningToast
    }

    var needsFullWidth: Bool { return !isToast }
    var needsSeparator: Bool { return  self == .primaryOutlineBar }
    var supportsTitle: Bool { return isToast }
    var supportsImage: Bool { return isToast }
    var shouldAlwaysShowActionButton: Bool { return isToast }
}

class MSFNotificationTokens: MSFTokensBase, ObservableObject {
    @Published public var backgroundColor: UIColor!
    @Published public var foregroundColor: UIColor!
    @Published public var cornerRadius: CGFloat!
    @Published public var presentationOffset: CGFloat!
    @Published public var horizontalPadding: CGFloat!
    @Published public var verticalPadding: CGFloat!
    @Published public var verticalPaddingForOneLine: CGFloat!
    @Published public var horizontalSpacing: CGFloat!
    @Published public var minimumHeight: CGFloat!
    @Published public var minimumHeightForOneLine: CGFloat!
    @Published public var animationDurationForShow: TimeInterval!
    @Published public var animationDurationForHide: TimeInterval!
    @Published public var animationDampingRatio: CGFloat!
    @Published public var shadowColor: CGColor!
    @Published public var shadowBlur: CGFloat!
    @Published public var shadowOffsetX: CGFloat!
    @Published public var shadowOffsetY: CGFloat!

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
            appearanceProxy = currentTheme.MSFPrimaryToastNotificationTokens
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
        animationDurationForShow = TimeInterval(appearanceProxy.animationDurationForShow)
        animationDurationForHide = TimeInterval(appearanceProxy.animationDurationForHide)
        animationDampingRatio = appearanceProxy.animationDampingRatio
        shadowColor = appearanceProxy.shadowColor.cgColor
        shadowBlur = appearanceProxy.shadowBlur
        shadowOffsetX = appearanceProxy.shadowOffsetX
        shadowOffsetY = appearanceProxy.shadowOffsetY
    }
}
