//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Extending `FontInfo` to implement this protocol allows for platform-specific implementation of font values.
public protocol PlatformFontInfoProviding {
    static var sizeTuples: [(size: CGFloat, textStyle: Font.TextStyle)] { get }
}