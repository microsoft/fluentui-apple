//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI

/// This class displays the contents of the DemoAppearance popover. All actions are callback-based, allowing a
/// wrapping component, DemoAppearanceController, to manage interop with our UIKit environment.
struct DemoAppearanceView: View {

    @Environment(\.colorScheme) var systemColorScheme: ColorScheme
    @ObservedObject var configuration: Configuration
    @State var showingThemeWideAlert: Bool = false
    @ObservedObject var fluentTheme: FluentTheme = .shared

    /// Picker for setting the app's color scheme.
    @ViewBuilder
    var appColorSchemePicker: some View {
        Text("App Color Scheme")
            .font(.headline)
        Picker("Color Scheme", selection: $configuration.userInterfaceStyle) {
            Text("System").tag(UIUserInterfaceStyle.unspecified)
            Text("Light").tag(UIUserInterfaceStyle.light)
            Text("Dark").tag(UIUserInterfaceStyle.dark)
        }
        .pickerStyle(.segmented)
    }

    /// Picker for setting the current Fluent theme.
    @ViewBuilder
    func themePicker(_ titleKey: String, selection: Binding<DemoColorTheme>) -> some View {
        Text(titleKey)
            .font(.headline)
        Picker(titleKey, selection: selection) {
            Text("\(DemoColorTheme.default.name)").tag(DemoColorTheme.default)
            Text("\(DemoColorTheme.green.name)").tag(DemoColorTheme.green)
            Text("\(DemoColorTheme.purple.name)").tag(DemoColorTheme.purple)
        }
        .pickerStyle(.segmented)
    }

    /// Collects the various pickers and toggles together.
    @ViewBuilder
    var contents: some View {
        VStack {
            appColorSchemePicker
            themePicker("Window Theme", selection: $configuration.windowTheme)
            themePicker("App-Wide Theme", selection: $configuration.appWideTheme)
            Divider()
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
        .fluentTheme(fluentTheme)
    }

    var body: some View {
        // Can't use `guard` in SwiftUI body, sadly
        if configuration.isConfigured == false {
            FluentUI.ActivityIndicator(size: .xLarge)
                .isAnimating(true)
        } else {
            contents
                .padding()

                // Changes
                .onChange_iOS17(of: configuration.userInterfaceStyle) { newValue in
                    configuration.onUserInterfaceStyleChanged?(newValue)
                }
                .onChange_iOS17(of: configuration.windowTheme) { newValue in
                    configuration.onWindowThemeChanged?(newValue)
                }
                .onChange_iOS17(of: configuration.appWideTheme) { newValue in
                    configuration.onAppWideThemeChanged?(newValue)
                }
                .onChange_iOS17(of: configuration.themeWideOverride) { newValue in
                    configuration.onThemeWideOverrideChanged?(newValue)

                    // TODO: Still working through some issues with the theme-wide override tokens, so inform the user how to make it visible for now.
                    showingThemeWideAlert = true
                }
                .onChange_iOS17(of: configuration.perControlOverride) { newValue in
                    configuration.onPerControlOverrideChanged?(newValue)
                }

                // TODO: Still working through some issues with the theme-wide override tokens, so inform the user how to make it visible for now.
                .alert(isPresented: $showingThemeWideAlert) {
                    Alert(title: Text("Theme-wide override"),
                          message: Text("Changes to \"Theme-wide override\" tokens will only take effect when the control redraws for some othe reason.\n\nTry backing out of this view and re-entering it."))
                }
        }
    }

    /// Container class for data and control-specific callbacks.
    class Configuration: ObservableObject {
        // Data
        @Published var userInterfaceStyle: UIUserInterfaceStyle = .unspecified
        @Published var windowTheme: DemoColorTheme = .default
        @Published var appWideTheme: DemoColorTheme = .default
        @Published var themeWideOverride: Bool = false
        @Published var perControlOverride: Bool = false

        // Environment
        @Published var isConfigured: Bool = false

        // Global callbacks
        var onAppWideThemeChanged: ((_ theme: DemoColorTheme) -> Void)?

        // Window-specific callbacks
        var onUserInterfaceStyleChanged: ((_ userInterfaceStyle: UIUserInterfaceStyle) -> Void)?
        var onWindowThemeChanged: ((_ theme: DemoColorTheme) -> Void)?

        // Control-specific callbacks
        var onThemeWideOverrideChanged: ((_ themeWideOverrideEnabled: Bool) -> Void)?
        var onPerControlOverrideChanged: ((_ perControlOverrideEnabled: Bool) -> Void)?
        var themeOverridePreviouslyApplied: (() -> Bool)?
    }

    private var showThemeWideOverrideToggle: Bool {
        return configuration.onThemeWideOverrideChanged != nil && configuration.themeOverridePreviouslyApplied != nil
    }

    private var showPerControlOverrideToggle: Bool {
        return configuration.onPerControlOverrideChanged != nil
    }
}
