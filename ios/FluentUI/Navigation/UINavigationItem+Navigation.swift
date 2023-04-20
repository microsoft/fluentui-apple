//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc public extension UINavigationItem {
    private struct AssociatedKeys {
        static var accessoryView: String = "accessoryView"
        static var titleAccessory: String = "titleAccessory"
        static var titleImage: String = "titleImage"
        static var topAccessoryView: String = "topAccessoryView"
        static var topAccessoryViewAttributes: String = "topAccessoryViewAttributes"
        static var contentScrollView: String = "contentScrollView"
        static var navigationBarStyle: String = "navigationBarStyle"
        static var navigationBarShadow: String = "navigationBarShadow"
        static var subtitle: String = "subtitle"
        static var titleStyle: String = "titleStyle"
        static var customNavigationBarColor: String = "customNavigationBarColor"
    }

    var accessoryView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.accessoryView) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.accessoryView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var titleAccessory: NavigationBarTitleAccessory? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.titleAccessory) as? NavigationBarTitleAccessory
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.titleAccessory, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

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

    var subtitle: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.subtitle) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.subtitle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var titleStyle: NavigationBar.TitleStyle {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.titleStyle) as? NavigationBar.TitleStyle ?? .system
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.titleStyle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var usesLargeTitle: Bool {
        get {
            assertionFailure("`usesLargeTitle` will be deprecated in a future release. Use `titleStyle` instead.")
            return titleStyle.usesLeadingAlignment
        }
        set {
            assertionFailure("Setting `usesLargeTitle` will be deprecated in a future release. Use `titleStyle` instead.")
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
