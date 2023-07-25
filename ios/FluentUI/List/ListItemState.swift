//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Properties available to customize the appearance of a `ListItem`
class ListItemState: ControlState {
	/// The `ListItemAccessoryType` that the view should display
	var accessoryType: ListItemAccessoryType?

	/// The background styling of the `ListItem` to match the type of `List` it is displayed in
	var backgroundStyleType: ListItemBackgroundStyleType = .plain

	/// The handler for when the `detailButton` accessory view is tapped
	var onAccessoryTapped: (() -> Void)?

	/// The maximum amount of lines shown for the `title`
	var titleLineLimit: Int = 1

	/// The maximum amount of lines shown for the `subtitle`
	var subtitleLineLimit: Int = 1

	/// The maximum amount of lines shown for the `footer`
	var footerLineLimit: Int = 1

	/// The truncation mode of the `title`
	var titleTruncationMode: Text.TruncationMode = .tail

	/// The truncation mode of the `subtitle`
	var subtitleTruncationMode: Text.TruncationMode = .tail

	/// The truncation mode of the `footer`
	var footerTruncationMode: Text.TruncationMode = .tail
}
