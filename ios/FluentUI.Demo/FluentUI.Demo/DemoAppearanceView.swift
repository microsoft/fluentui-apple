//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI

struct DemoAppearanceView: View {

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @Environment(\.colorScheme) var systemColorScheme: ColorScheme

    @ObservedObject var callbacks: Callbacks

    /// Picker for setting the app's color scheme.
    @ViewBuilder
    var appColorSchemePicker: some View {
        Text("App Color Scheme")
            .font(.headline)
        Picker("Color Scheme", selection: $colorScheme) {
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

    class Callbacks: ObservableObject {
        var onColorSchemeChanged: ((ColorScheme) -> Void)?
        var onThemeChanged: ((DemoColorTheme) -> Void)?
        var onThemeWideOverrideChanged: ((_ themeWideOverrideEnabled: Bool) -> Void)?
        var onPerControlOverrideChanged: ((_ perControlOverrideEnabled: Bool) -> Void)?
    }

    @State private var colorScheme: ColorScheme = .light
    @State private var theme: DemoColorTheme = .default
    @State private var themeWideOverride: Bool = false
    @State private var perControlOverride: Bool = false
}

extension DemoAppearanceView {
    func colorScheme(_ colorScheme: ColorScheme) -> Self {
        self.colorScheme = colorScheme
        return self
    }

    func theme(_ theme: DemoColorTheme) -> Self {
        self.theme = theme
        return self
    }
}
