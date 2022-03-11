//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// Common wrapper for hosting and exposing SwiftUI components to UIKit-based clients.
open class ControlHostingContainer: NSObject {

    /// The UIView representing the wrapped SwiftUI view.
    @objc public var view: UIView {
        return hostingController.view
    }

    /// Initializes and returns an instance of `ControlHostingContainer` that wraps `controlView`.
    ///
    /// Unfortunately this class can't use Swift generics, which are incompatible with Objective-C interop. Instead we have to wrap
    /// the control view in an `AnyView.`
    ///
    /// - Parameter controlView: An `AnyView`-wrapped component to host.
    init(_ controlView: AnyView, disableSafeAreaInsets: Bool = true) {
        self.controlView = controlView
        super.init()

        if disableSafeAreaInsets {
            hostingController.disableSafeAreaInsets()
        }

        // We need to observe theme changes, and use them to update our wrapped control.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)

        // Set the initial appearance of our control.
        self.updateRootView()
        view.backgroundColor = UIColor.clear
    }

    @objc private func themeDidChange(_ notification: Notification) {
        updateRootView()
    }

    private func updateRootView() {
        self.hostingController.rootView = tokenizedView
    }

    private var currentFluentTheme: FluentTheme {
        if let windowFluentTheme = self.view.window?.fluentTheme {
            return windowFluentTheme
        } else {
            return FluentThemeKey.defaultValue
        }
    }

    private var tokenizedView: AnyView {
        return AnyView(controlView
                        .fluentTheme(currentFluentTheme)
                        .onAppear { [weak self] in
                            // We don't usually have a window at construction time, so fetch our
                            // custom theme during `onAppear`
                            self?.updateRootView()
                        }
        )
    }

    private let hostingController: FluentUIHostingController = .init(rootView: AnyView(EmptyView()))
    private let controlView: AnyView
    private var themeObserver: NSObjectProtocol?
}
