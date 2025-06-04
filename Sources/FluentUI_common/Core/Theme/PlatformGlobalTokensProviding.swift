//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Extending `GlobalTokens` to implement this protocol allows for platform-specific implementation.
public protocol PlatformGlobalTokenProviding {
    static func fontSize(for token: GlobalTokens.FontSizeToken) -> CGFloat
}