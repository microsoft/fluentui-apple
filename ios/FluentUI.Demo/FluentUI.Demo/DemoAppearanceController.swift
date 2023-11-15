//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI
import UIKit

/// Callbacks for changes to a `DemoAppearanceView` via the `DemoAppearanceController`. This delegate should
/// ensure that the appropriate token overrides are set when these callbacks are received.
@objc(MSFDemoAppearanceDelegate)
protocol DemoAppearanceDelegate: NSObjectProtocol {
    /// Notifies the delegate that the control's "theme-wide override" value has changed.
    ///
    /// When this callback is received, the delegate should register a custom token set with the current `FluentTheme`
    /// using the `register(controlType:tokens:)` API.
    ///
    /// - Parameter isOverrideEnabled: Represents the new value for the "theme-wide override" toggle.
    @objc func themeWideOverrideDidChange(isOverrideEnabled: Bool)

    /// Notifies the delegate that the control's "per-control override" value has changed
    ///
    /// When this callback is received, the demo controller in question should iterate through each of its controls and set
    /// a custom token set onto each using its `overrideTokens` property.
    ///
    /// - Parameter isOverrideEnabled: Represents the new value for the "theme-wide override" toggle.
    @objc func perControlOverrideDidChange(isOverrideEnabled: Bool)

    /// Returns whether "theme-wide override" tokens are currently registered for the given control.
    ///
    /// This method, when implemented, should query the current `FluentTheme` using its
    /// `tokens(for:)` API, and return whether a token creation function is returned.
    @objc func isThemeWideOverrideApplied() -> Bool
}

@objc(MSFDemoAppearanceControllerWrapper)
class DemoAppearanceControllerWrapper: NSObject {
    /// Convenience wrapper to allow creation of a `DemoAppearanceController` from Objective-C.
    ///
    /// The class itself cannot be represented via `@objc` because it inherits from `UIHostingController`, which is a Swift-only class.
    /// This workaround allows us to create one anyway, though it will be type-erased to `UIViewController` in the process.
    ///
    /// - Parameter delegate: An optional `DemoAppearanceDelegate` for the created `DemoAppearanceController`.
    ///
    /// - Returns: A new `DemoAppearanceController`, type-erased to `UIViewController`.
    @available(swift, obsoleted: 1.0, message: "This method exists for Objective-C backwards compatibility and should not be invoked from Swift. Please create a `DemoAppearanceController` instance directly.")
    @objc static func createDemoAppearanceController(delegate: DemoAppearanceDelegate?) -> UIViewController {
        return DemoAppearanceController(delegate: delegate)
    }
}

/// Wrapper class to allow presenting of `DemoAppearanceView` from a UIKit host.
class DemoAppearanceController: UIHostingController<DemoAppearanceView>, ObservableObject {
    init(delegate: DemoAppearanceDelegate?) {
        let configuration = DemoAppearanceView.Configuration(delegate: delegate)
        self.configuration = configuration

        super.init(rootView: DemoAppearanceView(configuration: configuration))

        configuration.onWindowThemeChanged = self.onWindowThemeChanged(_:)
        configuration.onAppWideThemeChanged = self.onAppWideThemeChanged(_:)
        configuration.onUserInterfaceStyleChanged = self.onUserInterfaceStyleChanged(_:)

        self.modalPresentationStyle = .popover
        self.preferredContentSize.height = 400
        self.popoverPresentationController?.permittedArrowDirections = .up

        // Different themes can have different overrides, so update our state when we detect a theme change.
        self.themeObserver = NotificationCenter.default.addObserver(forName: .didChangeTheme, object: nil, queue: nil) { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateToggleConfiguration()
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateToggleConfiguration()
        configuration.isConfigured = true
    }

    override func willMove(toParent parent: UIViewController?) {
        guard let parent,
              let window = parent.view.window else {
            return
        }

        rootView.fluentTheme = window.fluentTheme
    }

    private func updateToggleConfiguration() {
        configuration.userInterfaceStyle = view.window?.overrideUserInterfaceStyle ?? .unspecified
        configuration.windowTheme = currentDemoListViewController?.theme ?? .default
        configuration.appWideTheme = DemoColorTheme.currentAppWideTheme
        if let isThemeOverrideEnabled = configuration.themeOverridePreviouslyApplied {
            let newValue = isThemeOverrideEnabled()
            configuration.themeWideOverride = newValue
        }
    }

    /// Callback for handling per-window theme changes.
    private func onWindowThemeChanged(_ theme: DemoColorTheme) {
        guard let currentDemoListViewController = currentDemoListViewController,
              let window = view.window else {
                  return
              }
        currentDemoListViewController.updateColorProviderFor(window: window, theme: theme)

        rootView.fluentTheme = window.fluentTheme
    }

    /// Callback for handling app-wide theme changes
    private func onAppWideThemeChanged(_ theme: DemoColorTheme) {
        DemoColorTheme.currentAppWideTheme = theme
    }

    /// Callback for handling color scheme changes.
    private func onUserInterfaceStyleChanged(_ userInterfaceStyle: UIUserInterfaceStyle) {
        view.window?.overrideUserInterfaceStyle = userInterfaceStyle
    }

    private var currentDemoListViewController: DemoListViewController? {
        guard let navigationController = view.window?.rootViewController as? UINavigationController,
              let currentDemoListViewController = navigationController.viewControllers.first as? DemoListViewController else {
                  return nil
              }
        return currentDemoListViewController
    }

    private var configuration: DemoAppearanceView.Configuration
    private var themeObserver: NSObjectProtocol?
}

extension DemoAppearanceView.Configuration {
    /// Allows `DemoAppearanceView.Configuration` to be initialized with an optional instance of `DemoAppearanceDelegate`.
    convenience init(delegate: DemoAppearanceDelegate?) {
        self.init()

        // Only set up callbacks if we have a valid delegate.
        guard let delegate = delegate else {
            return
        }

        // Capture weak references to the delegate so as not to create retain cycles.
        self.onThemeWideOverrideChanged = { [weak delegate] isOverrideEnabled in
            delegate?.themeWideOverrideDidChange(isOverrideEnabled: isOverrideEnabled)
        }
        self.onPerControlOverrideChanged = { [weak delegate]isOverrideEnabled in
            delegate?.perControlOverrideDidChange(isOverrideEnabled: isOverrideEnabled)
        }
        self.themeOverridePreviouslyApplied = { [weak delegate] in
            delegate?.isThemeWideOverrideApplied() ?? false
        }
    }
}
