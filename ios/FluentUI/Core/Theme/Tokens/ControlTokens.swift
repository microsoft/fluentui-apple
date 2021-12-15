//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

/// Base class for all Fluent control tokenization.
public class ControlTokens: NSObject {
    lazy var globalTokens: GlobalTokens = FluentTheme.shared.globalTokens
    lazy var aliasTokens: AliasTokens = FluentTheme.shared.aliasTokens
}
