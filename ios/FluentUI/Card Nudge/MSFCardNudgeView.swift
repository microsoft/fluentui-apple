//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// UIKit wrapper that exposes the SwiftUI CardNudgeView implementation
@objc open class MSFCardNudgeView: MSFHostingContainerView {

    @objc public var state: CardNudgeViewState!

    @objc public init(style: CardNudgeViewStyle, title: String) {
        state = CardNudgeViewState(style: style, title: title)
        let cardNudgeView = CardNudgeView(state)
        super.init(hostedView: AnyView(cardNudgeView))
    }

    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        state.hostingWindow = newWindow
    }
}
