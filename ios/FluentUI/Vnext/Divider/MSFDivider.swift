//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// UIKit wrapper that exposes the SwiftUI Divider implementation.
@objc open class MSFDivider: ControlHostingView {
    /// Creates a new MSFDivider instance.
    ///  - Parameters:
    ///   - orientation: The DividerOrientation used by the Divider.
    ///   - spacing: The DividerSpacing used by the Divider.
    @objc public init(orientation: MSFDividerOrientation = .horizontal,
                      spacing: MSFDividerSpacing = .none) {
        let divider = FluentDivider(orientation: orientation, spacing: spacing)
        state = divider.state
        tokenSet = divider.tokenSet
        super.init(AnyView(divider))
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// The object that groups properties that allow control over the Divider appearance.
    @objc public let state: MSFDividerState

    /// The default thickness for the divider: half pt.
    @objc public static var thickness: CGFloat { return DividerTokenSet.thickness }

    /// Access to the control's `ControlTokenSet` for reading default values and providing overrides.
    public let tokenSet: DividerTokenSet
}
