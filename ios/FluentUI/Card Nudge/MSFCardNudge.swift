//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// UIKit wrapper that exposes the SwiftUI `CardNudge` implementation
@objc open class MSFCardNudge: NSObject, FluentUIWindowProvider {

    /// The UIView representing the CardNudge.
    @objc open var view: UIView {
        return hostingController.view
    }

    /// Creates a new MSFCardNudge instance.
    /// - Parameters:
    ///   - style: The MSFCardNudgeStyle value used by the CardNudge.
    ///   - title: The primary text to display in the CardNudge.
    ///   - theme: The FluentUIStyle instance representing the theme to be overriden for this CardNudge.
    @objc public init(style: MSFCardNudgeStyle,
                      title: String,
                      theme: FluentUIStyle? = nil) {
        super.init()

        cardNudge = CardNudge(style: style, title: title)
        hostingController = FluentUIHostingController(rootView: AnyView(cardNudge
                                                                            .windowProvider(self)
                                                                            .modifyIf(theme != nil, { cardNudge in
                                                                                cardNudge.customTheme(theme!)
                                                                            })))
        hostingController.disableSafeAreaInsets()
    }

    @objc public var state: MSFCardNudgeState {
        return cardNudge.state
    }

    // MARK: - FluentUIWindowProvider

    var window: UIWindow? {
        return self.view.window
    }

    // MARK: - Private helpers

    private var hostingController: FluentUIHostingController!
    private var cardNudge: CardNudge!
}
