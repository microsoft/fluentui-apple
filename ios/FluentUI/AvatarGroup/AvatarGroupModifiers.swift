//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

public extension AvatarGroup {
    func maxDisplayedAvatars(_ maxDisplayedAvatars: Int) -> AvatarGroup {
        state.maxDisplayedAvatars = maxDisplayedAvatars
        return self
    }

    func overflowCount(_ overflowCount: Int) -> AvatarGroup {
        state.overflowCount = overflowCount
        return self
    }
}
