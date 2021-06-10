//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// `MSFPersonaGridItemState` contains PersonaGridItem properties in addition to a subset of the MSFAvatarState protocol.
///
/// `onTapAction` provides tap gesture for PersonaGridItem.
///
@objc public protocol MSFPersonaGridItemState: MSFAvatarState {
    var gridSize: MSFPersonaGridSize { get set }

    var onTapAction: (() -> Void)? { get set }
}

/// Properties that make up PersonaGridItem content
class MSFPersonaGridItemViewStateImpl: NSObject, ObservableObject, Identifiable, MSFPersonaGridItemState {
    let tokens: MSFPersonaGridItemTokens

    public var onTapAction: (() -> Void)?
    private var avatarState: MSFAvatarState

    // Changes here can cause a re-layout
    @Published var gridSize: MSFPersonaGridSize

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

    var hasPointerInteraction: Bool {
        get {
            return avatarState.hasPointerInteraction
        }

        set {
            avatarState.hasPointerInteraction = newValue
        }
    }

    var hasRingInnerGap: Bool {
        get {
            return avatarState.hasRingInnerGap
        }

        set {
            avatarState.hasRingInnerGap = newValue
        }
    }

    var image: UIImage? {
        get {
            return avatarState.image
        }

        set {
            avatarState.image = newValue
        }
    }

    var imageBasedRingColor: UIImage? {
        get {
            return avatarState.imageBasedRingColor
        }

        set {
            avatarState.imageBasedRingColor = newValue
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

    var presence: MSFAvatarPresence {
        get {
            return avatarState.presence
        }

        set {
            avatarState.presence = newValue
        }
    }

    var primaryText: String? {
        get {
            return avatarState.primaryText
        }

        set {
            avatarState.primaryText = newValue
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

    var secondaryText: String? {
        get {
            return avatarState.secondaryText
        }

        set {
            avatarState.secondaryText = newValue
        }
    }

    var size: MSFAvatarSize {
        get {
            return avatarState.size
        }

        set {
            avatarState.size = newValue
        }
    }

    var style: MSFAvatarStyle {
        get {
            return avatarState.style
        }

        set {
            avatarState.style = newValue
        }
    }

    init(size: MSFPersonaGridSize, avatarState: MSFAvatarState) {
        self.gridSize = size
        self.avatarState = avatarState
        self.tokens = MSFPersonaGridItemTokens(size: size)

        super.init()
    }
}

public struct PersonaGridItem: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var tokens: MSFPersonaGridItemTokens
    @ObservedObject var state: MSFPersonaGridItemViewStateImpl
    let avatarView: AvatarView

    public init(size: MSFPersonaGridSize) {
        self.avatarView = AvatarView(style: .default, size: size.avatarSize)

        let state = MSFPersonaGridItemViewStateImpl(size: size, avatarState: avatarView.state)
        self.state = state
        self.tokens = state.tokens
    }

    public var body: some View {
        let action = state.onTapAction ?? {}
        Button(action: action) {
            VStack(spacing: 0) {
                avatarView
                    .padding(.top, tokens.padding)
                    .padding(.bottom, tokens.avatarInterspace)
                    .padding(.horizontal, tokens.padding)
                Text(state.primaryText ?? "")
                    .font(Font(tokens.labelFont))
                    .foregroundColor(Color(tokens.labelColor))
                if state.gridSize.canShowSubtitle {
                    Text(state.secondaryText ?? "")
                        .font(Font(tokens.sublabelFont))
                        .foregroundColor(Color(tokens.sublabelColor))
                }
                Spacer(minLength: tokens.padding)
            }
        }
        .background(Color(tokens.appearanceProxy.backgroundColor))
        .frame(minHeight: 0, maxHeight: .infinity)
        .designTokens(tokens,
                      from: theme,
                      with: windowProvider)
    }
}

/// UIKit wrapper that exposes the SwiftUI PersonaGridItem implementation
@objc open class MSFPersonaGridItemView: NSObject, FluentUIWindowProvider {

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc open var state: MSFPersonaGridItemState {
        return self.personaGridItem.state
    }

    @objc public init(size: MSFPersonaGridSize = .large,
                      theme: FluentUIStyle? = nil) {
        super.init()

        personaGridItem = PersonaGridItem(size: size)
        hostingController = UIHostingController(rootView: AnyView(personaGridItem
                                                                    .windowProvider(self)
                                                                    .modifyIf(theme != nil, { personaGridItem in
                                                                        personaGridItem.customTheme(theme!)
                                                                    })))
        hostingController.disableSafeAreaInsets()
        view.backgroundColor = UIColor.clear
    }

    var window: UIWindow? {
        return self.view.window
    }

    private var hostingController: UIHostingController<AnyView>!

    private var personaGridItem: PersonaGridItem!
}
