//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import FluentUI

/// Main content view for the FluentUI demo app. Main view is a `NavigationSplitView` that allows navigation
/// between demo controllers defined in `Demo.swift`.
struct ContentView: View {
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme

    var body: some View {
        NavigationSplitView {
            demoList
                .navigationDestination(for: Demo.self) { demo in
                    AnyView(demo.view)
                }
                .navigationTitle("\(appName)")
        } detail: {
            Text("Please select a demo")
        }
        .frame(minWidth: 300, minHeight: 200)
    }

    @ViewBuilder
    private var demoList: some View {
        // Only show sections with at least one item
        let sectionsToShow = DemoListSection.allCases.filter { !$0.demos.isEmpty }
        List {
            ForEach(sectionsToShow, id: \.self) { section in
                demoListSection(section.title, section.demos)
            }
        }
    }

    @ViewBuilder
    private func demoListSection(_ title: String, _ demos: [Demo]) -> some View {
        Section(title) {
            ForEach(demos, id: \.self) { demo in
                NavigationLink("\(demo.title)", value: demo)
            }
        }
    }

    private var appName: String {
        Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? ""
    }
}
