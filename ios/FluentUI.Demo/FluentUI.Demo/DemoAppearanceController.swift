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

        self.modalPresentationStyle = .popover
        self.preferredContentSize.height = 375
        self.popoverPresentationController?.permittedArrowDirections = .up
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var delegate: DemoAppearanceDelegate? {
        didSet {
            // Only set up callbacks if we have a valid delegate.
            if delegate != nil {
                configuration.onThemeWideOverrideChanged = { [weak self] newValue in
                    self?.delegate?.themeWideOverrideDidChange(isOverrideEnabled: newValue)
                }
                configuration.onPerControlOverrideChanged = { [weak self] newValue in
                    self?.delegate?.perControlOverrideDidChange(isOverrideEnabled: newValue)
                }
                configuration.themeOverridePreviouslyApplied = { [weak self] in
                    self?.delegate?.isThemeWideOverrideApplied() ?? false
                }
            } else {
                configuration.onThemeWideOverrideChanged = nil
                configuration.onPerControlOverrideChanged = nil
                configuration.themeOverridePreviouslyApplied = nil
            }
        }
    }

    private var configuration: DemoAppearanceView.Configuration
}
