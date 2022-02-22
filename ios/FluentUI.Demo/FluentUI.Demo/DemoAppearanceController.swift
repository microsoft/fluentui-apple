//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI
import UIKit

protocol DemoAppearanceDelegate: NSObjectProtocol {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool)
    func perControlOverrideDidChange(isOverrideEnabled: Bool)

    func isThemeWideOverrideApplied() -> Bool
}

/// Wrapper class to allow presenting of `DemoAppearanceView` from a UIKit host.
class DemoAppearanceController: UIHostingController<DemoAppearanceView>, ObservableObject {

    init() {
        let configuration = DemoAppearanceView.Configuration()
        self.configuration = configuration

        super.init(rootView: DemoAppearanceView(configuration: configuration))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var delegate: DemoAppearanceDelegate? {
        didSet {
            configuration.onThemeWideOverrideChanged = { [weak self] newValue in
                self?.delegate?.themeWideOverrideDidChange(isOverrideEnabled: newValue)
            }
            configuration.onPerControlOverrideChanged = { [weak self] newValue in
                self?.delegate?.perControlOverrideDidChange(isOverrideEnabled: newValue)
            }
            configuration.themeOverridePreviouslyApplied = { [weak self] in
                self?.delegate?.isThemeWideOverrideApplied() ?? false
            }
        }
    }

    private var configuration: DemoAppearanceView.Configuration
}
