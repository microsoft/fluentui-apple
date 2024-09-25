//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI
import UIKit

/// Callbacks for changes to a `DemoAppearanceMenu` via the `DemoAppearanceControlView`. This delegate should
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

/// Wrapper class to allow presenting of `DemoAppearanceMenu` from a UIKit host.
@objc(MSFDemoAppearanceControlView)
class DemoAppearanceControlView: FluentUI.ControlHostingView, ObservableObject {
    @objc(initWithDelegate:)
    init(delegate: DemoAppearanceDelegate?) {
        let configuration = DemoAppearanceMenu.Configuration(delegate: delegate)
        self.configuration = configuration

        super.init(AnyView(DemoAppearanceMenu(configuration: configuration)))

        configuration.onWindowThemeChanged = self.onWindowThemeChanged(_:)
        configuration.onAppWideThemeChanged = self.onAppWideThemeChanged(_:)
        configuration.onUserInterfaceStyleChanged = self.onUserInterfaceStyleChanged(_:)

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

    @MainActor required dynamic init(rootView: AnyView) {
        preconditionFailure("init(rootView:) has not been implemented")
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        updateToggleConfiguration()
    }

    private func updateToggleConfiguration() {
        guard let window else {
            return
        }
        configuration.userInterfaceStyle = window.overrideUserInterfaceStyle
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
              let window else {
            return
        }
        currentDemoListViewController.updateColorProviderFor(window: window, theme: theme)
    }

    /// Callback for handling app-wide theme changes
    private func onAppWideThemeChanged(_ theme: DemoColorTheme) {
        DemoColorTheme.currentAppWideTheme = theme
    }

    /// Callback for handling color scheme changes.
    private func onUserInterfaceStyleChanged(_ userInterfaceStyle: UIUserInterfaceStyle) {
        window?.overrideUserInterfaceStyle = userInterfaceStyle
    }

    private var currentDemoListViewController: DemoListViewController? {
        guard let navigationController = window?.rootViewController as? UINavigationController,
              let currentDemoListViewController = navigationController.viewControllers.first as? DemoListViewController else {
                  return nil
              }
        return currentDemoListViewController
    }

    private var configuration: DemoAppearanceMenu.Configuration
    private var themeObserver: NSObjectProtocol?
}

extension DemoAppearanceMenu.Configuration {
    /// Allows `DemoAppearanceMenu.Configuration` to be initialized with an optional instance of `DemoAppearanceDelegate`.
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
        self.onPerControlOverrideChanged = { [weak delegate] isOverrideEnabled in
            delegate?.perControlOverrideDidChange(isOverrideEnabled: isOverrideEnabled)
        }
        self.themeOverridePreviouslyApplied = { [weak delegate] in
            delegate?.isThemeWideOverrideApplied() ?? false
        }
    }
}
