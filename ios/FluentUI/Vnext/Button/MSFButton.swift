//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Combine
import SwiftUI
import UIKit

/// UIKit wrapper that exposes the SwiftUI Button implementation
@objc public class MSFButton: ControlHostingContainer,
                              UIGestureRecognizerDelegate {

    /// Closure that handles the button tap event.
    @objc public var action: ((_ sender: MSFButton) -> Void)?

    /// The object that groups properties that allow control over the button appearance.
    @objc public let configuration: MSFButtonConfiguration

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
        configuration = buttonView.configuration
        super.init(AnyView(buttonView))

        // After initialization, set the new action to refer to our own.
        buttonView.configuration.action = { [weak self] in
            guard let strongSelf = self else {
                return
            }

            strongSelf.action?(strongSelf)
        }
        setupLargeContentViewer()
    }

    private func setupLargeContentViewer() {
        let largeContentViewerInteraction = UILargeContentViewerInteraction()
        view.addInteraction(largeContentViewerInteraction)
        largeContentViewerInteraction.gestureRecognizerForExclusionRelationship.delegate = self
        view.scalesLargeContentImage = true
        view.showsLargeContentViewer = configuration.style.isFloatingStyle

        // Unpleasant workaround to get the implementation of MSFButtonConfiguration.
        // Can be removed once we switch to Xcode 13.2 and can use
        // `.accessibilityShowsLargeContentViewerIfAvailable()`.
        guard let configurationImpl = configuration as? MSFButtonConfigurationImpl else {
            return
        }

        imagePropertySubscriber = configurationImpl.$image.sink { buttonImage in
            self.view.largeContentImage = buttonImage
        }

        textPropertySubscriber = configurationImpl.$text.sink { buttonText in
            self.view.largeContentTitle = buttonText
        }
    }

    private var textPropertySubscriber: AnyCancellable?

    private var imagePropertySubscriber: AnyCancellable?
}
