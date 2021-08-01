//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public extension CardNudge {
    func subtitle(_ subtitle: String?) -> CardNudge {
        state.subtitle = subtitle
        return self
    }

    func mainIcon(_ mainIcon: UIImage?) -> CardNudge {
        state.mainIcon = mainIcon
        return self
    }

    func accentIcon(_ accentIcon: UIImage?) -> CardNudge {
        state.accentIcon = accentIcon
        return self
    }

    func accentText(_ accentText: String?) -> CardNudge {
        state.accentText = accentText
        return self
    }

    /// Title to display in the action button on the trailing edge of the control.
    ///
    /// To show an action button, provide values for both `actionButtonTitle` and  `actionButtonAction`.
    func actionButtonTitle(_ actionButtonTitle: String?) -> CardNudge {
        state.actionButtonTitle = actionButtonTitle
        return self
    }

    /// Action to be dispatched by the action button on the trailing edge of the control.
    ///
    /// To show an action button, provide values for both `actionButtonTitle` and  `actionButtonAction`.
    func actionButtonAction(_ actionButtonAction: CardNudgeButtonAction?) -> CardNudge {
        state.actionButtonAction = actionButtonAction
        return self
    }

    /// Action to be dispatched by the dismiss ("close") button on the trailing edge of the control.
    func dismissButtonAction(_ dismissButtonAction: CardNudgeButtonAction?) -> CardNudge {
        state.dismissButtonAction = dismissButtonAction
        return self
    }

}
