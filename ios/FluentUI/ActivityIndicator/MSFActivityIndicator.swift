//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// UIKit wrapper that exposes the SwiftUI Activity Indicator implementation
@objc open class MSFActivityIndicator: ControlHostingContainer {

    /// Creates a new MSFActivityIndicator instance.
    /// - Parameters:
    ///   - size: The MSFActivityIndicatorSize value used by the Activity Indicator.
    @objc public init(size: MSFActivityIndicatorSize = .medium) {
        let activityIndicator = ActivityIndicator(size: size)
        state = activityIndicator.state
        super.init(AnyView(activityIndicator))
    }

    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// The object that groups properties that allow control over the Activity Indicator appearance.
    @objc public let state: MSFActivityIndicatorState
}
