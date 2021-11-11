//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public extension CardNudge {
    /// Optional subtext to draw below the main title area.
    func subtitle(_ subtitle: String?) -> CardNudge {
        state.subtitle = subtitle
        return self
    }

    /// Optional icon to draw at the leading edge of the control.
    func mainIcon(_ mainIcon: UIImage?) -> CardNudge {
        state.mainIcon = mainIcon
        return self
    }

    /// Optional accented text to draw below the main title area.
    func accentText(_ accentText: String?) -> CardNudge {
        state.accentText = accentText
        return self
    }

    /// Optional small icon to draw at the leading edge of `accentText`.
    func accentIcon(_ accentIcon: UIImage?) -> CardNudge {
        state.accentIcon = accentIcon
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

    /// Design token set to use when drawing this control.
    func customTokens(_ tokens: CardNudgeTokens) -> CardNudge {
        state.tokens = tokens
        return self
    }
}
