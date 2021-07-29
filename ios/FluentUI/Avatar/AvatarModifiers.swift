//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

public extension Avatar {

    func accessibilityLabel(_ accessibilityLabel: String?) -> Avatar {
        state.accessibilityLabel = accessibilityLabel
        return self
    }

    func backgroundColor(_ backgroundColor: UIColor?) -> Avatar {
        state.backgroundColor = backgroundColor
        return self
    }

    func foregroundColor(_ foregroundColor: UIColor?) -> Avatar {
        state.foregroundColor = foregroundColor
        return self
    }

    func hasPointerInteraction(_ hasPointerInteraction: Bool) -> Avatar {
        state.hasPointerInteraction = hasPointerInteraction
        return self
    }

    func hasRingInnerGap(_ hasRingInnerGap: Bool) -> Avatar {
        state.hasRingInnerGap = hasRingInnerGap
        return self
    }

    func imageBasedRingColor(_ imageBasedRingColor: UIImage?) -> Avatar {
        state.imageBasedRingColor = imageBasedRingColor
        return self
    }

    func isOutOfOffice(_ isOutOfOffice: Bool) -> Avatar {
        state.isOutOfOffice = isOutOfOffice
        return self
    }

    func isRingVisible(_ isRingVisible: Bool) -> Avatar {
        state.isRingVisible = isRingVisible
        return self
    }

    func isTransparent(_ isTransparent: Bool) -> Avatar {
        state.isTransparent = isTransparent
        return self
    }

    func presence(_ presence: MSFAvatarPresence) -> Avatar {
        state.presence = presence
        return self
    }

    func ringColor(_ ringColor: UIColor?) -> Avatar {
        state.ringColor = ringColor
        return self
    }
}
