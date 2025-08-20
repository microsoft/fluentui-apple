//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(AppKit)
import SwiftUI

extension GlobalTokens : PlatformGlobalTokenProviding {
    public static func fontSize(for token: GlobalTokens.FontSizeToken) -> CGFloat {
        switch token {
        case .size100:
            return 10.0
        case .size200:
            return 11.0
        case .size300:
            return 12.0
        case .size400:
            return 13.0
        case .size500:
            return 15.0
        case .size600:
            return 17.0
        case .size700:
            return 22.0
        case .size800:
            return 26.0
        case .size900:
            return 44.0
        }
    }
}
#endif // canImport(AppKit)
