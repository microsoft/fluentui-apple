//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// UIKit wrapper that exposes the SwiftUI PersonaButton implementation
@objc open class MSFPersonaButtonView: NSObject, FluentUIWindowProvider, MSFPersonaButtonAppearance, MSFPersonaButtonData {

    @objc open var view: UIView {
        return hostingController.view
    }

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

    // MARK: - MSFPersonaButtonAppearance

    @objc public var buttonSize: MSFPersonaButtonSize {
        get {
            return self.personaButton.state.buttonSize
        }
        set {
            self.personaButton.state.buttonSize = newValue
        }
    }

    @objc public var onTapAction: (() -> Void)? {
        get {
            return self.personaButton.state.onTapAction
        }
        set {
            self.personaButton.state.onTapAction = newValue
        }
    }

    // MARK: - MSFPersonaButtonData

    @objc public var avatarBackgroundColor: UIColor? {
        get {
            return self.personaButton.state.avatarBackgroundColor
        }
        set {
            self.personaButton.state.avatarBackgroundColor = newValue
        }
    }

    @objc public var avatarForegroundColor: UIColor? {
        get {
            return self.personaButton.state.avatarForegroundColor
        }
        set {
            self.personaButton.state.avatarForegroundColor = newValue
        }
    }
    @objc public var hasPointerInteraction: Bool {
        get {
            return self.personaButton.state.hasPointerInteraction
        }
        set {
            self.personaButton.state.hasPointerInteraction = newValue
        }
    }
    @objc public var hasRingInnerGap: Bool {
        get {
            return self.personaButton.state.hasRingInnerGap
        }
        set {
            self.personaButton.state.hasRingInnerGap = newValue
        }
    }
    @objc public var image: UIImage? {
        get {
            return self.personaButton.state.image
        }
        set {
            self.personaButton.state.image = newValue
        }
    }
    @objc public var imageBasedRingColor: UIImage? {
        get {
            return self.personaButton.state.imageBasedRingColor
        }
        set {
            self.personaButton.state.imageBasedRingColor = newValue
        }
    }
    @objc public var isOutOfOffice: Bool {
        get {
            return self.personaButton.state.isOutOfOffice
        }
        set {
            self.personaButton.state.isOutOfOffice = newValue
        }
    }
    @objc public var isRingVisible: Bool {
        get {
            return self.personaButton.state.isRingVisible
        }
        set {
            self.personaButton.state.isRingVisible = newValue
        }
    }
    @objc public var isTransparent: Bool {
        get {
            return self.personaButton.state.isTransparent
        }
        set {
            self.personaButton.state.isTransparent = newValue
        }
    }
    @objc public var presence: MSFAvatarPresence {
        get {
            return self.personaButton.state.presence
        }
        set {
            self.personaButton.state.presence = newValue
        }
    }
    @objc public var primaryText: String? {
        get {
            return self.personaButton.state.primaryText
        }
        set {
            self.personaButton.state.primaryText = newValue
        }
    }
    @objc public var ringColor: UIColor? {
        get {
            return self.personaButton.state.ringColor
        }
        set {
            self.personaButton.state.ringColor = newValue
        }
    }
    @objc public var secondaryText: String? {
        get {
            return self.personaButton.state.secondaryText
        }
        set {
            self.personaButton.state.secondaryText = newValue
        }
    }

    // MARK: - FluentUIWindowProvider

    var window: UIWindow? {
        return self.view.window
    }

    private var hostingController: UIHostingController<AnyView>!

    private var personaButton: PersonaButton!
}
