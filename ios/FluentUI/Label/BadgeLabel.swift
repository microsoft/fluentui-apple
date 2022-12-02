//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: BadgeLabel

class BadgeLabel: UILabel {
    var shouldUseWindowColor: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        initBase()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initBase()
    }

    /// Base function for initialization
    private func initBase() {
        layer.masksToBounds = true
        textAlignment = .center
        font = UIFont.systemFont(ofSize: Constants.badgeFontSize, weight: .regular)
        isHidden = true

        updateColors()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        updateColors()
    }

    private func updateColors() {
        if shouldUseWindowColor {
            textColor = UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.brandForeground1].light, dark: GlobalTokens.neutralColors(.white)))
            backgroundColor = UIColor(dynamicColor: DynamicColor(light: GlobalTokens.neutralColors(.white), dark: fluentTheme.aliasTokens.colors[.brandBackground1].dark))
        } else {
            textColor = UIColor(colorValue: GlobalTokens.neutralColors(.white))
            backgroundColor = UIColor(dynamicColor: fluentTheme.aliasTokens.sharedColors[.dangerBackground2])
        }
    }

    private struct Constants {
        static let badgeFontSize: CGFloat = 11
    }
}
