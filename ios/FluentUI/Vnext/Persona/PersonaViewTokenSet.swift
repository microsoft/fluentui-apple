//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

public class PersonaViewTokenSet: ListCellTokenSet {
    override init(cellLeadingViewSize: @escaping () -> MSFListCellLeadingViewSize) {
        super.init(cellLeadingViewSize: cellLeadingViewSize)

        self.replaceAllOverrides(with: [
            .sublabelColor: .dynamicColor { self.fluentTheme.aliasTokens.colors[.foreground2] },
            .iconInterspace: .float { GlobalTokens.spacing(.size120) },
            .labelAccessoryInterspace: .float { GlobalTokens.spacing(.size20) },
            .labelAccessorySize: .float { GlobalTokens.icon(.size160) },
            .labelFont: .fontInfo { self.fluentTheme.aliasTokens.typography[.body1Strong] }
        ])
    }
}
