//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// HeaderFooter styles
@objc public enum MSFHeaderFooterStyle: Int, CaseIterable {
    case standard
    case subtle
}

open class MSFHeaderFooterTokens: ControlTokens {
    /// The MSFHeaderFooter style. Currently we only have primary and secondary styles.
    public internal(set) var style: MSFHeaderFooterStyle = .standard

    // MARK: - Design Tokens

    ///  The background color of the List Header
    open var backgroundColor: DynamicColor { aliasTokens.backgroundColors[.neutral1] }

    /// The color of the List Header text
    open var textColor: DynamicColor {
        switch style {
        case .standard:
            return aliasTokens.foregroundColors[.neutral1]
//            return globalTokens.brandColors[.primary]
        case .subtle:
            return aliasTokens.foregroundColors[.neutral3]
        }
    }

    /// Height of the List Header
    open var headerHeight: CGFloat { globalTokens.spacing[.xxxLarge] }

    /// Top padding of the List Header
    open var topPadding: CGFloat {
        switch style {
        case .standard:
            return globalTokens.spacing[.medium]
        case .subtle:
            return globalTokens.spacing[.xLarge]
        }
    }

    /// Leading padding of the List Header
    open var leadingPadding: CGFloat { globalTokens.spacing[.medium] }

    /// Bottom padding of the List Header
    open var bottomPadding: CGFloat { globalTokens.spacing[.xSmall] }

    /// Trailing padding of the List Header
    open var trailingPadding: CGFloat { globalTokens.spacing[.medium] }

    /// The font used for the List Header
    open var textFont: FontInfo {
        switch style {
        case .standard:
            return aliasTokens.typography[.body1Strong]
        case .subtle:
            return aliasTokens.typography[.caption1]
        }
    }
}
