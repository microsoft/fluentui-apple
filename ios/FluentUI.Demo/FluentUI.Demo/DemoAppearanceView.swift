//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI

struct DemoAppearanceView: View {

    @Environment(\.colorScheme) var systemColorScheme: ColorScheme

    @ObservedObject var configuration: Configuration

    /// Picker for setting the app's color scheme.
    @ViewBuilder
    var appColorSchemePicker: some View {
        Text("App Color Scheme")
            .font(.headline)
        Picker("Color Scheme", selection: $configuration.colorScheme) {
            Text("Light").tag(ColorScheme.light)
            Text("Dark").tag(ColorScheme.dark)
        }
        .pickerStyle(.segmented)
    }

    /// Picker for setting the current Fluent theme.
    @ViewBuilder
    var themePicker: some View {
        Text("Theme")
            .font(.headline)
        Picker("Theme", selection: $configuration.theme) {
            Text("\(DemoColorTheme.default.name)").tag(DemoColorTheme.default)
            Text("\(DemoColorTheme.green.name)").tag(DemoColorTheme.green)
        }
        .pickerStyle(.segmented)
    }

    /// Collects the various pickers and toggles together.
    @ViewBuilder
    var contents: some View {
        VStack {
            appColorSchemePicker
            FluentDivider()
                .padding()

            themePicker
            FluentDivider()
                .padding()

            if showThemeWideOverrideToggle || showPerControlOverrideToggle {
                Text("Control")
                    .font(.headline)
            }

            // Theme-wide override toggle
            if showThemeWideOverrideToggle {
                FluentUIDemoToggle(titleKey: "Theme-wide override", isOn: $configuration.themeWideOverride)
            }

            // Per-control override toggle
            if showPerControlOverrideToggle {
                FluentUIDemoToggle(titleKey: "Per-control override", isOn: $configuration.perControlOverride)
            }

            Spacer()
        }
    }

    var body: some View {
        contents
            .padding()

            // Changes
            .onChange(of: configuration.colorScheme) { newValue in
                onColorSchemeChanged(newValue)
            }
            .onChange(of: configuration.theme) { newValue in
                onThemeChanged(newValue)
            }
            .onChange(of: configuration.themeWideOverride) { newValue in
                configuration.onThemeWideOverrideChanged?(newValue)
            }
            .onChange(of: configuration.perControlOverride) { newValue in
                configuration.onPerControlOverrideChanged?(newValue)
            }

            // Updates on appear
            .onAppear {
                configuration.colorScheme = systemColorScheme
                configuration.theme = currentDemoListViewController?.theme ?? .default
                if let isThemeOverrideEnabled = configuration.themeOverridePreviouslyApplied {
                    configuration.themeWideOverride = isThemeOverrideEnabled()
                }
            }
    }

    /// Container class for data and control-specific callbacks.
    class Configuration: ObservableObject {
        // Data
        @Published var colorScheme: ColorScheme = .light
        @Published var theme: DemoColorTheme = .default
        @Published var themeWideOverride: Bool = false
        @Published var perControlOverride: Bool = false

        // Callbacks
        var onThemeWideOverrideChanged: ((_ themeWideOverrideEnabled: Bool) -> Void)?
        var onPerControlOverrideChanged: ((_ perControlOverrideEnabled: Bool) -> Void)?
        var themeOverridePreviouslyApplied: (() -> Bool)?
    }

    /// Callback for handling color scheme changes.
    private func onColorSchemeChanged(_ colorScheme: ColorScheme) {
        guard let window = firstWindow else {
            return
        }
        let userInterfaceStyle: UIUserInterfaceStyle
        switch colorScheme {
        case .light:
            userInterfaceStyle = .light
        case .dark:
            userInterfaceStyle = .dark
        @unknown default:
            preconditionFailure("Unknown color scheme: \(colorScheme)")
        }
        window.overrideUserInterfaceStyle = userInterfaceStyle
    }

    /// Callback for handling theme changes.
    private func onThemeChanged(_ theme: DemoColorTheme) {
        guard let currentDemoListViewController = currentDemoListViewController,
              let window = firstWindow else {
                  return
              }
        currentDemoListViewController.updateColorProviderFor(window: window, theme: theme)
    }

    private var showThemeWideOverrideToggle: Bool {
        return configuration.onThemeWideOverrideChanged != nil && configuration.themeOverridePreviouslyApplied != nil
    }

    private var showPerControlOverrideToggle: Bool {
        return configuration.onPerControlOverrideChanged != nil
    }

    // MARK: Helpers for accessing the surrounding UIKit environment.

    private var firstWindow: UIWindow? { UIApplication.shared.windows.first }

    private var currentDemoListViewController: DemoListViewController? {
        guard let navigationController = firstWindow?.rootViewController as? UINavigationController,
              let currentDemoListViewController = navigationController.viewControllers.first as? DemoListViewController else {
                  return nil
              }
        return currentDemoListViewController
    }
}

/// View modifiers
extension DemoAppearanceView {
    func colorScheme(_ colorScheme: ColorScheme) -> Self {
        self.configuration.colorScheme = colorScheme
        return self
    }

    func theme(_ theme: DemoColorTheme) -> Self {
        self.configuration.theme = theme
        return self
    }
}
