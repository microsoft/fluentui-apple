//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

public extension AvatarGroup {
    /// Provides a custom design token set to be used when drawing this control
    func overrideTokens(_ tokens: AvatarGroupTokens?) -> AvatarGroup {
        configuration.overrideTokens = tokens
        return self
    }
}
