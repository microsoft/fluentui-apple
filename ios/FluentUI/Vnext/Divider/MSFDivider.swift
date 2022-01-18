//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// UIKit wrapper that exposes the SwiftUI Divider implementation.
@objc open class MSFDivider: NSObject, FluentUIWindowProvider {

    /// The UIView representing the Fluent Divider.
    @objc open var view: UIView {
        return hostingController.view
    }

    /// The object that groups properties that allow control over the Divider appearance.
    @objc open var state: MSFDividerState {
        return divider.state
    }

    /// Creates a new MSFDivider instance.
    ///  - Parameters:
    ///   - orientation: The DividerOrientation used by the Divider.
    ///   - spacing: The DividerSpacing used by the Divider.
    @objc public convenience init(orientation: MSFDividerOrientation = .horizontal,
                                  spacing: MSFDividerSpacing = .none) {
        self.init(orientation: orientation,
                  spacing: spacing,
                  theme: nil)
    }

    /// Creates a new MSFDivider instance.
    ///  - Parameters:
    ///   - orientation: The DividerOrientation used by the Divider.
    ///   - spacing: The DividerSpacing used by the Divider.
    ///   - theme: The FluentUIStyle instance representing the theme to be overriden for this Divider.
    @objc public init(orientation: MSFDividerOrientation,
                      spacing: MSFDividerSpacing,
                      theme: FluentUIStyle?) {
        super.init()

        divider = FluentDivider(orientation: orientation, spacing: spacing)
        hostingController = FluentUIHostingController(rootView: AnyView(divider
                                                                            .windowProvider(self)
                                                                            .modifyIf(theme != nil, {divider in
                                                                                divider.customTheme(theme!)
                                                                            })))
        hostingController.disableSafeAreaInsets()
        view.backgroundColor = UIColor.clear
    }

    var window: UIWindow? {
        return self.view.window
    }

    private var hostingController: FluentUIHostingController!

    private var divider: FluentDivider!
}
