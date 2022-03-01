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
    var titleTrailingAccessoryUIView: UIView? { get set }
    var subtitleTrailingAccessoryUIView: UIView? { get set }
    var onTapAction: (() -> Void)? { get set }
}

public protocol PersonaViewState: MSFPersonaViewState {
    var titleTrailingAccessoryView: AnyView? { get set }
    var subtitleTrailingAccessoryView: AnyView? { get set }
}

/// Properties that make up PersonaView content
class MSFPersonaViewStateImpl: MSFListCellStateImpl, PersonaViewState {
    override var backgroundColor: UIColor? {
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

    var hasButtonAccessibilityTrait: Bool {
        get {
            return avatarState.hasButtonAccessibilityTrait
        }

        set {
            avatarState.hasButtonAccessibilityTrait = newValue
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

    var isAnimated: Bool {
        get {
            return avatarState.isAnimated
        }

        set {
            avatarState.isAnimated = newValue
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
            title = newValue ?? ""
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
            subtitle = newValue ?? ""
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

    init(avatarState: MSFAvatarState) {
        self.avatarState = avatarState

        super.init()
    }

    private var avatarState: MSFAvatarState
}

/// View for PersonaView
public struct PersonaView: View {
    public init() {
        let avatar = Avatar(style: .default, size: .large)
        state = MSFPersonaViewStateImpl(avatarState: avatar.state)
        state.leadingView = AnyView(avatar)
        state.leadingViewSize = .large
        state.layoutType = .threeLines
        state.overrideTokens = PersonaViewTokens()
    }

    public var body: some View {
        MSFListCellView(state: state)
    }

    @ObservedObject var state: MSFPersonaViewStateImpl
}
