//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI

struct FluentUIDemoToggle: View {
    var titleKey: LocalizedStringKey
    var isOn: Binding<Bool>
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme

    var body: some View {
        Toggle(titleKey, isOn: isOn)
            .tint(Color(fluentTheme.color(.brandForeground1)))
    }
}
