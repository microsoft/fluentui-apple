//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

class MSFPopupMenuItemCellTokens: MSFCellBaseTokens {
	@Published public var selectionColor: UIColor!
	@Published public var disabledColor: UIColor!

    override init() {
        super.init()

        self.themeAware = true
        updateForCurrentTheme()
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }

    override func updateForCurrentTheme() {
		super.updateForCurrentTheme()
		let appearanceProxy: AppearanceProxyType = theme.MSFPopupMenuItemCellTokens
		selectionColor = appearanceProxy.selectionColor
		disabledColor = appearanceProxy.disabledColor
    }
}
