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
        return SwitchToggleStyle(tint: Color(UIColor(colorValue: GlobalTokens.brandColors(.comm80))))
    }()

    var body: some View {
        Toggle(titleKey, isOn: isOn)
            .toggleStyle(switchToggleStyle)
    }
}
