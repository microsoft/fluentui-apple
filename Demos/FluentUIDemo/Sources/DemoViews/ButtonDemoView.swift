//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import FluentUI

struct ButtonDemoView: View {
    @Environment(\.fluentTheme) var fluentTheme

    var body: some View {
        VStack {
            Button(action: {}, label: {
                HStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                    Text("Hello, world!")
                }
            })
#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
            .buttonStyle(FluentButtonStyle(style: .accent))
#endif
            .controlSize(.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(fluentTheme.swiftUIColor(.background1))
    }
}
