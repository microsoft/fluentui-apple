//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import UIKit

/// An object used to store configuration information used by FluentUI when styling a `UINavigationItem`.
@objc(MSFFluentNavigationItemConfiguration)
@objcMembers public class FluentNavigationItemConfiguration: NSObject {
    public dynamic var accessoryView: UIView?
    /// An wide accessory view that can be shown as a subview of ShyHeaderView but doesn't have leading, trailing
    /// and bottom insets. So it can appear as being part of the content view but still contract and expand as part of
    /// the shy header.
    public dynamic var secondaryAccessoryView: UIView?

    /// Defines an accessory shown after the title or subtitle in a navigation bar. When defined, this gives the indication that the title can be tapped to show additional information.
    public dynamic var titleAccessory: NavigationBarTitleAccessory?

    /// An optional image to show in a navigation bar before the title. Ignored when `titleStyle == .largeLeading`.
    public dynamic var titleImage: UIImage?

    public dynamic var topAccessoryView: UIView?

    public dynamic var topAccessoryViewAttributes: NavigationBarTopAccessoryViewAttributes?

    public dynamic var contentScrollView: UIScrollView?

    /// The style to apply to a navigation bar as a whole. Defaults to `.default` if not specified.
    public dynamic var navigationBarStyle: NavigationBar.Style = .default

    public dynamic var navigationBarShadow: NavigationBar.Shadow = .automatic

    /// An optional image to show on the trailing end of the navigation bar's subtitle.
    public dynamic var customSubtitleTrailingImage: UIImage?

    /// The navigation item's subtitle that displays in the navigation bar.
    @available(iOS, deprecated: 26.0, message: "Use the subtitle property on UINavigationItem directly.")
    @available(visionOS, introduced: 1.0)
    @available(macCatalyst, deprecated: 26.0, message: "Use the subtitle property on UINavigationItem directly.")
    public dynamic var subtitle: String?

    /// The style in which the title text is displayed in a navigation bar. Defaults to `.system` if not specified.
    public dynamic var titleStyle: NavigationBar.TitleStyle = .system

    /// Determines whether the provided `titleImage` is used on the leading end of both the title and subtitle of the navigation bar.
    public dynamic var isTitleImageLeadingForTitleAndSubtitle: Bool = false

    @available(*, deprecated, message: "Use `titleStyle` instead")
    public dynamic var usesLargeTitle: Bool {
        get {
            return titleStyle.usesLeadingAlignment
        }
        set {
            titleStyle = newValue ? .largeLeading : .system
        }
    }

    public func navigationBarColor(fluentTheme: FluentTheme) -> UIColor {
        if let customNavigationBarColor = customNavigationBarColor, navigationBarStyle == .custom {
            return customNavigationBarColor
        }

        let style = navigationBarStyle
        let tokenSet = NavigationBarTokenSet { style }
        tokenSet.fluentTheme = fluentTheme
        return tokenSet[.backgroundColor].uiColor
    }

    public dynamic var customNavigationBarColor: UIColor?
}

@objc extension UINavigationItem {
    /// The object used to store configuration information used by FluentUI when styling this `UINavigationItem`.
    public dynamic var fluentConfiguration: FluentNavigationItemConfiguration {
        var configuration = objc_getAssociatedObject(self, &Self.fluentNavigationItemKey) as? FluentNavigationItemConfiguration
        if configuration == nil {
            configuration = FluentNavigationItemConfiguration()
            objc_setAssociatedObject(self, &Self.fluentNavigationItemKey, configuration, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        guard let configuration else {
            preconditionFailure("Unable to allocate FluentNavigationItem")
        }
        return configuration
    }

    private static var fluentNavigationItemKey: UInt8 = 0
}
