//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

public class MSFPersonaViewTokens: MSFCellBaseTokens {
    open override var sublabelColor: DynamicColor { aliasTokens.foregroundColors[.neutral1] }

    open override var iconInterspace: CGFloat { globalTokens.spacing[.small] }

    open override var labelAccessoryInterspace: CGFloat { globalTokens.spacing[.xxxSmall] }

    open override var labelAccessorySize: CGFloat { globalTokens.iconSize[.xSmall] }

    open override var labelFont: FontInfo { aliasTokens.typography[.body1Strong] }

    open override var footnoteFont: FontInfo { aliasTokens.typography[.caption1] }
}
