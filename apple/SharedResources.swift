//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

/// Class for accessing common (iOS + macOS) resources, like colors
public class SharedResources: NSObject {
    public static var colorsBundle: Bundle {
        return Bundle.module
    }
}
