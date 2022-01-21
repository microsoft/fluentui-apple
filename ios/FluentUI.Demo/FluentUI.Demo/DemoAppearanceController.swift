//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import FluentUI
import SwiftUI

class DemoAppearanceController: UIHostingController<DemoAppearanceView> {
    convenience init() {
        self.init(rootView: DemoAppearanceView())
    }
}

struct DemoAppearanceView: View {
    @State private var colorScheme: DemoColorScheme = .auto
    @State private var theme: DemoColorTheme = .default
    @State private var themeWideOverride: Bool = false
    @State private var perControlOverride: Bool = false

    var body: some View {
        VStack {
            Text("App Color Scheme")
                .font(.headline)
            Picker("Color Scheme", selection: $colorScheme) {
                Text("Auto").tag(DemoColorScheme.auto)
                Text("Light").tag(DemoColorScheme.light)
                Text("Dark").tag(DemoColorScheme.dark)
            }
            .pickerStyle(.segmented)

            FluentDivider()
                .padding()

            Text("Theme")
                .font(.headline)
            Picker("Theme", selection: $theme) {
                Text("\(DemoColorTheme.default.name)").tag(DemoColorTheme.default)
                Text("\(DemoColorTheme.green.name)").tag(DemoColorTheme.green)
                Text("\(DemoColorTheme.none.name)").tag(DemoColorTheme.none)
            }
            .pickerStyle(.segmented)

            FluentDivider()
                .padding()

            Toggle(isOn: $themeWideOverride) {
                Text("Theme-wide override")
            }
            Toggle(isOn: $perControlOverride) {
                Text("Per-control override")
            }
        }
        .padding()
        .onChange(of: colorScheme) { newValue in
            // Do something
            debugPrint(newValue)
        }
        .onChange(of: theme) { newValue in
            debugPrint(newValue)
        }
    }

    private enum DemoColorScheme {
        case auto
        case light
        case dark
    }
}
