//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

public extension Avatar {

    /// Sets the accessibility label for the Avatar.
    /// - Parameter accessibilityLabel: Accessibility label string.
    /// - Returns: The modified Avatar with the property set.
    func accessibilityLabel(_ accessibilityLabel: String?) -> Avatar {
        state.accessibilityLabel = accessibilityLabel
        return self
    }

    /// Sets a custom background color for the Avatar.
    /// The ring color inherit this color if not set explicitly to a different color.
    /// - Parameter backgroundColor: Background color.
    /// - Returns: The modified Avatar with the property set.
    func backgroundColor(_ backgroundColor: UIColor?) -> Avatar {
        state.backgroundColor = backgroundColor
        return self
    }

    /// The custom foreground color.
    /// This modifier allows customizing the initials text color or the default image tint color.
    /// - Parameter foregroundColor: Foreground color.
    /// - Returns: The modified Avatar with the property set.
    func foregroundColor(_ foregroundColor: UIColor?) -> Avatar {
        state.foregroundColor = foregroundColor
        return self
    }

    /// Turns iPad Pointer interaction on/off.
    /// - Parameter hasPointerInteraction: Boolean value to set the property.
    /// - Returns: The modified Avatar with the property set.
    func hasPointerInteraction(_ hasPointerInteraction: Bool) -> Avatar {
        state.hasPointerInteraction = hasPointerInteraction
        return self
    }

    /// Whether the gap between the ring and the avatar content exists.
    /// - Parameter hasRingInnerGap: Boolean value to set the property.
    /// - Returns: The modified Avatar with the property set.
    func hasRingInnerGap(_ hasRingInnerGap: Bool) -> Avatar {
        state.hasRingInnerGap = hasRingInnerGap
        return self
    }

    /// The image used to fill the ring as a custom color.
    /// - Parameter imageBasedRingColor: Image to be used as a the ring fill pattern.
    /// - Returns: The modified Avatar with the property set.
    func imageBasedRingColor(_ imageBasedRingColor: UIImage?) -> Avatar {
        state.imageBasedRingColor = imageBasedRingColor
        return self
    }

    /// Defines whether the avatar state transitions are animated or not. Animations are enabled by default.
    /// - Parameter isAnimated: Boolean value to set the property.
    /// - Returns: The modified Avatar with the property set.
    func isAnimated(_ isAnimated: Bool) -> Avatar {
        state.isAnimated = isAnimated
        return self
    }

    /// Whether the presence status displays its "Out of office" or standard image.
    /// - Parameter isOutOfOffice: Boolean value to set the property.
    /// - Returns: The modified Avatar with the property set.
    func isOutOfOffice(_ isOutOfOffice: Bool) -> Avatar {
        state.isOutOfOffice = isOutOfOffice
        return self
    }

    /// Displays an outer ring for the avatar if set to true.
    /// The group style does not support rings.
    /// - Parameter isRingVisible: Boolean value to set the property.
    /// - Returns: The modified Avatar with the property set.
    func isRingVisible(_ isRingVisible: Bool) -> Avatar {
        state.isRingVisible = isRingVisible
        return self
    }

    /// Sets the transparency of the avatar elements (inner and outer ring gaps, presence icon outline).
    /// Uses the solid default background color if set to false.
    /// - Parameter isTransparent: Boolean value to set the property.
    /// - Returns: The modified Avatar with the property set.
    func isTransparent(_ isTransparent: Bool) -> Avatar {
        state.isTransparent = isTransparent
        return self
    }

    /// Defines the presence displayed by the Avatar.
    /// Image displayed depends on the value of the isOutOfOffice property.
    /// Presence is not displayed in the xsmall size.
    /// - Parameter presence: The MSFAvatarPresence enum value.
    /// - Returns: The modified Avatar with the property set.
    func presence(_ presence: MSFAvatarPresence) -> Avatar {
        state.presence = presence
        return self
    }

    /// Overrides the default ring color.
    /// - Parameter ringColor: The color used to set the ring color.
    /// - Returns: The modified Avatar with the property set.
    func ringColor(_ ringColor: UIColor?) -> Avatar {
        state.ringColor = ringColor
        return self
    }
}
