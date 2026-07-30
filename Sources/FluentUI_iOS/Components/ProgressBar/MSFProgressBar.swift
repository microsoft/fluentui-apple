//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import SwiftUI
import UIKit

/// UIKit wrapper that exposes the SwiftUI Progress Bar implementation
@objc open class MSFProgressBar: ControlHostingView {

    /// Creates a new MSFProgressBar instance.
    @objc public init() {
        let progressBar = ProgressBar()
        state = progressBar.state
        super.init(AnyView(progressBar))
    }

    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// The object that groups properties that allow control over the Progress Bar appearance.
    @objc public let state: MSFProgressBarState
}
