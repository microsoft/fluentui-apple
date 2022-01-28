//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI
import UIKit

/// Wrapper class to allow presenting of `DemoAppearanceView` from a UIKit host.
class DemoAppearanceController: UIHostingController<DemoAppearanceView> {
    init() {
        let configuration = DemoAppearanceView.Configuration()
        self.configuration = configuration

        super.init(rootView: DemoAppearanceView(configuration: configuration))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupPerDemoCallbacks(onThemeWideOverrideChanged: @escaping ((Bool) -> Void),
                               onPerControlOverrideChanged: @escaping ((Bool) -> Void)) {
        // Passed back to caller
        configuration.onThemeWideOverrideChanged = onThemeWideOverrideChanged
        configuration.onPerControlOverrideChanged = onPerControlOverrideChanged
    }

    private var configuration: DemoAppearanceView.Configuration
}
