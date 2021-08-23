//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Properties that can be used to customize the appearance of the Avatar in the AvatarGroup.
@objc public protocol MSFAvatarGroupAvatarState {
    /// Sets the accessibility label for the Avatar.
    var accessibilityLabel: String? { get set }

    /// Sets a custom background color for the Avatar.
    /// The ring color inherit this color if not set explicitly to a different color.
    var backgroundColor: UIColor? { get set }

    /// The custom foreground color.
    /// This property allows customizing the initials text color or the default image tint color.
    var foregroundColor: UIColor? { get set }

    /// Whether the gap between the ring and the avatar content exists.
    var hasRingInnerGap: Bool { get set }

    /// The image used in the avatar content.
    var image: UIImage? { get set }

    /// The image used to fill the ring as a custom color.
    var imageBasedRingColor: UIImage? { get set }

    /// Displays an outer ring for the avatar if set to true.
    /// The group style does not support rings.
    var isRingVisible: Bool { get set }

    /// Sets the transparency of the avatar elements (inner and outer ring gaps, presence icon outline).
    /// Uses the solid default background color if set to false.
    var isTransparent: Bool { get set }

    /// The primary text of the avatar.
    /// Used for computing the initials and background/ring colors.
    var primaryText: String? { get set }

    /// Overrides the default ring color.
    var ringColor: UIColor? { get set }

    /// The secondary text of the avatar.
    /// Used for computing the initials and background/ring colors if primaryText is not set.
    var secondaryText: String? { get set }
}

/// Properties that can be used to customize the appearance of the Avatar in the AvatarGroup.
public class AvatarGroupAvatarState: NSObject, ObservableObject, MSFAvatarGroupAvatarState {
    /// Sets the accessibility label for the Avatar.
    public override var accessibilityLabel: String? {
        get {
            return avatarState.accessibilityLabel
        }
        set {
            avatarState.accessibilityLabel = newValue
        }
    }

    /// Sets a custom background color for the Avatar.
    /// The ring color inherit this color if not set explicitly to a different color.
    public var backgroundColor: UIColor? {
        get {
            return avatarState.backgroundColor
        }
        set {
            avatarState.backgroundColor = newValue
        }
    }

    /// The custom foreground color.
    /// This property allows customizing the initials text color or the default image tint color.
    public var foregroundColor: UIColor? {
        get {
            return avatarState.foregroundColor
        }
        set {
            avatarState.foregroundColor = newValue
        }
    }

    /// Whether the gap between the ring and the avatar content exists.
    public var hasRingInnerGap: Bool {
        get {
            return avatarState.hasRingInnerGap
        }
        set {
            avatarState.hasRingInnerGap = newValue
        }
    }

    /// The image used in the avatar content.
    public var image: UIImage? {
        get {
            return avatarState.image
        }
        set {
            avatarState.image = newValue
        }
    }

    /// The image used to fill the ring as a custom color.
    public var imageBasedRingColor: UIImage? {
        get {
            return avatarState.imageBasedRingColor
        }
        set {
            avatarState.imageBasedRingColor = newValue
        }
    }

    /// Displays an outer ring for the avatar if set to true.
    /// The group style does not support rings.
    public var isRingVisible: Bool {
        get {
            return avatarState.isRingVisible
        }
        set {
            avatarState.isRingVisible = newValue
        }
    }

    /// Sets the transparency of the avatar elements (inner and outer ring gaps, presence icon outline).
    /// Uses the solid default background color if set to false.
    public var isTransparent: Bool {
        get {
            return avatarState.isTransparent
        }
        set {
            avatarState.isTransparent = newValue
        }
    }

    /// The primary text of the avatar.
    /// Used for computing the initials and background/ring colors.
    public var primaryText: String? {
        get {
            return avatarState.primaryText
        }
        set {
            avatarState.primaryText = newValue
        }
    }

    /// Overrides the default ring color.
    public var ringColor: UIColor? {
        get {
            return avatarState.ringColor
        }
        set {
            avatarState.ringColor = newValue
        }
    }

    /// The secondary text of the avatar.
    /// Used for computing the initials and background/ring colors if primaryText is not set.
    public var secondaryText: String? {
        get {
            return avatarState.secondaryText
        }
        set {
            avatarState.secondaryText = newValue
        }
    }

    /// Creates and initializes an AvatarGroupAvatarState.
    public override init() {
        // Note: the size is unimportant because it will be overridden during render.
        avatarState = MSFAvatarStateImpl(style: .default, size: .large)
    }

    /// Internal storage for properties. Used when actually making an `Avatar`.
    let avatarState: MSFAvatarStateImpl
}
