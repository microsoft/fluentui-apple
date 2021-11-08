//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

extension TokenFactory {
    /// Creates an instance of `CardNudgeTokens` for use in the `CardNudge` control.
    @objc open var cardNudgeTokens: CardNudgeTokens {
        return CardNudgeTokens()
    }

    // Attempts to fetch `CardNudgeTokens` from the token cache, and creates
    // a new instance if the lookup fails.
    var cachedCardNudgeTokens: CardNudgeTokens {
        return tokenCache {
            cardNudgeTokens
        }
    }
}
