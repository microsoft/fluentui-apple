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
                .disabled(configuration.onColorSchemeChanged == nil)
            FluentDivider()
                .padding()

            themePicker
                .disabled(configuration.onThemeChanged == nil)
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
            .onChange(of: configuration.colorScheme) { newValue in
                configuration.onColorSchemeChanged?(newValue)
            }
            .onChange(of: configuration.theme) { newValue in
                configuration.onThemeChanged?(newValue)
            }
            .onChange(of: configuration.themeWideOverride) { newValue in
                configuration.onThemeWideOverrideChanged?(newValue)
            }
            .onChange(of: configuration.perControlOverride) { newValue in
                configuration.onPerControlOverrideChanged?(newValue)
            }
    }

    class Configuration: ObservableObject {
        // Data
        @Published var colorScheme: ColorScheme = .light
        @Published var theme: DemoColorTheme = .default
        @Published var themeWideOverride: Bool = false
        @Published var perControlOverride: Bool = false

        // Callbacks
        var onColorSchemeChanged: ((ColorScheme) -> Void)?
        var onThemeChanged: ((DemoColorTheme) -> Void)?
        var onThemeWideOverrideChanged: ((_ themeWideOverrideEnabled: Bool) -> Void)?
        var onPerControlOverrideChanged: ((_ perControlOverrideEnabled: Bool) -> Void)?
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
