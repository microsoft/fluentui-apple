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
            .sublabelColor: .dynamicColor { self.fluentTheme.aliasTokens.foregroundColors[.neutral1] },
            .iconInterspace: .float { GlobalTokens.spacing(.small) },
            .labelAccessoryInterspace: .float { GlobalTokens.spacing(.xxxSmall) },
            .labelAccessorySize: .float { GlobalTokens.iconSize(.xSmall) },
            .labelFont: .fontInfo { self.fluentTheme.aliasTokens.typography[.body1Strong] }
        ])
    }
}
