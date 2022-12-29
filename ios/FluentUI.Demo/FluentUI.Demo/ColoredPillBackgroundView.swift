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

    override func didMoveToWindow() {
        super.didMoveToWindow()
        updateBackgroundColor()
    }

    @objc func themeDidChange() {
        updateBackgroundColor()
    }

    func updateBackgroundColor() {
        let lightColor: UIColor
        let darkColor: UIColor
        switch style {
        case .neutral:
            if let fluentTheme = window?.fluentTheme {
                lightColor = UIColor(dynamicColor: fluentTheme.aliasTokens.backgroundColors[.neutral1])
                darkColor = UIColor(dynamicColor: fluentTheme.aliasTokens.backgroundColors[.neutral4])
            } else {
                lightColor = UIColor(colorValue: GlobalTokens.neutralColors(.white))
                darkColor = UIColor(colorValue: GlobalTokens.neutralColors(.grey16))
            }
        case .brand:
            if let fluentTheme = window?.fluentTheme {
                lightColor = UIColor(dynamicColor: fluentTheme.aliasTokens.backgroundColors[.brandRest])
                darkColor = UIColor(dynamicColor: fluentTheme.aliasTokens.backgroundColors[.neutral4])
            } else {
                lightColor = UIColor(colorValue: GlobalTokens.brandColors(.comm80))
                darkColor = UIColor(colorValue: GlobalTokens.neutralColors(.grey16))
            }
        }

        backgroundColor = UIColor(light: lightColor, dark: darkColor)
    }

    let style: ColoredPillBackgroundStyle
}
