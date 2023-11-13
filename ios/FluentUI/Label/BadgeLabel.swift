//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: BadgeLabel

class BadgeLabel: UILabel, TokenizedControlInternal {
    var style: BadgeLabelStyle = .system {
        didSet {
            updateColors()
        }
    }

    typealias TokenSetKeyType = BadgeLabelTokenSet.Tokens
    lazy var tokenSet: BadgeLabelTokenSet = .init(style: { [weak self] in
        return self?.style ?? .system
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

/// Style used to set the colors of the `BadgeLabel`.
@objc(MSFBadgeLabelStyle)
public enum BadgeLabelStyle: Int {
    case onPrimary
    case system
    case brand
}
