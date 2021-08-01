//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// UIKit wrapper that exposes the SwiftUI `CardNudge` implementation
@objc open class MSFCardNudge: NSObject {

    @objc public init(style: CardNudgeStyle, title: String) {
        state = CardNudgeState(style: style, title: title)
        let cardNudge = CardNudge(state)
        self.hostingController = UIHostingController(rootView: AnyView(cardNudge))
    }

    @objc open lazy var view: UIView = {
        return CardNudgeWrapperView(state: self.state, hostedView: self.hostingController.view)
    }()

    @objc public var state: CardNudgeState!

    // MARK: - Private helpers

    private var hostingController: UIHostingController<AnyView>!
}

/// Custom view wrapper so we can override UIView's willMove(toWindow:).
/// Will be removed once we move to full vNext tokenized views.
class CardNudgeWrapperView: UIView {
    var state: CardNudgeState

    init(state: CardNudgeState, hostedView: UIView) {
        self.state = state
        super.init(frame: .zero)
        embedHostedView(hostedView)
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    func embedHostedView(_ hostedView: UIView) {
        self.addSubview(hostedView)
        hostedView.translatesAutoresizingMaskIntoConstraints = false

        let constraints: [NSLayoutConstraint] = [
            hostedView.topAnchor.constraint(equalTo: self.topAnchor),
            hostedView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            hostedView.leftAnchor.constraint(equalTo: self.leftAnchor),
            hostedView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ]
        self.addConstraints(constraints)
    }

    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        state.hostingWindow = newWindow
    }
}
