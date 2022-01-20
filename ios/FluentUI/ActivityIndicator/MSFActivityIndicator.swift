//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// UIKit wrapper that exposes the SwiftUI Activity Indicator implementation
@objc public class MSFActivityIndicator: ControlHostingContainer {

    /// Creates a new MSFActivityIndicator instance.
    /// - Parameters:
    ///   - size: The MSFActivityIndicatorSize value used by the Activity Indicator.
    @objc public init(size: MSFActivityIndicatorSize = .medium) {
        let activityIndicator = ActivityIndicator(size: size)
        state = activityIndicator.state
        super.init(AnyView(activityIndicator))
    }

    /// The object that groups properties that allow control over the Activity Indicator appearance.
    @objc public let state: MSFActivityIndicatorState
}
