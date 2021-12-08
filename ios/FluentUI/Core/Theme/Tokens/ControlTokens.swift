//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

/// Base class for all Fluent control tokenization.
open class ControlTokens: NSObject {
    var globalTokens: GlobalTokens = GlobalTokens.shared
    var aliasTokens: AliasTokens = AliasTokens.shared
}
