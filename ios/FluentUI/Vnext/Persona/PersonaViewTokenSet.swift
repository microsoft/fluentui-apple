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
            .sublabelColor: .uiColor { self.fluentTheme.color(.foreground2) },
            .iconInterspace: .float { GlobalTokens.spacing(.size120) },
            .labelAccessoryInterspace: .float { GlobalTokens.spacing(.size20) },
            .labelAccessorySize: .float { GlobalTokens.icon(.size160) },
            .labelFont: .uiFont { self.fluentTheme.typography(.body1Strong) }
        ])
    }
}
