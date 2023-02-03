//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

enum ColoredPillBackgroundStyle: Int {
    case neutral
    case brand
}

class ColoredPillBackgroundView: UIView {
    init(style: ColoredPillBackgroundStyle) {
        self.style = style
        super.init(frame: .zero)
        updateBackgroundColor()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc func themeDidChange(_ notification: Notification) {
        guard let themeView = notification.object as? UIView, self.isDescendant(of: themeView) else {
            return
        }
        updateBackgroundColor()
    }

    func updateBackgroundColor() {
        switch style {
        case .neutral:
            backgroundColor = UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.background2])
        case .brand:
            backgroundColor = UIColor(light: UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.brandBackground1]),
                                      dark: UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.background3]))
        }
    }

    let style: ColoredPillBackgroundStyle
}
