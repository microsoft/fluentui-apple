//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// UIKit wrapper that exposes the SwiftUI Indeterminate Progress Bar implementation
@objc open class MSFIndeterminateProgressBar: ControlHostingContainer {

    /// Creates a new MSFIndeterminateProgressBar instance.
    @objc public init() {
        let indeterminateProgressBar = IndeterminateProgressBar()
        state = indeterminateProgressBar.state
        super.init(AnyView(indeterminateProgressBar))
    }

    /// The object that groups properties that allow control over the Indeterminate Progress Bar appearance.
    @objc public let state: MSFIndeterminateProgressBarState
}
