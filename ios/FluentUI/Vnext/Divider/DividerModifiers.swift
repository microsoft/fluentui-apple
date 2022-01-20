//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

public extension FluentDivider {

    func overrideTokens(_ tokens: DividerTokens?) -> FluentDivider {
        state.overrideTokens = tokens
        return self
    }
}
