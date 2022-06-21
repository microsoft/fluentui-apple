//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI
import UIKit

/// Callbacks for changes to a `DemoAppearanceView` via the `DemoAppearanceController`. This delegate should
/// ensure that the appropriate token overrides are set when these callbacks are received.
protocol DemoAppearanceDelegate: NSObjectProtocol {
    /// Notifies the delegate that the control's "theme-wide override" value has changed.
    ///
    /// When this callback is received, the delegate should register a custom token set with the current `FluentTheme`
    /// using the `register(controlType:tokens:)` API.
    ///
    /// - Parameter isOverrideEnabled: Represents the new value for the "theme-wide override" toggle.
    func themeWideOverrideDidChange(isOverrideEnabled: Bool)

    /// Notifies the delegate that the control's "per-control override" value has changed
    ///
    /// When this callback is received, the demo controller in question should iterate through each of its controls and set
    /// a custom token set onto each using its `overrideTokens` property.
    ///
    /// - Parameter isOverrideEnabled: Represents the new value for the "theme-wide override" toggle.
    func perControlOverrideDidChange(isOverrideEnabled: Bool)

    /// Returns whether "theme-wide override" tokens are currently registered for the given control.
    ///
    /// This method, when implemented, should query the current `FluentTheme` using its
    /// `tokenOverride(for:)` API, and return whether a token creation function is returned.
    func isThemeWideOverrideApplied() -> Bool
}

/// Wrapper class to allow presenting of `DemoAppearanceView` from a UIKit host.
class DemoAppearanceController: UIHostingController<DemoAppearanceView>, ObservableObject {
    init(delegate: DemoAppearanceDelegate?) {
        let configuration = DemoAppearanceView.Configuration(delegate: delegate)
        self.configuration = configuration

        super.init(rootView: DemoAppearanceView(configuration: configuration))

        configuration.onThemeChanged = self.onThemeChanged
        configuration.onUserInterfaceStyleChanged = self.onUserInterfaceStyleChanged

        self.modalPresentationStyle = .popover
        self.preferredContentSize.height = 375
        self.popoverPresentationController?.permittedArrowDirections = .up
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateToggleConfiguration()
        configuration.isConfigured = true
    }

    private func updateToggleConfiguration() {
        configuration.userInterfaceStyle = view.window?.overrideUserInterfaceStyle ?? .unspecified
        configuration.theme = currentDemoListViewController?.theme ?? .default
        if let isThemeOverrideEnabled = configuration.themeOverridePreviouslyApplied {
            let newValue = isThemeOverrideEnabled()
            configuration.themeWideOverride = newValue
        }
    }

    /// Callback for handling theme changes.
    private func onThemeChanged(_ theme: DemoColorTheme) {
        guard let currentDemoListViewController = currentDemoListViewController,
              let window = view.window else {
                  return
              }
        currentDemoListViewController.updateColorProviderFor(window: window, theme: theme)

        // Different themes can have different overrides, so update as needed.
        updateToggleConfiguration()
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
