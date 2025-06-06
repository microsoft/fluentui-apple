//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if os(macOS)
import AppKit
private typealias FluentThemeableView = NSView
#else
import UIKit
private typealias FluentThemeableView = UIView
#endif

@objc extension FluentThemeableView: FluentThemeable {
    private struct Keys {
        static var fluentTheme: UInt8 = 0
        static var cachedFluentTheme: UInt8 = 0
    }

    /// The custom `FluentTheme` to apply to this view.
    @objc public var fluentTheme: FluentTheme {
        get {
            var optionalView: FluentThemeableView? = self
            while let view = optionalView {
                // If we successfully find a theme, return it.
                if let theme = objc_getAssociatedObject(view, &Keys.fluentTheme) as? FluentTheme {
                    return theme
                } else {
                    optionalView = view.superview
                }
            }

            // No custom themes anywhere, so return the default theme
            return FluentTheme.shared
        }
        set {
            objc_setAssociatedObject(self, &Keys.fluentTheme, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            NotificationCenter.default.post(name: .didChangeTheme, object: self)
        }
    }

    /// Removes any associated `ColorProvider` from the given `FluentThemeableView`.
    @objc(resetFluentTheme)
    public func resetFluentTheme() {
        objc_setAssociatedObject(self, &Keys.fluentTheme, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        NotificationCenter.default.post(name: .didChangeTheme, object: self)
    }

    @objc(isApplicableThemeChange:)
    public func isApplicableThemeChange(_ notification: Notification) -> Bool {
        // Do not update unless the notification's name is `.didChangeTheme`.
        guard notification.name == .didChangeTheme else {
            return false
        }

        // If there is no object, or it is not a FluentThemeableView, we must assume that we need to update.
        guard let themeView = notification.object as? FluentThemeableView else {
            return true
        }

        // If the object is a FluentThemeableView, we only update if `view` is a descendant thereof.
        return self.isDescendant(of: themeView)
    }
}
