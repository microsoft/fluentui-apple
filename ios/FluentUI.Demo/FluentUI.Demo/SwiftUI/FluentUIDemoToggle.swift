//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI

struct FluentUIDemoToggle: View {
    var titleKey: LocalizedStringKey
    var isOn: Binding<Bool>

    let switchToggleStyle: SwitchToggleStyle = {
        if #available(iOS 14.0, *) {
            // Workaround for SwiftUI Toggles that switch to green tint color
            // when they're toggled for the first time
            return SwitchToggleStyle(tint: Color(Colors.communicationBlue))
        } else {
            return SwitchToggleStyle()
        }
    }()

    var body: some View {
        Toggle(titleKey, isOn: isOn)
            .toggleStyle(switchToggleStyle)
    }
}
