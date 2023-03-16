//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: BadgeLabel

class BadgeLabel: UILabel, TokenizedControlInternal {
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
            textColor = UIColor(dynamicColor: DynamicColor(light: colorValues(.brandForeground1).light,
                                                           dark: GlobalTokens.neutralColors(.white)))
            backgroundColor = UIColor(dynamicColor: DynamicColor(light: GlobalTokens.neutralColors(.white),
                                                                 dark: colorValues(.brandBackground1).dark))
        } else {
            textColor = UIColor(colorValue: GlobalTokens.neutralColors(.white))
            backgroundColor = UIColor(dynamicColor: colorValues(.dangerBackground2))
        }
    }

    private struct Constants {
        static let badgeFontSize: CGFloat = 11
    }
}
