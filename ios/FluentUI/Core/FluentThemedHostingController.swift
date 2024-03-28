//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

extension UIView {

    /// Associated keys created for the added UIView stored properties.
    struct AssociatedKeys {
        static var shouldUseZeroEdgeInsets: UInt8 = 0
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

/// FluentUI specific implementation of the UIHostingController. This is primarily useful for adding `FluentTheme` observation
/// to any wrapped Fluent controls. Additionally, this class adds a workaround for disabling safeAreaInsets for its view on iOS 15.
open class FluentThemedHostingController: UIHostingController<AnyView> {

    @MainActor required dynamic public override init(rootView: AnyView) {
        controlView = rootView
        super.init(rootView: rootView)

        // We need to observe theme changes, and use them to update our wrapped control.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)

        // Set the initial appearance of our control.
        updateRootView()
    }

    @MainActor required dynamic public init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    open override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent != nil {
            updateRootView()
        }
    }

    /// iOS 15.0 fix for UIHostingController that does not automatically resize to hug subviews
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        view.setNeedsUpdateConstraints()
    }

    // MARK: - Theme management

    @objc private func themeDidChange(_ notification: Notification) {
        guard FluentTheme.isApplicableThemeChange(notification, for: self.view) else {
            return
        }
        updateRootView()
    }

    private func updateRootView() {
        self.rootView = AnyView(
            controlView
                .fluentTheme(view.fluentTheme)
                .onAppear { [weak self] in
                    // We don't usually have a window at construction time, so fetch our
                    // custom theme during `onAppear`
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.updateRootView()
                }
            )
    }

    private var controlView: AnyView
}

// MARK: - Safe Area Inset swizzling

extension FluentThemedHostingController {
    /// Static constant that will be guaranteed to have its initialization executed only once during the lifetime of the application.
    private static let swizzleSafeAreaInsetsOnce: Void = {
        // A FluentUIHostingController instance needs to be created so that the class type for the private UIHostingViewwe can be retrived.
        let hostingControllerViewClass: AnyClass = FluentThemedHostingController(rootView: AnyView(EmptyView())).view.classForCoder

        guard let originalMethod = class_getInstanceMethod(hostingControllerViewClass, #selector(getter: UIView.safeAreaInsets)),
              let swizzledMethod = class_getInstanceMethod(hostingControllerViewClass, #selector(getter: UIView.customSafeAreaInsets)) else {
                  preconditionFailure("UIHostingController zeroSafeAreaInsets swizzling failed.")
              }

        method_exchangeImplementations(originalMethod, swizzledMethod)
    }()

    /// Disables the UIHostingController's view safe area insets by swizzling the UIView.safeAreaInsets property and returning UIEdgeInsets.zero if the UIView.shouldUseZeroEdgeInsets is true.
    /// This is a known issue and it's currently tracked by Radar bug FB8176223 - https://openradar.appspot.com/FB8176223
    func disableSafeAreaInsets() {
        // We no longer need the workarounds from `FluentUIHostingController` in
        // iOS 16, but we still need it for 14 and 15.
        if #unavailable(iOS 16) {
            view.shouldUseZeroEdgeInsets = true
            _ = FluentThemedHostingController.swizzleSafeAreaInsetsOnce
        } else {
            sizingOptions = [.intrinsicContentSize]
        }
    }
}
