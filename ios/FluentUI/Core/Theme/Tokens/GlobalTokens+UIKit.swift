//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public extension GlobalTokens {

    // MARK: - BrandColor

    @objc(colorForBrandColorToken:)
    static func brandColor(_ token: BrandColorToken) -> UIColor {
        return UIColor(GlobalTokens.brandColor(token))
    }

    // MARK: - NeutralColor

    @objc(colorForNeutralColorToken:)
    static func neutralColor(_ token: NeutralColorToken) -> UIColor {
        return UIColor(GlobalTokens.neutralColor(token))
    }

    // MARK: - SharedColor

    @objc(colorForSharedColorSet:token:)
    static func sharedColor(_ sharedColor: SharedColorSet, _ token: SharedColorToken) -> UIColor {
        return UIColor(GlobalTokens.sharedColor(sharedColor, token))
    }
}
