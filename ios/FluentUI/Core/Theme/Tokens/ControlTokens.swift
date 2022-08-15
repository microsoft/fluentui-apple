//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

/// Base class for all Fluent control tokenization.
open class ControlTokens: NSObject {
    required public override init() {}

    public var globalTokens: GlobalTokens { fluentTheme.globalTokens }
    public var aliasTokens: AliasTokens { fluentTheme.aliasTokens }

    lazy var fluentTheme: FluentTheme = FluentTheme.shared
}
