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
        backgroundColor = Colors.Palette.dangerPrimary.color
        textColor = .white
        textAlignment = .center
        font = UIFont.systemFont(ofSize: Constants.badgeFontSize, weight: .regular)
        isHidden = true
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()

        guard let window = window, shouldUseWindowColor else {
            return
        }
        textColor = UIColor(light: Colors.primary(for: window), dark: .white)
        backgroundColor = UIColor(light: .white, dark: Colors.primary(for: window))
    }

    private struct Constants {
        static let badgeFontSize: CGFloat = 11
    }
}
