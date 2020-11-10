//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc public extension UINavigationItem {
    private struct AssociatedKeys {
        static var accessoryView: String = "accessoryView"
        static var topAccessoryView: String = "topAccessoryView"
        static var topAccessoryViewAttributes: String = "topAccessoryViewAttributes"
        static var contentScrollView: String = "contentScrollView"
        static var navigationBarStyle: String = "navigationBarStyle"
        static var navigationBarShadow: String = "navigationBarShadow"
        static var usesLargeTitle: String = "usesLargeTitle"
        static var customNavigationBarColor: String = "customNavigationBarColor"
        static var subtitle: String = "subtitle"
        static var expandsNavigationBarOnTitleAreaTap: String = "expandsNavigationBarOnTitleAreaTap"
        static var titleAccessoryType: String = "titleAccessoryType"
        static var subtitleAccessoryType: String = "subtitleAccessoryType"
        static var didTapTitleCallback: String = "didTapTitleCallback"
        static var didTapSubtitleCallback: String = "didTapSubtitleCallback"
    }

    var accessoryView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.accessoryView) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.accessoryView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// Subtitle that will be displayed below the title in the navigation bar.
    /// The subtitle only displays when usesLargeTitle is set to true.
    var subtitle: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.subtitle) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.subtitle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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

    var usesLargeTitle: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.usesLargeTitle) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.usesLargeTitle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func navigationBarColor(for window: UIWindow) -> UIColor {
        return navigationBarStyle.backgroundColor(for: window, customColor: customNavigationBarColor)
    }

    var customNavigationBarColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.customNavigationBarColor) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.customNavigationBarColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// If the shy header behavior is enabled and this property is set to true, tapping on the title will expand the navigation bar.
    var expandsNavigationBarOnTitleAreaTap: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.expandsNavigationBarOnTitleAreaTap) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.expandsNavigationBarOnTitleAreaTap, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// The title's accessory type
    var titleAccessoryType: NavigationBar.TitleAccessoryType {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.titleAccessoryType) as? NavigationBar.TitleAccessoryType ?? NavigationBar.TitleAccessoryType.none
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.titleAccessoryType, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// The subtitle's accessory type
    var subtitleAccessoryType: NavigationBar.TitleAccessoryType {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.subtitleAccessoryType) as? NavigationBar.TitleAccessoryType ?? NavigationBar.TitleAccessoryType.none
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.subtitleAccessoryType, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var didTapTitleCallback: ((_ titleView: UIView) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.didTapTitleCallback) as? ((_: UIView) -> Void)
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.didTapTitleCallback, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    var didTapSubtitleCallback: ((_ subtitleView: UIView) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.didTapSubtitleCallback) as? ((_: UIView) -> Void)
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.didTapSubtitleCallback, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
}
