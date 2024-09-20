//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

extension XCUIElement {
    func clearText() {
        self.tap()
        let currentText = self.value as? String ?? ""
        self.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: currentText.count))
    }
}
