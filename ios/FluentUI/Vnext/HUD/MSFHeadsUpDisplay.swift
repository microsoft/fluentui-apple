//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// UIKit wrapper that exposes the SwiftUI Heads-up display implementation
open class MSFHeadsUpDisplay: ControlHostingView {

    /// Creates a new MSFActivityIndicator instance.
    /// - Parameters:
    ///   - type: The MSFHUDType value used by the Heads-up display.
    ///   - label: The label for the Heads-up display.
    ///   - tapAction: The action executed when the Heads-up display is tapped.
    public init(type: HUDType = .activity,
                label: String?,
                tapAction: (() -> Void)? = nil) {
        let hudView = HeadsUpDisplay(type: type,
                                     label: label,
                                     tapAction: tapAction)
        state = hudView.state
        super.init(AnyView(hudView))
    }

    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// The object that groups properties that allow control over the Activity Indicator appearance.
    public var state: MSFHUDState
}
