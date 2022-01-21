//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import FluentUI
import SwiftUI

class DemoAppearanceController: UIHostingController<DemoAppearanceView> {
    convenience init() {
        let callbacks: DemoAppearanceView.Callbacks = .init()
        self.init(rootView: DemoAppearanceView(callbacks: callbacks))
        self.setupCallbacks(callbacks)
    }

    func setupCallbacks(_ callbacks: DemoAppearanceView.Callbacks) {

        // Handled directly
        callbacks.onColorSchemeChanged = { [weak self] colorScheme in
            guard let window = self?.view.window else {
                return
            }
            let userInterfaceStyle: UIUserInterfaceStyle
            switch colorScheme {
            case .auto:
                userInterfaceStyle = .unspecified
            case .light:
                userInterfaceStyle = .light
            case .dark:
                userInterfaceStyle = .dark
            }
            window.overrideUserInterfaceStyle = userInterfaceStyle
        }

        callbacks.onThemeChanged = { [weak self] theme in
            guard let navigationController = self?.view.window?.rootViewController as? UINavigationController,
                  let currentDemoListViewController = navigationController.viewControllers.first as? DemoListViewController,
                  let window = self?.view.window else {
                return
            }
            currentDemoListViewController.updateColorProviderFor(window: window, theme: theme)
        }

        // Passed back to caller
        callbacks.onThemeWideOverrideChanged = { _ in

        }
        callbacks.onPerControlOverrideChanged = { _ in

        }
        self.callbacks = callbacks
    }

    private var callbacks: DemoAppearanceView.Callbacks?
}

struct DemoAppearanceView: View {
    class Callbacks: ObservableObject {
        var onColorSchemeChanged: ((DemoColorScheme) -> Void)?
        var onThemeChanged: ((DemoColorTheme) -> Void)?
        var onThemeWideOverrideChanged: ((Bool) -> Void)?
        var onPerControlOverrideChanged: ((Bool) -> Void)?
    }

    @State private var colorScheme: DemoColorScheme = .auto
    @State private var theme: DemoColorTheme = .default
    @State private var themeWideOverride: Bool = false
    @State private var perControlOverride: Bool = false

    @ObservedObject var callbacks: Callbacks

    /// Picker for setting the app's color scheme.
    @ViewBuilder
    var appColorSchemePicker: some View {
        Text("App Color Scheme")
            .font(.headline)
        Picker("Color Scheme", selection: $colorScheme) {
            Text("Auto").tag(DemoColorScheme.auto)
            Text("Light").tag(DemoColorScheme.light)
            Text("Dark").tag(DemoColorScheme.dark)
        }
        .pickerStyle(.segmented)
    }

    /// Picker for setting the current Fluent theme.
    @ViewBuilder
    var themePicker: some View {
        Text("Theme")
            .font(.headline)
        Picker("Theme", selection: $theme) {
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
                .disabled(callbacks.onColorSchemeChanged == nil)
            FluentDivider()
                .padding()

            themePicker
                .disabled(callbacks.onThemeChanged == nil)
            FluentDivider()
                .padding()

            Text("Control")
                .font(.headline)

            Toggle(isOn: $themeWideOverride) {
                Text("Theme-wide override")
            }
            .disabled(callbacks.onThemeWideOverrideChanged == nil)
            Toggle(isOn: $perControlOverride) {
                Text("Per-control override")
            }
            .disabled(callbacks.onPerControlOverrideChanged == nil)

            Spacer()
        }
    }

    var body: some View {
        contents
            .padding()
            .onChange(of: colorScheme) { newValue in
                callbacks.onColorSchemeChanged?(newValue)
            }
            .onChange(of: theme) { newValue in
                callbacks.onThemeChanged?(newValue)
            }
            .onChange(of: themeWideOverride) { newValue in
                callbacks.onThemeWideOverrideChanged?(newValue)
            }
            .onChange(of: perControlOverride) { newValue in
                callbacks.onPerControlOverrideChanged?(newValue)
            }
    }

    enum DemoColorScheme {
        case auto
        case light
        case dark
    }
}
