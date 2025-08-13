//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI

/// This class displays the contents of the DemoAppearance `Menu`. All actions are callback-based, allowing a
/// wrapping component, `DemoAppearanceControlView`, to manage interop with our UIKit environment.
struct DemoAppearanceMenu: View {

    @Environment(\.colorScheme) var systemColorScheme: ColorScheme
    @ObservedObject var configuration: Configuration
    @State var showingThemeWideAlert: Bool = false

    /// Picker for setting the app's color scheme.
    @ViewBuilder
    var appColorSchemePicker: some View {
        Picker("Color Scheme", systemImage: "cloud.rainbow.half", selection: $configuration.userInterfaceStyle) {
            Label("System", systemImage: "circle.lefthalf.filled").tag(UIUserInterfaceStyle.unspecified)
            Label("Light", systemImage: "sun.max").tag(UIUserInterfaceStyle.light)
            Label("Dark", systemImage: "moon.stars").tag(UIUserInterfaceStyle.dark)
        }
        .pickerStyle(.menu)
    }

    /// Picker for setting the current Fluent theme.
    @ViewBuilder
    func themePicker(_ titleKey: String, systemImage: String, selection: Binding<DemoColorTheme>) -> some View {
        Picker(titleKey, systemImage: systemImage, selection: selection) {
            Text("\(DemoColorTheme.default.name)").tag(DemoColorTheme.default)
            Text("\(DemoColorTheme.green.name)").tag(DemoColorTheme.green)
            Text("\(DemoColorTheme.purple.name)").tag(DemoColorTheme.purple)
        }
        .pickerStyle(.menu)
    }

    /// Collects the various pickers and toggles together.
    @ViewBuilder
    var contents: some View {
        Section {
            appColorSchemePicker
            themePicker("Window Theme", systemImage: "macwindow", selection: $configuration.windowTheme)
            themePicker("App-Wide Theme", systemImage: "app.gift", selection: $configuration.appWideTheme)
        }

        if showThemeWideOverrideToggle || showPerControlOverrideToggle {
            Section("Control Tokens") {
                // Theme-wide override toggle
                if showThemeWideOverrideToggle {
                    Toggle("Theme-wide override", systemImage: "swatchpalette", isOn: $configuration.themeWideOverride)
                }

                // Per-control override toggle
                if showPerControlOverrideToggle {
                    Toggle("Per-control override", systemImage: "switch.2", isOn: $configuration.perControlOverride)
                }
            }
        }
    }

    var body: some View {
        Menu(content: {
            contents
        }, label: {
            Image(systemName: "gearshape")
        })

        // Changes
        .onChange_Compatibility(of: configuration.userInterfaceStyle) { newValue in
            configuration.onUserInterfaceStyleChanged?(newValue)
        }
        .onChange_Compatibility(of: configuration.windowTheme) { newValue in
            configuration.onWindowThemeChanged?(newValue)
        }
        .onChange_Compatibility(of: configuration.appWideTheme) { newValue in
            configuration.onAppWideThemeChanged?(newValue)
        }
        .onChange_Compatibility(of: configuration.themeWideOverride) { newValue in
            configuration.onThemeWideOverrideChanged?(newValue)

            // TODO: Still working through some issues with the theme-wide override tokens, so inform the user how to make it visible for now.
            showingThemeWideAlert = true
        }
        .onChange_Compatibility(of: configuration.perControlOverride) { newValue in
            configuration.onPerControlOverrideChanged?(newValue)
        }

        // TODO: Still working through some issues with the theme-wide override tokens, so inform the user how to make it visible for now.
        .alert(isPresented: $showingThemeWideAlert) {
            Alert(title: Text("Theme-wide override"),
                  message: Text("Changes to \"Theme-wide override\" tokens will only take effect when the control redraws for some othe reason.\n\nTry backing out of this view and re-entering it."))
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
