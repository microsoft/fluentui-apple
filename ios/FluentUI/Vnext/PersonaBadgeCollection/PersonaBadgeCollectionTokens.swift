//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

/// Representation of design tokens to controls at runtime which interfaces with the Design Token System auto-generated code.
/// Updating these properties causes the SwiftUI controls to update its view automatically.
class MSFPersonaBadgeCollectionTokens: MSFTokensBase, ObservableObject {
    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }

    override func updateForCurrentTheme() {
        // TODO: Create PersonaBadgeCollection
    }
}
