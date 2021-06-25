//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// UIKit wrapper that exposes the SwiftUI PersonaGrid implementation
@objc open class MSFPersonaButtonCarousel: NSObject, FluentUIWindowProvider, MSFPersonaCarouselState {

    // MARK: - Public API

    @objc open var view: UIView {
        return hostingController.view
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

    @objc public var count: Int {
        return self.personaButtonCarousel.state.buttons.count
    }

    /// Adds a `PersonaButton` to the carousel, and returns an optional reference for additional property setting
    ///
    /// - Parameters:
    ///   - primaryText: The primary text to appear in the `PersonaButton`
    ///   - secondaryText: The secondary text to appear in the `PersonaButton`, below `primaryText`
    ///   - image: The image to use as the persona's avatar
    ///
    /// - Returns: An optional reference to the added `PersonaButton`, which can be used to set additional properties or to update later
    @discardableResult @objc public func add(primaryText: String?, secondaryText: String?, image: UIImage?) -> MSFPersonaButtonData {

        let persona = MSFPersonaButtonStateImpl(size: self.state.buttonSize)

        // Set passed-in properties
        persona.primaryText = primaryText
        persona.secondaryText = secondaryText
        persona.image = image

        self.personaButtonCarousel.state.buttons.append(persona)

        return persona
    }

    /// Removes a `PersonaButton` from the carousel.
    ///
    /// - Parameters:
    ///   - personaData: The reference to a `PersonaButton` to be removed.
    @objc public func remove(_ personaData: MSFPersonaButtonData) {
        self.personaButtonCarousel.state.buttons.removeAll { personaState in
            personaState.isEqual(personaData)
        }
    }

    /// Removes a `PersonaButton` from the carousel at the given index.
    ///
    /// - Parameters:
    ///   - index: The index at which the `PersonaButton` to be removed can be currently found.
    @objc public func remove(at index: Int) {
        if index >= count {
            fatalError("Attempting to remove item outside bounds of carousel")
        }
        self.personaButtonCarousel.state.buttons.remove(at: index)
    }

    // MARK: - MSFPersonaCarouselState

    @objc public var buttonSize: MSFPersonaButtonSize {
        return self.state.buttonSize
    }

    @objc public var onTapAction: ((MSFPersonaButtonData, Int) -> Void)? {
        get {
            return self.state.onTapAction
        }
        set {
            self.state.onTapAction = newValue
        }
    }

    // MARK: - FluentUIWindowProvider

    var window: UIWindow? {
        return self.view.window
    }

    // MARK: - private properties

    private var state: MSFPersonaCarouselStateImpl {
        return self.personaButtonCarousel.state
    }

    private var hostingController: UIHostingController<AnyView>!

    private var personaButtonCarousel: PersonaButtonCarousel!
}
