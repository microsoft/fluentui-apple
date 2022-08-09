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
            .iconInterspace: .float { self.fluentTheme.globalTokens.spacing[.small] },
            .labelAccessoryInterspace: .float { self.fluentTheme.globalTokens.spacing[.xxxSmall] },
            .labelAccessorySize: .float { self.fluentTheme.globalTokens.iconSize[.xSmall] },
            .labelFont: .fontInfo { self.fluentTheme.aliasTokens.typography[.body1Strong] }
        ])
    }
}
