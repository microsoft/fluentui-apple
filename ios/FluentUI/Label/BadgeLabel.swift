//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: BadgeLabel

class BadgeLabel: UILabel, TokenizedControlInternal {
    var style: Style = .system {
        didSet {
            updateColors()
        }
    }

    typealias TokenSetKeyType = BadgeLabelTokenSet.Tokens
    lazy var tokenSet: BadgeLabelTokenSet = .init(style: { [weak self] in
        return self?.style ?? .brand
    })

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
        textColor = tokenSet[.textColor].uiColor
        backgroundColor = tokenSet[.backgroundColor].uiColor
    }

    private struct Constants {
        static let badgeFontSize: CGFloat = 11
    }
}
