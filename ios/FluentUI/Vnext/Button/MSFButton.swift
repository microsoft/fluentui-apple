//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Combine
import SwiftUI
import UIKit

/// UIKit wrapper that exposes the SwiftUI Button implementation
@objc open class MSFButton: ControlHostingView,
                            UIGestureRecognizerDelegate {

    /// Closure that handles the button tap event.
    @objc public var action: ((_ sender: MSFButton) -> Void)?

    /// The object that groups properties that allow control over the button appearance.
    @objc public let state: MSFButtonState

    /// Creates a new MSFButton instance.
    /// - Parameters:
    ///   - style: The MSFButtonStyle used by the button. Defaults to secondary.
    ///   - size: The MSFButtonSize value used by the button. Defaults to large.
    ///   - action: Closure that handles the button tap event.
    @objc public init(style: MSFButtonStyle = .secondary,
                      size: MSFButtonSize = .large,
                      action: ((_ sender: MSFButton) -> Void)?) {
        self.action = action
        let buttonView = FluentButton(style: style,
                                      size: size,
                                      action: {})
        state = buttonView.state
        super.init(AnyView(buttonView))

        // After initialization, set the new action to refer to our own.
        buttonView.state.action = { [weak self] in
            guard let strongSelf = self else {
                return
            }

            strongSelf.action?(strongSelf)
        }
        setupLargeContentViewer()
    }

    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    private func setupLargeContentViewer() {
        let largeContentViewerInteraction = UILargeContentViewerInteraction()
        self.addInteraction(largeContentViewerInteraction)
        largeContentViewerInteraction.gestureRecognizerForExclusionRelationship.delegate = self
        self.scalesLargeContentImage = true
        self.showsLargeContentViewer = state.style.isFloatingStyle

        // Unpleasant workaround to get the implementation of MSFButtonState.
        // Can be removed once we switch to Xcode 13.2 and can use
        // `.accessibilityShowsLargeContentViewerIfAvailable()`.
        guard let stateImpl = state as? MSFButtonStateImpl else {
            return
        }

        imagePropertySubscriber = stateImpl.$image.sink { buttonImage in
            self.largeContentImage = buttonImage
        }

        textPropertySubscriber = stateImpl.$text.sink { buttonText in
            self.largeContentTitle = buttonText
        }
    }

    private var textPropertySubscriber: AnyCancellable?

    private var imagePropertySubscriber: AnyCancellable?
}
