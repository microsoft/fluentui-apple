//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Pre-defined sizes of the activity indicator
@objc public enum MSFActivityIndicatorSize: Int, CaseIterable {
    case xSmall
    case small
    case medium
    case large
    case xLarge

    var size: CGFloat {
        switch self {
        case .xSmall:
            return FluentUIThemeManager.S.MSFActivityIndicatorTokens.size.xSmall
        case .small:
            return FluentUIThemeManager.S.MSFActivityIndicatorTokens.size.small
        case .medium:
            return FluentUIThemeManager.S.MSFActivityIndicatorTokens.size.medium
        case .large:
            return FluentUIThemeManager.S.MSFActivityIndicatorTokens.size.large
        case .xLarge:
            return FluentUIThemeManager.S.MSFActivityIndicatorTokens.size.xLarge
        }
    }
}

/// Representation of design tokens to buttons at runtime which interfaces with the Design Token System auto-generated code.
/// Updating these properties causes the SwiftUI button to update its view automatically.
class MSFActivityIndicatorTokens: MSFTokensBase, ObservableObject {
    @Published public var activityIndicatorSize: CGFloat!
    @Published public var thickness: CGFloat!
    @Published public var textFont: UIFont!

    @Published public var defaultColor: UIColor!

    var size: MSFActivityIndicatorSize {
        didSet {
            if oldValue != size {
                updateForCurrentTheme()
            }
        }
    }

    init(size: MSFActivityIndicatorSize) {
        self.size = size

        super.init()

        self.themeAware = true

        updateForCurrentTheme()
    }

    override func updateForCurrentTheme() {
        let currentTheme = theme
        let appearanceProxy = currentTheme.MSFActivityIndicatorTokens

        defaultColor = appearanceProxy.defaultColor

        switch size {
        case .xSmall:
            activityIndicatorSize = appearanceProxy.size.xSmall
            thickness = appearanceProxy.thickness.xSmall
        case .small:
            activityIndicatorSize = appearanceProxy.size.small
            thickness = appearanceProxy.thickness.small
        case .medium:
            activityIndicatorSize = appearanceProxy.size.medium
            thickness = appearanceProxy.thickness.medium
        case .large:
            activityIndicatorSize = appearanceProxy.size.large
            thickness = appearanceProxy.thickness.large
        case .xLarge:
            activityIndicatorSize = appearanceProxy.size.xLarge
            thickness = appearanceProxy.thickness.xLarge
        }
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }
}
