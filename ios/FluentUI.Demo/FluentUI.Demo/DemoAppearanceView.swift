//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI

struct DemoAppearanceView: View {

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
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

            Text("Control")
                .font(.headline)

            Toggle(isOn: $configuration.themeWideOverride) {
                Text("Theme-wide override")
            }
            .disabled(configuration.onThemeWideOverrideChanged == nil)
            Toggle(isOn: $configuration.perControlOverride) {
                Text("Per-control override")
            }
            .disabled(configuration.onPerControlOverrideChanged == nil)

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
            }
            .onAppear {
                configuration.theme = currentDemoListViewController?.theme ?? .default
            }
    }

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

    private func onThemeChanged(_ theme: DemoColorTheme) {
        guard let currentDemoListViewController = currentDemoListViewController,
              let window = firstWindow else {
                  return
              }
        currentDemoListViewController.updateColorProviderFor(window: window, theme: theme)
    }

    class Configuration: ObservableObject {
        // Data
        @Published var colorScheme: ColorScheme = .light
        @Published var theme: DemoColorTheme = .default
        @Published var themeWideOverride: Bool = false
        @Published var perControlOverride: Bool = false

        // Callbacks
        var onThemeWideOverrideChanged: ((_ themeWideOverrideEnabled: Bool) -> Void)?
        var onPerControlOverrideChanged: ((_ perControlOverrideEnabled: Bool) -> Void)?
    }

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
