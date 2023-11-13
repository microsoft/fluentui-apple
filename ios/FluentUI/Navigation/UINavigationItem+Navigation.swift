//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc public extension UINavigationItem {
    private struct AssociatedKeys {
        static var accessoryView: UInt8 = 0
        static var titleAccessory: UInt8 = 0
        static var titleImage: UInt8 = 0
        static var topAccessoryView: UInt8 = 0
        static var topAccessoryViewAttributes: UInt8 = 0
        static var contentScrollView: UInt8 = 0
        static var navigationBarStyle: UInt8 = 0
        static var navigationBarShadow: UInt8 = 0
        static var subtitle: UInt8 = 0
        static var titleStyle: UInt8 = 0
        static var customNavigationBarColor: UInt8 = 0
        static var customSubtitleTrailingImage: UInt8 = 0
        static var isTitleImageLeadingForTitleAndSubtitle: UInt8 = 0
    }

    var accessoryView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.accessoryView) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.accessoryView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// Defines an accessory shown after the title or subtitle in a navigation bar. When defined, this gives the indication that the title can be tapped to show additional information.
    var titleAccessory: NavigationBarTitleAccessory? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.titleAccessory) as? NavigationBarTitleAccessory
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.titleAccessory, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// An optional image to show in a navigation bar before the title. Ignored when `titleStyle == .largeLeading`.
    var titleImage: UIImage? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.titleImage) as? UIImage
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.titleImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var topAccessoryView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.topAccessoryView) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.topAccessoryView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var topAccessoryViewAttributes: NavigationBarTopAccessoryViewAttributes? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.topAccessoryViewAttributes) as? NavigationBarTopAccessoryViewAttributes
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.topAccessoryViewAttributes, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var contentScrollView: UIScrollView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.contentScrollView) as? UIScrollView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.contentScrollView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// The style to apply to a navigation bar as a whole. Defaults to `.default` if not specified.
    var navigationBarStyle: NavigationBar.Style {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.navigationBarStyle) as? NavigationBar.Style ?? .default
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.navigationBarStyle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var navigationBarShadow: NavigationBar.Shadow {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.navigationBarShadow) as? NavigationBar.Shadow ?? .automatic
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.navigationBarShadow, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// An optional image to show on the trailing end of the navigation bar's subtitle.
    var customSubtitleTrailingImage: UIImage? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.customSubtitleTrailingImage) as? UIImage
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.customSubtitleTrailingImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// The navigation item's subtitle that displays in the navigation bar.
    var subtitle: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.subtitle) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.subtitle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// The style in which the title text is displayed in a navigation bar. Defaults to `.system` if not specified.
    var titleStyle: NavigationBar.TitleStyle {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.titleStyle) as? NavigationBar.TitleStyle ?? .system
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.titleStyle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// Determines whether the provided `titleImage` is used on the leading end of both the title and subtitle of the navigation bar.
    var isTitleImageLeadingForTitleAndSubtitle: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.isTitleImageLeadingForTitleAndSubtitle) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isTitleImageLeadingForTitleAndSubtitle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @available(*, deprecated, message: "Use `titleStyle` instead")
    var usesLargeTitle: Bool {
        get {
            return titleStyle.usesLeadingAlignment
        }
        set {
            titleStyle = newValue ? .largeLeading : .system
        }
    }

    func navigationBarColor(fluentTheme: FluentTheme) -> UIColor {
        if let customNavigationBarColor = customNavigationBarColor, navigationBarStyle == .custom {
            return customNavigationBarColor
        }

        let style = navigationBarStyle
        let tokenSet = NavigationBarTokenSet { style }
        tokenSet.fluentTheme = fluentTheme
        return tokenSet[.backgroundColor].uiColor
    }

    var customNavigationBarColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.customNavigationBarColor) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.customNavigationBarColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
