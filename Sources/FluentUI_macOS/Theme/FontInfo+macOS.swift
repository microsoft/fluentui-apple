//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import SwiftUI

extension FluentFontInfo : PlatformFontInfoProviding {
    public static var sizeTuples: [(size: CGFloat, textStyle: Font.TextStyle)] = [
        (26.0, .largeTitle),
        (22.0, .title),
        (17.0, .title2),
        (15.0, .title3),
        // Note: `13.0: .headline` is removed to avoid needing duplicate size key values.
        // But it's okay because Apple's scaling curve is identical between it and `.body`.
        (13.0, .body),
        (12.0, .callout),
        (11.0, .subheadline),
        (10.0, .footnote)
        // Note: `10.0: .caption` and `10.0: .caption2` are removed to avoid needing duplicate size key values.
        // But it's okay because Apple's scaling curve is identical between it and `.footnote`.
    ]
}