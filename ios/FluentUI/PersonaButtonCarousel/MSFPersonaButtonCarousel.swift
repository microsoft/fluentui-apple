//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// UIKit wrapper that exposes the SwiftUI PersonaButtonCarousel implementation
@objc open class MSFPersonaButtonCarousel: NSObject, FluentUIWindowProvider {

    // MARK: - Public API

    /// The UIView representing the PersonaButtonCarousel.
    @objc open var view: UIView {
        return hostingController.view
    }

    /// The object that groups properties that allow control over the PersonaButtonCarousel appearance.
    @objc open var state: MSFPersonaButtonCarouselState {
        return self.personaButtonCarousel.state
    }

    /// Creates a new MSFPersonaButtonCarousel instance.
    /// - Parameters:
    ///   - size: The MSFPersonaButtonSize value used by the PersonaButtonCarousel.
    @objc public convenience init(size: MSFPersonaButtonSize = .large) {
        self.init(size: size, theme: nil)
    }

    /// Creates a new MSFPersonaButtonCarousel instance.
    /// - Parameters:
    ///   - size: The MSFPersonaButtonSize value used by the PersonaButtonCarousel.
    ///   - theme: The FluentUIStyle instance representing the theme to be overriden for this PersonaButtonCarousel.
    @objc public init(size: MSFPersonaButtonSize = .large,
                      theme: FluentUIStyle? = nil) {
        super.init()

        personaButtonCarousel = PersonaButtonCarousel(size: size)

        hostingController = FluentUIHostingController(rootView: AnyView(personaButtonCarousel
                                                                            .windowProvider(self)
                                                                            .modifyIf(theme != nil, { personaButtonCarousel in
                                                                                personaButtonCarousel.customTheme(theme!)
                                                                            })))
        hostingController.disableSafeAreaInsets()
        view.backgroundColor = UIColor.clear
    }

    // MARK: - FluentUIWindowProvider

    var window: UIWindow? {
        return self.view.window
    }

    // MARK: - private properties

    private var hostingController: FluentUIHostingController!

    private var personaButtonCarousel: PersonaButtonCarousel!
}
