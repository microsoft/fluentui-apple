//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// Representation of design tokens for the Indeterminate Progress Bar at runtime which interfaces with the Design Token System auto-generated code.
/// Updating these properties causes the SwiftUI Indeterminate Progress Bar to update its view automatically.
class MSFIndeterminateProgressBarTokens: MSFTokensBase, ObservableObject {
    @Published public var backgroundColor: UIColor!
    @Published public var gradientColor: UIColor!
    @Published public var height: CGFloat!

    override init() {
        super.init()

        self.themeAware = true

        updateForCurrentTheme()
    }

    override func updateForCurrentTheme() {
        let currentTheme = theme
        let appearanceProxy = currentTheme.MSFIndeterminateProgressBarTokens

        backgroundColor = appearanceProxy.backgroundColor
        gradientColor = appearanceProxy.gradientColor
        height = appearanceProxy.height
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }
}
