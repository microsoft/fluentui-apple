//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import FluentUI

struct ShimmerDemoView: View {
    @Environment(\.fluentTheme) var fluentTheme

    var body: some View {
        VStack {
            Text("Shimmer Demo (NYI)")
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(fluentTheme.swiftUIColor(.background1))
    }
}
