//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// `MSFPersonaGridItemState` contains PersonaGridItem properties in addition to a subset of the MSFAvatarState protocol.
///
/// `onTapAction` provides tap gesture for PersonaGridItem.
///
@objc public protocol MSFPersonaGridItemState {
    var image: UIImage? { get set }
    var primaryText: String? { get set }
    var secondaryText: String? { get set }
    var size: MSFAvatarSize { get set }

    var onTapAction: (() -> Void)? { get set }
}

/// Properties that make up PersonaGridItem content
class MSFPersonaGridItemViewStateImpl: NSObject, ObservableObject, Identifiable, MSFPersonaGridItemState {
    public var onTapAction: (() -> Void)?

    @ObservedObject private var tokens: MSFPersonaGridItemTokens
    private var avatarState: MSFAvatarState

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

    init(size: MSFPersonaGridSize, avatarState: MSFAvatarState) {
        self.avatarState = avatarState
        self.tokens = MSFPersonaGridItemTokens(size: size)

        super.init()
    }
}

public struct PersonaGridItem: View {
    @ObservedObject var tokens: MSFPersonaGridItemTokens
    @ObservedObject var state: MSFPersonaGridItemViewStateImpl
    let avatarView: AvatarView
    let gridSize: MSFPersonaGridSize

    public init(size: MSFPersonaGridSize) {
        tokens = MSFPersonaGridItemTokens(size: size)
        avatarView = AvatarView(style: .default, size: size.avatarSize)
        state = MSFPersonaGridItemViewStateImpl(size: size, avatarState: avatarView.state)

        gridSize = size
    }

    public var body: some View {
        VStack(spacing: 0) {
            avatarView
                .padding(.top, tokens.topPadding)
                .padding(.bottom, tokens.avatarInterspace)
            Text(state.primaryText ?? "")
                .font(Font(tokens.labelFont))
                .foregroundColor(Color(tokens.labelColor))
            if gridSize.canShowSubtitle {
                Text(state.secondaryText ?? "")
                    .font(Font(tokens.sublabelFont))
                    .foregroundColor(Color(tokens.sublabelColor))
            }
            Spacer(minLength: tokens.bottomPadding)
        }
        .background(Color(tokens.appearanceProxy.backgroundColor))
        .onTapGesture {
            if let action = state.onTapAction {
                action()
            }
        }
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
