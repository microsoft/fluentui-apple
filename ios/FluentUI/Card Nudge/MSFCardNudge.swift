//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// UIKit wrapper that exposes the SwiftUI `CardNudge` implementation
@objc open class MSFCardNudge: ControlHostingView {

    /// Creates a new MSFCardNudge instance.
    /// - Parameters:
    ///   - style: The MSFCardNudgeStyle value used by the CardNudge.
    ///   - title: The primary text to display in the CardNudge.
    /// - Returns: An initialized MSFCardNudge instance.
    @objc public init(style: MSFCardNudgeStyle,
                      title: String) {
        let cardNudge = CardNudge(style: style, title: title)
        state = cardNudge.state
        super.init(AnyView(cardNudge))
    }

    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

   /// The object that groups properties that allow control over the Card Nudge appearance.
    @objc public let state: MSFCardNudgeState
}
