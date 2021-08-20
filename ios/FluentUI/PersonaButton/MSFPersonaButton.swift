//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// UIKit wrapper that exposes the SwiftUI PersonaButton implementation
@objc open class MSFPersonaButton: NSObject, FluentUIWindowProvider {

    /// The UIView representing the PersonaButton.
    @objc open var view: UIView {
        return hostingController.view
    }

    /// The object that groups properties that allow control over the PersonaButton appearance.
    @objc open var state: MSFPersonaButtonState {
        return personaButton.state
    }

    /// Creates a new MSFPersonaButton instance.
    /// - Parameters:
    ///   - size: The MSFPersonaButtonSize value used by the PersonaButton.
    @objc public convenience init(size: MSFPersonaButtonSize = .large) {
        self.init(size: size, theme: nil)
    }

    /// Creates a new MSFPersonaButton instance.
    /// - Parameters:
    ///   - size: The MSFPersonaButtonSize value used by the PersonaButton.
    ///   - theme: The FluentUIStyle instance representing the theme to be overriden for this PersonaButton.
    @objc public init(size: MSFPersonaButtonSize = .large,
                      theme: FluentUIStyle? = nil) {
        super.init()

        personaButton = PersonaButton(size: size)
        hostingController = UIHostingController(rootView: AnyView(personaButton
                                                                    .windowProvider(self)
                                                                    .modifyIf(theme != nil, { personaButton in
                                                                        personaButton.customTheme(theme!)
                                                                    })))
        hostingController.disableSafeAreaInsets()
        view.backgroundColor = UIColor.clear
    }

    // MARK: - FluentUIWindowProvider

    var window: UIWindow? {
        return self.view.window
    }

    private var hostingController: UIHostingController<AnyView>!

    private var personaButton: PersonaButton!
}
