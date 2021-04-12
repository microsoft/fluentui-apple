//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

@objc public protocol MSFPersonaViewState {
    @objc var avatar: MSFAvatarState? { get set }
    @objc var titleTrailingAccessoryView: UIView? { get set }
    @objc var subtitleTrailingAccessoryView: UIView? { get set }
    @objc var onTapAction: (() -> Void)? { get set }
}

internal class MSFPersonaViewStateImpl: MSFListCellState, MSFPersonaViewState {
    @Published public var avatar: MSFAvatarState?
}

struct PersonaView: View {
    @ObservedObject var state: MSFPersonaViewStateImpl
    @ObservedObject var tokens: MSFPersonaViewTokens

    init(windowProvider: FluentUIWindowProvider?) {
        self.state = MSFPersonaViewStateImpl()
        self.tokens = MSFPersonaViewTokens()
        self.tokens.windowProvider = windowProvider
    }

    var body: some View {
        MSFListCellView(state: getCellState(), tokens: tokens, windowProvider: tokens.windowProvider)
    }

    private func getCellState() -> MSFListCellState {
        let cellState = MSFListCellState()
        cellState.leadingView = createAvatar().view
        cellState.leadingViewSize = .xlarge
        cellState.title = state.avatar?.primaryText ?? ""
        cellState.subtitle = state.avatar?.secondaryText ?? ""
        cellState.titleTrailingAccessoryView = state.titleTrailingAccessoryView
        cellState.subtitleTrailingAccessoryView = state.subtitleTrailingAccessoryView
        cellState.onTapAction = state.onTapAction
        cellState.layoutType = .threeLines
        return cellState
    }

    private func createAvatar() -> MSFAvatar {
        let avatar = MSFAvatar(style: .default, size: .xlarge)
        avatar.state.image = state.avatar?.image
        avatar.state.ringColor = state.avatar?.ringColor
        avatar.state.backgroundColor = state.avatar?.backgroundColor
        avatar.state.foregroundColor = state.avatar?.foregroundColor
        avatar.state.presence = state.avatar?.presence ?? .none
        avatar.state.isRingVisible = state.avatar?.isRingVisible ?? false
        avatar.state.isTransparent = state.avatar?.isTransparent ?? true
        avatar.state.isOutOfOffice = state.avatar?.isOutOfOffice ?? false
        return avatar
    }
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
