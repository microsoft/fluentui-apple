//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI_common
import UIKit

public extension GlobalTokens {

    // MARK: - BrandColor

    @objc(colorForBrandColorToken:)
    static func brandColor(_ token: BrandColorToken) -> UIColor {
        return UIColor(GlobalTokens.brandSwiftUIColor(token))
    }

    // MARK: - NeutralColor

    @objc(colorForNeutralColorToken:)
    static func neutralColor(_ token: NeutralColorToken) -> UIColor {
        return UIColor(GlobalTokens.neutralSwiftUIColor(token))
    }

    // MARK: - SharedColor

    @objc(colorForSharedColorSet:token:)
    static func sharedColor(_ sharedColor: SharedColorSet, _ token: SharedColorToken) -> UIColor {
        return UIColor(GlobalTokens.sharedSwiftUIColor(sharedColor, token))
    }
}
