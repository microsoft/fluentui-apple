//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Design token set for the `PeoplePicker` control.
public class PeoplePickerTokenSet: ControlTokenSet<PeoplePickerTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// The background color of the PeoplePicker.
        case backgroundColor
    }

    init() {
        super.init { token, theme in
            switch token {
            case .backgroundColor:
                return .uiColor { theme.color(.background2) }
            }
        }
    }
}

// MARK: Constants
extension PeoplePickerTokenSet {
    static let personaSuggestionsVerticalMargin: CGFloat = GlobalTokens.spacing(.size80)
}
