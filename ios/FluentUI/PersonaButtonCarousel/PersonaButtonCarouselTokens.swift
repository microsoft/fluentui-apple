//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Representation of design tokens to controls at runtime which interfaces with the Design Token System auto-generated code.
/// Updating these properties causes the SwiftUI controls to update its view automatically.
class MSFPersonaButtonCarouselTokens: MSFTokensBase, ObservableObject {
    @Published var backgroundColor: UIColor!

    var size: MSFPersonaButtonSize {
        didSet {
            if oldValue != size {
                updateForCurrentTheme()
            }
        }
    }

    init(size: MSFPersonaButtonSize) {
        self.size = size

        super.init()

        self.themeAware = true

        updateForCurrentTheme()
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }

    override func updateForCurrentTheme() {
        let currentTheme = theme
        let appearanceProxy = currentTheme.MSFPersonaButtonCarouselTokens

        backgroundColor = appearanceProxy.backgroundColor
    }
}
