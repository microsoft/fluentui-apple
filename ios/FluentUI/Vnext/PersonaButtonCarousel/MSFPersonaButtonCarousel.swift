//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Delegate interface for MSFPersonaButtonCarousel
@objc public protocol MSFPersonaButtonCarouselDelegate: AnyObject {
    /// Notifies that the user has tapped on a persona button
    ///
    /// - Parameters:
    ///   - personaData: the `PersonaData` instance of the tapped persona
    ///   - index: the tapped persona's index in the current array of `PersonaData`
    @objc optional func didTap(on personaData: PersonaData, at index: Int)
}

/// UIKit wrapper that exposes the SwiftUI PersonaGrid implementation
@objc open class MSFPersonaButtonCarousel: NSObject, FluentUIWindowProvider {

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc open weak var delegate: MSFPersonaButtonCarouselDelegate?

    @objc public init(size: MSFPersonaButtonSize = .large,
                      personas: [PersonaData] = [],
                      theme: FluentUIStyle? = nil) {
        super.init()

        personaButtonCarousel = PersonaButtonCarousel(size: size, personaButtons: personas.map { personaData in
            MSFPersonaButtonStateImpl(size: size, personaData: personaData)
        })

        personaButtonCarousel.state.onTapAction = { [weak self] (personaButtonState: MSFPersonaButtonState, index: Int) in
            // Unfortunate that we have to have this cast, but the alternative is to expose
            // the internal `PersonaData` property on the public interface
            guard let personaData = (personaButtonState as? MSFPersonaButtonStateImpl)?.personaData else {
                fatalError("Unknown type passed in as MSFPersonaButtonState")
            }
            self?.delegate?.didTap?(on: personaData, at: index)
        }

        hostingController = UIHostingController(rootView: AnyView(personaButtonCarousel
                                                                    .windowProvider(self)
                                                                    .modifyIf(theme != nil, { personaButtonCarousel in
                                                                        personaButtonCarousel.customTheme(theme!)
                                                                    })))
        hostingController.disableSafeAreaInsets()
        view.backgroundColor = UIColor.clear
    }

    @objc public func count() -> Int {
        return self.personaButtonCarousel.state.buttons.count
    }

    @objc public func append(_ personaData: PersonaData) {
        let persona = MSFPersonaButtonStateImpl(size: self.state.buttonSize, personaData: personaData)
        self.personaButtonCarousel.state.buttons.append(persona)
    }

    @objc public func remove(at index: Int) {
        if index >= count() {
            fatalError("Attempting to remove item outside bounds of carousel")
        }
        self.personaButtonCarousel.state.buttons.remove(at: index)
    }

    var window: UIWindow? {
        return self.view.window
    }

    private var state: MSFPersonaCarouselState {
        return self.personaButtonCarousel.state
    }

    private var hostingController: UIHostingController<AnyView>!

    private var personaButtonCarousel: PersonaButtonCarousel!
}
