//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

extension UIView {

    /// Associated keys created for the added UIView stored properties.
    struct AssociatedKeys {
        static var shouldUseZeroEdgeInsets: String = "shouldUseZeroEdgeInsets"
    }

    /// Adds a stored property to the UIView that defines whether the UIView should return UIEdgeInsets.zero from its safeAreaInsets property.
    /// This property is intended to be used by the UIHostingView class, which is a private subclass of UIView in the SwiftUI Framework.
    var shouldUseZeroEdgeInsets: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.shouldUseZeroEdgeInsets) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.shouldUseZeroEdgeInsets, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// Computed property that will be swizzled with UIView.safeAreaInsets by exchange of implementations.
    /// This swizzling is meant to be used in UIHostingView instances which are private in the SwiftUI framework.
    /// Do not call this property getter directly.
    @objc var customSafeAreaInsets: UIEdgeInsets {
        if shouldUseZeroEdgeInsets {
            return .zero
        }

        // Because this property will be swizzled with UIView.safeAreaInsets by exchanging
        // implementations, this call makes sure to call it by this property's name which
        // will contain the original implementation of UIView.safeAreaInsets.
        return self.customSafeAreaInsets
    }
}

/// FluentUI specific implementation of the UIHostingController which adds a workaround for disabling safeAreaInsets for its view.
class FluentUIHostingController: UIHostingController<AnyView> {

    /// Static constant that will be guaranteed to have its initialization executed only once during the lifetime of the application.
    private static let swizzleSafeAreaInsetsOnce: Void = {
        // A FluentUIHostingController instance needs to be created so that the class type for the private UIHostingViewwe can be retrived.
        let hostingControllerViewClass: AnyClass = FluentUIHostingController(rootView: AnyView(EmptyView())).view.classForCoder

        guard let originalMethod = class_getInstanceMethod(hostingControllerViewClass, #selector(getter: UIView.safeAreaInsets)),
              let swizzledMethod = class_getInstanceMethod(hostingControllerViewClass, #selector(getter: UIView.customSafeAreaInsets)) else {
                  preconditionFailure("UIHostingController zeroSafeAreaInsets swizzling failed.")
              }

        method_exchangeImplementations(originalMethod, swizzledMethod)
    }()

    /// Disables the UIHostingController's view safe area insets by swizzling the UIView.safeAreaInsets property and returning UIEdgeInsets.zero if the UIView.shouldUseZeroEdgeInsets is true.
    /// This is a known issue and it's currently tracked by Radar bug FB8176223 - https://openradar.appspot.com/FB8176223
    func disableSafeAreaInsets() {
        view.shouldUseZeroEdgeInsets = true
        _ = FluentUIHostingController.swizzleSafeAreaInsetsOnce
    }
}
