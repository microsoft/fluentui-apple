//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// Common wrapper for hosting and exposing SwiftUI components to UIKit-based clients.
public class ControlHostingContainer: NSObject {

    /// The UIView representing the SwiftUI view.
    @objc public var view: UIView {
        return hostingController.view
    }

    /// A custom `BrandColors` instance that should be used for styling this control, or `nil` if none exists.
    public var brandColors: BrandColors? {
        didSet {
            updateRootView()
        }
    }

    init(_ controlView: AnyView) {
        self.controlView = controlView
        super.init()

        hostingController.disableSafeAreaInsets()

        // We need to observe theme changes, and use them to update our wrapped control.
        NotificationCenter.default.addObserver(forName: Notification.Name.didChangeTheme,
                                               object: nil,
                                               queue: .main) { [weak self] _ in
            if let strongSelf = self {
                strongSelf.updateRootView()
            }
        }

        // Set the initial appearance of our control.
        self.updateRootView()
    }

    private func updateRootView() {
        self.hostingController.rootView = tokenizedView
    }

    private var currentBrandColors: BrandColors? {
        if let overriddenBrandColors = brandColors {
            return overriddenBrandColors
        } else if let windowBrandColors = self.view.window?.brandColors {
            return windowBrandColors
        } else {
            return nil
        }
    }

    private var tokenizedView: AnyView {
        return AnyView(controlView
                        .brandColors(currentBrandColors)
                        .onAppear { [weak self] in
                            // We don't usually have a window at construction time, so fetch our
                            // brand colors during `onAppear`
                            self?.updateRootView()
                        }
        )
    }

    private let hostingController: FluentUIHostingController = .init(rootView: AnyView(EmptyView()))
    private let controlView: AnyView
}
