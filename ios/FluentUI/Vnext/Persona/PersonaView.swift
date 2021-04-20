//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

@objc public protocol MSFPersonaViewState: MSFAvatarState {
    var titleTrailingAccessoryView: UIView? { get set }
    var subtitleTrailingAccessoryView: UIView? { get set }
    var onTapAction: (() -> Void)? { get set }
}

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

struct PersonaView: View {
    @ObservedObject var state: MSFPersonaViewStateImpl
    @ObservedObject var tokens: MSFPersonaViewTokens

    init(windowProvider: FluentUIWindowProvider?) {
        avatar = MSFAvatar(style: .default, size: .xlarge)
        state = MSFPersonaViewStateImpl(avatarState: avatar.state)
        tokens = MSFPersonaViewTokens()
        tokens.windowProvider = windowProvider

        initializeState()
    }

    var body: some View {
        MSFListCellView(state: state, tokens: tokens, windowProvider: tokens.windowProvider)
    }

    private func initializeState() {
        state.leadingView = avatar.view
        state.leadingViewSize = .xlarge
        state.titleTrailingAccessoryView = state.titleTrailingAccessoryView
        state.subtitleTrailingAccessoryView = state.subtitleTrailingAccessoryView
        state.onTapAction = state.onTapAction
        state.layoutType = .threeLines
    }

    private let avatar: MSFAvatar
}

/// UIKit wrapper that exposes the SwiftUI Persona Cell implementation
@objc open class MSFPersonaView: NSObject, FluentUIWindowProvider {
    @objc public init(theme: FluentUIStyle? = nil) {
        personaView = PersonaView(windowProvider: nil)
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
