//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: BadgeLabel

class BadgeLabel: UILabel, TokenizedThemeObserver {
    var shouldUseWindowColor: Bool = false {
        didSet {
            updateColors()
        }
    }

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

        tokenSet.registerOnUpdate(for: self) { [weak self] in
            self?.updateColors()
        }
        addThemeObserver(for: self)
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        tokenSet.update(newWindow.fluentTheme)
        updateColors()
    }

    private func updateColors() {
        let colorValues = tokenSet.fluentTheme.color
        if shouldUseWindowColor {
            textColor = UIColor(light: colorValues(.brandForeground1).light,
                                dark: GlobalTokens.neutralColor(.white))
            backgroundColor = UIColor(light: GlobalTokens.neutralColor(.white),
                                      dark: colorValues(.brandBackground1).dark)
        } else {
            textColor = UIColor(colorValue: GlobalTokens.neutralColors(.white))
            backgroundColor = colorValues(.dangerBackground2)
        }
    }

    private struct Constants {
        static let badgeFontSize: CGFloat = 11
    }
}
