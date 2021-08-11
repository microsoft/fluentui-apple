//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Combine
import SwiftUI
import UIKit

/// UIKit wrapper that exposes the SwiftUI Button implementation
@objc open class MSFButton: NSObject,
                            FluentUIWindowProvider,
                            UIGestureRecognizerDelegate {

    @objc open var action: ((_ sender: MSFButton) -> Void)?

    @objc open var state: MSFButtonState {
        return self.buttonView.state
    }

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc public convenience init(style: MSFButtonStyle = .secondary,
                                  size: MSFButtonSize = .large,
                                  action: ((_ sender: MSFButton) -> Void)?) {
        self.init(style: style,
                  size: size,
                  action: action,
                  theme: nil)
    }

    @objc public init(style: MSFButtonStyle = .secondary,
                      size: MSFButtonSize = .large,
                      action: ((_ sender: MSFButton) -> Void)?,
                      theme: FluentUIStyle? = nil) {
        super.init()
        initialize(style: style,
                   size: size,
                   action: action,
                   theme: theme)
    }

    // MARK: - UIGestureRecognizerDelegate

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Prevents the Large Content Viewer gesture recognizer from cancelling the SwiftUI button gesture recognizers.
        return true
    }

    // MARK: - FluentUIWindowProvider

    var window: UIWindow? {
        return self.view.window
    }

    // MARK: - Private members

    private func initialize(style: MSFButtonStyle = .secondary,
                            size: MSFButtonSize = .large,
                            action: ((_ sender: MSFButton) -> Void)?,
                            theme: FluentUIStyle? = nil) {
        self.action = action
        buttonView = MSFButtonView(action: {
            self.action?(self)
        },
        style: style,
        size: size)

        hostingController = UIHostingController(rootView: AnyView(buttonView
                                                                    .windowProvider(self)
                                                                    .modifyIf(theme != nil, { buttonView in
                                                                        buttonView.customTheme(theme!)
                                                                    })))
        view.backgroundColor = UIColor.clear
        setupLargeContentViewer()
    }

    private func setupLargeContentViewer() {
        let largeContentViewerInteraction = UILargeContentViewerInteraction()
        view.addInteraction(largeContentViewerInteraction)
        largeContentViewerInteraction.gestureRecognizerForExclusionRelationship.delegate = self
        view.scalesLargeContentImage = true
        view.showsLargeContentViewer = buttonView.tokens.style.isFloatingStyle

        imagePropertySubscriber = buttonView.state.$image.sink { buttonImage in
            self.view.largeContentImage = buttonImage
        }

        textPropertySubscriber = buttonView.state.$text.sink { buttonText in
            self.view.largeContentTitle = buttonText
        }
    }

    private var textPropertySubscriber: AnyCancellable?

    private var imagePropertySubscriber: AnyCancellable?

    private var hostingController: UIHostingController<AnyView>!

    private var buttonView: MSFButtonView!
}
