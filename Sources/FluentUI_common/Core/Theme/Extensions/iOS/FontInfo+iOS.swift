//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(UIKit)
import SwiftUI

extension FluentFontInfo : PlatformFontInfoProviding {
    public static var sizeTuples: [(size: CGFloat, textStyle: Font.TextStyle)] = [
        (34.0, .largeTitle),
        (28.0, .title),
        (22.0, .title2),
        (20.0, .title3),
        // Note: `17.0: .headline` is removed to avoid needing duplicate size key values.
        // But it's okay because Apple's scaling curve is identical between it and `.body`.
        (17.0, .body),
        (16.0, .callout),
        (15.0, .subheadline),
        (13.0, .footnote),
        (12.0, .caption),
        (11.0, .caption2)
    ]
}
#endif // canImport(UIKit)
