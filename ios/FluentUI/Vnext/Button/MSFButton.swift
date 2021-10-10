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

    /// Closure that handles the button tap event.
    @objc open var action: ((_ sender: MSFButton) -> Void)?

    /// The object that groups properties that allow control over the button appearance.
    @objc open var state: MSFButtonState {
        return self.buttonView.state
    }

    /// The UIView representing the button.
    @objc open var view: UIView {
        return hostingController.view
    }

    /// Creates a new MSFButton instance.
    /// - Parameters:
    ///   - style: The MSFButtonStyle used by the button. Defaults to secondary.
    ///   - size: The MSFButtonSize value used by the button. Defaults to large.
    ///   - action: Closure that handles the button tap event.
    @objc public convenience init(style: MSFButtonStyle = .secondary,
                                  size: MSFButtonSize = .large,
                                  action: ((_ sender: MSFButton) -> Void)?) {
        self.init(style: style,
                  size: size,
                  theme: nil,
                  action: action)
    }

    /// Creates a new MSFButton instance.
    /// - Parameters:
    ///   - style: The MSFButtonStyle used by the button. Defaults to secondary.
    ///   - size: The MSFButtonSize value used by the button. Defaults to large.
    ///   - theme: The FluentUIStyle instance representing the theme to be overriden for this button.
    ///   - action: Closure that handles the button tap event.
    @objc public init(style: MSFButtonStyle = .secondary,
                      size: MSFButtonSize = .large,
                      theme: FluentUIStyle? = nil,
                      action: ((_ sender: MSFButton) -> Void)?) {
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
        buttonView = FluentButton(style: style,
                                  size: size) { [weak self] in
            guard let strongSelf = self else {
                return
            }

            strongSelf.action?(strongSelf)
        }

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

    private var buttonView: FluentButton!
}
