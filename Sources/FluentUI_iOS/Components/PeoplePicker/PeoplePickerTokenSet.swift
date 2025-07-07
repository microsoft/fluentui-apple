//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import UIKit

/// Design token set for the `PeoplePicker` control.
public class PeoplePickerTokenSet: BadgeFieldTokenSet {}

// MARK: Constants
extension PeoplePickerTokenSet {
    static let personaSuggestionsVerticalMargin: CGFloat = GlobalTokens.spacing(.size80)
}
