//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

/// Localized strings available for use in custom UI components.
@objc(MSFLocalizedStrings)
public class LocalizedStrings: NSObject {
    /// The accessibility label that should be applied for the back button on a navigation bar.
    @objc public static var accessibilityNavigationBarBackLabel: String {
        "Accessibility.NavigationBar.BackLabel".localized
    }
}
