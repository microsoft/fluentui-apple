//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import FluentUI

struct ContentView: View {
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme

#if os(macOS)
    // Until we have a SwiftUI button on macOS, this will have to do.
    private struct ButtonRepresentable: NSViewRepresentable {
        func makeNSView(context: Context) -> some NSView {
            return FluentUI.Button(title: "Hello, world!",
                                   image: .init(systemSymbolName: "globe", accessibilityDescription: nil))
        }

        func updateNSView(_ nsView: NSViewType, context: Context) {
        }
    }
#endif

    var body: some View {
        VStack {
#if os(macOS)
            ButtonRepresentable()
                .fixedSize()
#else
            Button(action: {}, label: {
                HStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                    Text("Hello, world!")
                }
            })
            .buttonStyle(FluentButtonStyle(style: .accent))
            .controlSize(.extraLarge)
#endif
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(fluentTheme.swiftUIColor(.background1))
    }
}
