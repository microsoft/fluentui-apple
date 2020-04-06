//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

extension UIResponder {
    // From http://stackoverflow.com/a/27140764
    // See documentation for sendAction (https://developer.apple.com/reference/uikit/uiapplication/1622946-sendaction)

    private static weak var _firstResponder: UIResponder?

    @available(iOSApplicationExtension, unavailable)
    static var firstResponder: UIResponder? {
        _firstResponder = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder), to: nil, from: nil, for: nil)
        return _firstResponder
    }

    @objc private func findFirstResponder() {
        UIResponder._firstResponder = self
    }
}
