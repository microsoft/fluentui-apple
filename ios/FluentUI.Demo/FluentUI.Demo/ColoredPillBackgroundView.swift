//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

enum ColoredPillBackgroundStyle: Int {
    case neutralNavBar
    case brandNavBar
    case canvas
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
        guard FluentTheme.isApplicableThemeChange(notification, for: self) else {
            return
        }
        updateBackgroundColor()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()

        // Note: We usually do updates during `willMove(toWindow:)` to ensure that there's no "flash" of the
        // old color in cases whre the view is briefly visible before this API is called. However, the
        // public APIs for easily hooking into theme changes have not yet been exposed, so this demo
        // controller is not in a position to easily follow those rules. This will be sufficient for our
        // current needs, but it's technically less correct than I'd like.
        // TODO: update this to use proper theme updating hooks once they're built
        updateBackgroundColor()
    }

    func updateBackgroundColor() {
        switch style {
        case .neutralNavBar:
            backgroundColor = NavigationBar.backgroundColor(for: .system, theme: fluentTheme)
        case .brandNavBar:
            backgroundColor = NavigationBar.backgroundColor(for: .primary, theme: fluentTheme)
        case .canvas:
            backgroundColor = fluentTheme.color(.backgroundCanvas)
        }
    }

    let style: ColoredPillBackgroundStyle
}
