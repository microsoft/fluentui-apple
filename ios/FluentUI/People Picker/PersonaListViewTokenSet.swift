//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Design token set for the `PersonaListView` control.
public class PersonaListViewTokenSet: ControlTokenSet<PersonaListViewTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// The background color of the PersonaListView.
        case backgroundColor
    }

    init() {
        super.init { token, theme in
            switch token {
            case .backgroundColor:
                return .uiColor { theme.color(.background1) }
            }
        }
    }
}

// MARK: Constants
extension PersonaListViewTokenSet {
}
