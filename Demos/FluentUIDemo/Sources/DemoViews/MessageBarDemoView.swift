//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import FluentUI

struct MessageBarDemoView: View {
    @Environment(\.fluentTheme) var fluentTheme

    @State var alertText: String?
    @State var alertIsShown: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            MessageBar(
                MessageBarConfiguration(
                    title: "Descriptive Title",
                    message: "Message providing information to the user with actionable insights.",
                    onCloseCallback: {
                        alertText = "Close button on the MessageBarView was pressed."
                        alertIsShown = true
                    }
                )
            )
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(fluentTheme.swiftUIColor(.background1))
        .alert("Button pressed!", isPresented: $alertIsShown) {
            Button("OK") {
                alertIsShown = false
            }
        } message: {
            Text(alertText ?? "")
        }
    }
}
