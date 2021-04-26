//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// `MSFPersonaViewState` contains  PersonaView properties in addition to  MSFAvatarState protocol.
///
/// `TrailingAccessoryView` for `title` and `subtitle` allows for any custom UIView
/// following each respective label.
///
/// `onTapAction` provides tap gesture for PersonaView.
///
@objc public protocol MSFPersonaViewState: MSFAvatarState {
    var titleTrailingAccessoryView: UIView? { get set }
    var subtitleTrailingAccessoryView: UIView? { get set }
    var onTapAction: (() -> Void)? { get set }
}

/// Properties that make up PersonaView content
class MSFPersonaViewStateImpl: MSFListCellState, MSFPersonaViewState {
    init(avatarState: MSFAvatarState) {
        self.avatarState = avatarState
    }

    var image: UIImage? {
        get {
            return avatarState.image
        }

        set {
            avatarState.image = newValue
        }
    }

    var primaryText: String? {
        get {
            return avatarState.primaryText
        }

        set {
            avatarState.primaryText = newValue
            title = newValue ?? ""
        }
    }

    var secondaryText: String? {
        get {
            return avatarState.secondaryText
        }

        set {
            avatarState.secondaryText = newValue
            subtitle = newValue ?? ""
        }
    }

    var ringColor: UIColor? {
        get {
            return avatarState.ringColor
        }

        set {
            avatarState.ringColor = newValue
        }
    }

    var backgroundColor: UIColor? {
        get {
            return avatarState.backgroundColor
        }

        set {
            avatarState.backgroundColor = newValue
        }
    }

    var foregroundColor: UIColor? {
        get {
            return avatarState.foregroundColor
        }

        set {
            avatarState.foregroundColor = newValue
        }
    }

    var presence: MSFAvatarPresence {
        get {
            return avatarState.presence
        }

        set {
            avatarState.presence = newValue
        }
    }

    var hasPointerInteraction: Bool {
        get {
            return avatarState.hasPointerInteraction
        }

        set {
            avatarState.hasPointerInteraction = newValue
        }
    }

    var isRingVisible: Bool {
        get {
            return avatarState.isRingVisible
        }

        set {
            avatarState.isRingVisible = newValue
        }
    }

    var isTransparent: Bool {
        get {
            return avatarState.isTransparent
        }

        set {
            avatarState.isTransparent = newValue
        }
    }

    var isOutOfOffice: Bool {
        get {
            return avatarState.isOutOfOffice
        }

        set {
            avatarState.isOutOfOffice = newValue
        }
    }

    private var avatarState: MSFAvatarState
}

/// View for PersonaView
public struct PersonaView: View {
    @ObservedObject var state: MSFPersonaViewStateImpl
    @ObservedObject var tokens: MSFPersonaViewTokens

    public init() {
        tokens = MSFPersonaViewTokens()
        let avatar = AvatarView(style: .default, size: .xlarge)
        state = MSFPersonaViewStateImpl(avatarState: avatar.state)
        state.leadingView = AnyView(avatar)
        state.leadingViewSize = .xlarge
        state.titleTrailingAccessoryView = state.titleTrailingAccessoryView
        state.subtitleTrailingAccessoryView = state.subtitleTrailingAccessoryView
        state.onTapAction = state.onTapAction
        state.layoutType = .threeLines
    }

    public var body: some View {
        MSFListCellView(state: state, tokens: tokens, windowProvider: tokens.windowProvider)
    }
}

/// UIKit wrapper that exposes the SwiftUI PersonaView implementation
@objc open class MSFPersonaView: NSObject, FluentUIWindowProvider {
    @objc public init(theme: FluentUIStyle? = nil) {
        personaView = PersonaView()
        hostingController = UIHostingController(rootView: theme != nil ? AnyView(personaView.usingTheme(theme!)) : AnyView(personaView))

        super.init()

        personaView.tokens.windowProvider = self
        view.backgroundColor = UIColor.clear
    }

    @objc public convenience override init() {
        self.init(theme: nil)
    }

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc open var state: MSFPersonaViewState {
        return personaView.state
    }

    var window: UIWindow? {
        return self.view.window
    }

    private var hostingController: UIHostingController<AnyView>!

    private var personaView: PersonaView!
}
