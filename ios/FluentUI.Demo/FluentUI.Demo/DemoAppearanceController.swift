//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import FluentUI
import SwiftUI

class DemoAppearanceController: UIHostingController<DemoAppearanceView> {
    init() {
        let configuration = DemoAppearanceView.Configuration()
        self.configuration = configuration

        super.init(rootView: DemoAppearanceView(configuration: configuration))
    }

    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
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
