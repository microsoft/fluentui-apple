//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// `MSFPersonaViewConfiguration` contains  PersonaView properties in addition to  MSFAvatarConfiguration protocol.
///
/// `TrailingAccessoryView` for `title` and `subtitle` allows for any custom UIView
/// following each respective label.
///
/// `onTapAction` provides tap gesture for PersonaView.
///
@objc public protocol MSFPersonaViewConfiguration: MSFAvatarConfiguration {
    var titleTrailingAccessoryUIView: UIView? { get set }
    var subtitleTrailingAccessoryUIView: UIView? { get set }
    var onTapAction: (() -> Void)? { get set }
}

public protocol PersonaViewState: MSFPersonaViewConfiguration {
    var titleTrailingAccessoryView: AnyView? { get set }
    var subtitleTrailingAccessoryView: AnyView? { get set }
}

/// Properties that make up PersonaView content
class MSFPersonaViewConfigurationImpl: MSFListCellConfigurationImpl, PersonaViewState {
    override var backgroundColor: UIColor? {
        get {
            return avatarConfiguration.backgroundColor
        }

        set {
            avatarConfiguration.backgroundColor = newValue
        }
    }

    var foregroundColor: UIColor? {
        get {
            return avatarConfiguration.foregroundColor
        }

        set {
            avatarConfiguration.foregroundColor = newValue
        }
    }

    var hasButtonAccessibilityTrait: Bool {
        get {
            return avatarConfiguration.hasButtonAccessibilityTrait
        }

        set {
            avatarConfiguration.hasButtonAccessibilityTrait = newValue
        }
    }

    var hasPointerInteraction: Bool {
        get {
            return avatarConfiguration.hasPointerInteraction
        }

        set {
            avatarConfiguration.hasPointerInteraction = newValue
        }
    }

    var hasRingInnerGap: Bool {
        get {
            return avatarConfiguration.hasRingInnerGap
        }

        set {
            avatarConfiguration.hasRingInnerGap = newValue
        }
    }

    var image: UIImage? {
        get {
            return avatarConfiguration.image
        }

        set {
            avatarConfiguration.image = newValue
        }
    }

    var imageBasedRingColor: UIImage? {
        get {
            return avatarConfiguration.imageBasedRingColor
        }

        set {
            avatarConfiguration.imageBasedRingColor = newValue
        }
    }

    var isAnimated: Bool {
        get {
            return avatarConfiguration.isAnimated
        }

        set {
            avatarConfiguration.isAnimated = newValue
        }
    }

    var isOutOfOffice: Bool {
        get {
            return avatarConfiguration.isOutOfOffice
        }

        set {
            avatarConfiguration.isOutOfOffice = newValue
        }
    }

    var isRingVisible: Bool {
        get {
            return avatarConfiguration.isRingVisible
        }

        set {
            avatarConfiguration.isRingVisible = newValue
        }
    }

    var isTransparent: Bool {
        get {
            return avatarConfiguration.isTransparent
        }

        set {
            avatarConfiguration.isTransparent = newValue
        }
    }

    var presence: MSFAvatarPresence {
        get {
            return avatarConfiguration.presence
        }

        set {
            avatarConfiguration.presence = newValue
        }
    }

    var primaryText: String? {
        get {
            return avatarConfiguration.primaryText
        }

        set {
            avatarConfiguration.primaryText = newValue
            title = newValue ?? ""
        }
    }

    var ringColor: UIColor? {
        get {
            return avatarConfiguration.ringColor
        }

        set {
            avatarConfiguration.ringColor = newValue
        }
    }

    var secondaryText: String? {
        get {
            return avatarConfiguration.secondaryText
        }

        set {
            avatarConfiguration.secondaryText = newValue
            subtitle = newValue ?? ""
        }
    }

    var size: MSFAvatarSize {
        get {
            return avatarConfiguration.size
        }

        set {
            avatarConfiguration.size = newValue
        }
    }

    var style: MSFAvatarStyle {
        get {
            return avatarConfiguration.style
        }

        set {
            avatarConfiguration.style = newValue
        }
    }

    init(avatarConfiguration: MSFAvatarConfiguration) {
        self.avatarConfiguration = avatarConfiguration

        super.init()
    }

    private var avatarConfiguration: MSFAvatarConfiguration
}

/// View for PersonaView
public struct PersonaView: View {
    public init() {
        let avatar = Avatar(style: .default, size: .large)
        configuration = MSFPersonaViewConfigurationImpl(avatarConfiguration: avatar.configuration)
        configuration.leadingView = AnyView(avatar)
        configuration.leadingViewSize = .large
        configuration.layoutType = .threeLines
        configuration.overrideTokens = PersonaViewTokens()
    }

    public var body: some View {
        MSFListCellView(configuration: configuration)
    }

    @ObservedObject var configuration: MSFPersonaViewConfigurationImpl
}
