//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: BadgeLabel

class BadgeLabel: UILabel, TokenizedControlInternal {
    var shouldUseWindowColor: Bool = false

    typealias TokenSetKeyType = EmptyTokenSet.Tokens
    var tokenSet: EmptyTokenSet = .init()

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

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)

        updateColors()
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        tokenSet.update(newWindow.fluentTheme)
        updateColors()
    }

    @objc private func themeDidChange(_ notification: Notification) {
        guard let themeView = notification.object as? UIView, self.isDescendant(of: themeView) else {
            return
        }
        tokenSet.update(themeView.fluentTheme)
        updateColors()
    }

    private func updateColors() {
        if shouldUseWindowColor {
            textColor = UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.brandForeground1].light, dark: GlobalTokens.neutralColors(.white)))
            backgroundColor = UIColor(dynamicColor: DynamicColor(light: GlobalTokens.neutralColors(.white), dark: fluentTheme.aliasTokens.colors[.brandBackground1].dark))
        } else {
            textColor = UIColor(colorValue: GlobalTokens.neutralColors(.white))
            backgroundColor = UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.dangerBackground2])
        }
    }

    private struct Constants {
        static let badgeFontSize: CGFloat = 11
    }
}
