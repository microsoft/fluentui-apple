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
        backgroundColor = UIColor(dynamicColor: fluentTheme.aliasTokens.sharedColors[.dangerBackground1])
        textColor = .white
        textAlignment = .center
        font = UIFont.systemFont(ofSize: Constants.badgeFontSize, weight: .regular)
        isHidden = true
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()

        guard shouldUseWindowColor else {
            return
        }
        textColor = UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.brandForeground1].light, dark: GlobalTokens.neutralColors(.white)))
        backgroundColor = UIColor(dynamicColor: DynamicColor(light: GlobalTokens.neutralColors(.white), dark: fluentTheme.aliasTokens.colors[.brandBackground1].dark))
    }

    private struct Constants {
        static let badgeFontSize: CGFloat = 11
    }
}
