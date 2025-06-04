//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import SwiftUI

extension GlobalTokens : PlatformGlobalTokenProviding {
    public static func fontSize(for token: GlobalTokens.FontSizeToken) -> CGFloat {
        switch token {
        case .size100:
            return 12.0
        case .size200:
            return 13.0
        case .size300:
            return 15.0
        case .size400:
            return 17.0
        case .size500:
            return 20.0
        case .size600:
            return 22.0
        case .size700:
            return 28.0
        case .size800:
            return 34.0
        case .size900:
            return 60.0
        }
    }
}