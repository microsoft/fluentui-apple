//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// UIKit wrapper that exposes the SwiftUI Divider implementation.
@objc open class MSFDivider: ControlHostingContainer {
    /// Creates a new MSFDivider instance.
    ///  - Parameters:
    ///   - orientation: The DividerOrientation used by the Divider.
    ///   - spacing: The DividerSpacing used by the Divider.
    @objc public init(orientation: MSFDividerOrientation = .horizontal,
                      spacing: MSFDividerSpacing = .none) {
        let divider = FluentDivider(orientation: orientation, spacing: spacing)
        state = divider.state
        super.init(AnyView(divider))
    }

    /// The object that groups properties that allow control over the Divider appearance.
    @objc public let state: MSFDividerState
}
