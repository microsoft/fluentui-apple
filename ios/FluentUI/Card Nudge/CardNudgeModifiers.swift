//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public extension CardNudge {
    /// Optional subtext to draw below the main title area.
    func subtitle(_ subtitle: String?) -> CardNudge {
        configuration.subtitle = subtitle
        return self
    }

    /// Optional icon to draw at the leading edge of the control.
    func mainIcon(_ mainIcon: UIImage?) -> CardNudge {
        configuration.mainIcon = mainIcon
        return self
    }

    /// Optional accented text to draw below the main title area.
    func accentText(_ accentText: String?) -> CardNudge {
        configuration.accentText = accentText
        return self
    }

    /// Optional small icon to draw at the leading edge of `accentText`.
    func accentIcon(_ accentIcon: UIImage?) -> CardNudge {
        configuration.accentIcon = accentIcon
        return self
    }

    /// Title to display in the action button on the trailing edge of the control.
    ///
    /// To show an action button, provide values for both `actionButtonTitle` and  `actionButtonAction`.
    func actionButtonTitle(_ actionButtonTitle: String?) -> CardNudge {
        configuration.actionButtonTitle = actionButtonTitle
        return self
    }

    /// Action to be dispatched by the action button on the trailing edge of the control.
    ///
    /// To show an action button, provide values for both `actionButtonTitle` and  `actionButtonAction`.
    func actionButtonAction(_ actionButtonAction: CardNudgeButtonAction?) -> CardNudge {
        configuration.actionButtonAction = actionButtonAction
        return self
    }

    /// Action to be dispatched by the dismiss ("close") button on the trailing edge of the control.
    func dismissButtonAction(_ dismissButtonAction: CardNudgeButtonAction?) -> CardNudge {
        configuration.dismissButtonAction = dismissButtonAction
        return self
    }

    /// Provides a custom design token set to be used when drawing this control.
    func overrideTokens(_ tokens: CardNudgeTokens?) -> CardNudge {
        configuration.overrideTokens = tokens
        return self
    }
}
