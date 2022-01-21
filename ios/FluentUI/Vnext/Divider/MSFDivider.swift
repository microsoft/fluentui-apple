//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// UIKit wrapper that exposes the SwiftUI Divider implementation.
@objc public class MSFDivider: ControlHostingContainer {
    /// The object that groups properties that allow control over the Divider appearance.
    @objc public let state: MSFDividerState

    /// Creates a new MSFDivider instance.
    ///  - Parameters:
    ///   - orientation: The DividerOrientation used by the Divider.
    ///   - spacing: The DividerSpacing used by the Divider.
    @objc public convenience init(orientation: MSFDividerOrientation = .horizontal,
                                  spacing: MSFDividerSpacing = .none) {
        self.init(orientation: orientation,
                  spacing: spacing,
                  theme: nil)
    }

    /// Creates a new MSFDivider instance.
    ///  - Parameters:
    ///   - orientation: The DividerOrientation used by the Divider.
    ///   - spacing: The DividerSpacing used by the Divider.
    ///   - theme: The FluentUIStyle instance representing the theme to be overriden for this Divider.
    @objc public init(orientation: MSFDividerOrientation,
                      spacing: MSFDividerSpacing,
                      theme: FluentUIStyle?) {
        let divider = FluentDivider(orientation: orientation, spacing: spacing)
        state = divider.state
        super.init(AnyView(divider))
    }
}
