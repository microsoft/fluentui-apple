//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// UIKit wrapper that exposes the SwiftUI PersonaButtonCarousel implementation
@objc open class MSFPersonaButtonCarousel: NSObject, FluentUIWindowProvider {

    // MARK: - Public API

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc open var state: MSFPersonaCarouselState {
        return self.personaButtonCarousel.state
    }

    @objc public init(size: MSFPersonaButtonSize = .large,
                      theme: FluentUIStyle? = nil) {
        super.init()

        personaButtonCarousel = PersonaButtonCarousel(size: size)

        hostingController = UIHostingController(rootView: AnyView(personaButtonCarousel
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

    private var hostingController: UIHostingController<AnyView>!

    private var personaButtonCarousel: PersonaButtonCarousel!
}
