//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

public enum ColoredBackgroundStyle: Int {
    case neutral
    case brand
}

class ColoredBackgroundView: UIView {
    init(style: ColoredBackgroundStyle) {
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
                lightColor = Colors.navigationBarBackground
                darkColor = Colors.navigationBarBackground
            }
        case .brand:
            if let fluentTheme = window?.fluentTheme {
                lightColor = UIColor(dynamicColor: fluentTheme.aliasTokens.backgroundColors[.brandRest])
                darkColor = UIColor(dynamicColor: fluentTheme.aliasTokens.backgroundColors[.neutral4])
            } else {
                lightColor = Colors.communicationBlue
                darkColor = Colors.navigationBarBackground
            }
        }

        backgroundColor = UIColor(light: lightColor, dark: darkColor)
    }

    let style: ColoredBackgroundStyle
}
