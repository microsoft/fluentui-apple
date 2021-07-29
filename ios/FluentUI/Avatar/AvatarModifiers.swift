//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

public extension AvatarView {

    func accessibilityLabel(_ accessibilityLabel: String?) -> AvatarView {
        state.accessibilityLabel = accessibilityLabel
        return self
    }

    func backgroundColor(_ backgroundColor: UIColor?) -> AvatarView {
        state.backgroundColor = backgroundColor
        return self
    }

    func foregroundColor(_ foregroundColor: UIColor?) -> AvatarView {
        state.foregroundColor = foregroundColor
        return self
    }

    func hasPointerInteraction(_ hasPointerInteraction: Bool) -> AvatarView {
        state.hasPointerInteraction = hasPointerInteraction
        return self
    }

    func hasRingInnerGap(_ hasRingInnerGap: Bool) -> AvatarView {
        state.hasRingInnerGap = hasRingInnerGap
        return self
    }

    func imageBasedRingColor(_ imageBasedRingColor: UIImage?) -> AvatarView {
        state.imageBasedRingColor = imageBasedRingColor
        return self
    }

    func isOutOfOffice(_ isOutOfOffice: Bool) -> AvatarView {
        state.isOutOfOffice = isOutOfOffice
        return self
    }

    func isRingVisible(_ isRingVisible: Bool) -> AvatarView {
        state.isRingVisible = isRingVisible
        return self
    }

    func isTransparent(_ isTransparent: Bool) -> AvatarView {
        state.isTransparent = isTransparent
        return self
    }

    func presence(_ presence: MSFAvatarPresence) -> AvatarView {
        state.presence = presence
        return self
    }

    func ringColor(_ ringColor: UIColor?) -> AvatarView {
        state.ringColor = ringColor
        return self
    }
}
