//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class BrandedSwitch: UISwitch {
    override init(frame: CGRect) {
        super.init(frame: frame)

        NotificationCenter.default.addObserver(forName: .didChangeTheme,
                                               object: nil,
                                               queue: nil) { [weak self] notification in
            guard let strongSelf = self,
                  let themeView = notification.object as? UIView,
                  strongSelf.isDescendant(of: themeView)
            else {
                return
            }
            strongSelf.onTintColor = themeView.fluentTheme.color(.brandForeground1)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        onTintColor = newWindow.fluentTheme.color(.brandForeground1)
    }
}
