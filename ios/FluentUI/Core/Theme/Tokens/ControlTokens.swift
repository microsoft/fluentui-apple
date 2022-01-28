//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

/// Base class for all Fluent control tokenization.
open class ControlTokens: NSObject {
    lazy var fluentTheme: FluentTheme = FluentTheme.shared
    var globalTokens: GlobalTokens { fluentTheme.globalTokens }
    var aliasTokens: AliasTokens { fluentTheme.aliasTokens }
}
