//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

public extension ListItem {

    /// The accessory type for the `ListItem`.
    /// - Parameter accessoryType: Type of accessory to display.
    /// - Returns: The modified `ListItem` with the property set.
    func accessoryType(_ accessoryType: ListItemAccessoryType) -> ListItem {
        var listItem = self
        listItem.accessoryType = accessoryType
        return listItem
    }

    /// The handler for when the `detailButton` accessory is tapped.
    /// - Parameter handler: The logic to execute when the accessory is tapped.
    /// - Returns: The modified `ListItem` with the property set.
    func onAccessoryTapped(_ handler: @escaping (() -> Void)) -> ListItem {
        var listItem = self
        listItem.onAccessoryTapped = handler
        return listItem
    }

    /// The line limit for `title`.
    /// - Parameter titleLineLimit: The  number of lines to display for the `title`.
    /// - Returns: The modified `ListItem` with the property set.
    func titleLineLimit(_ titleLineLimit: Int?) -> ListItem {
        var listItem = self
        listItem.titleLineLimit = titleLineLimit
        return listItem
    }

    /// The line limit for `subtitle`.
    /// - Parameter subtitleLineLimit: The  number of lines to display for the `subtitle`.
    /// - Returns: The modified `ListItem` with the property set.
    func subtitleLineLimit(_ subtitleLineLimit: Int?) -> ListItem {
        var listItem = self
        listItem.subtitleLineLimit = subtitleLineLimit
        return listItem
    }

    /// The line limit for `footer`.
    /// - Parameter footerLineLimit: The  number of lines to display for the `footer`.
    /// - Returns: The modified `ListItem` with the property set.
    func footerLineLimit(_ footerLineLimit: Int?) -> ListItem {
        var listItem = self
        listItem.footerLineLimit = footerLineLimit
        return listItem
    }

    /// The background styling of the `ListItem` to match the type of `List` it is displayed in.
    /// - Parameter backgroundStyleType: The style of the background.
    /// - Returns: The modified `ListItem` with the property set.
    func backgroundStyleType(_ backgroundStyleType: ListItemBackgroundStyleType) -> ListItem {
        var listItem = self
        listItem.backgroundStyleType = backgroundStyleType
        return listItem
    }

    /// The size of the `LeadingContent`.
    /// - Parameter size: The size the leading content should be.
    /// - Returns: The modified `ListItem` with the property set.
    func leadingContentSize(_ size: ListItemLeadingContentSize) -> ListItem {
        var listItem = self
        listItem.tokenSet = ListItemTokenSet(customViewSize: { size })
        return listItem
    }

    /// If the `TrailingContent` should be handled as its own accessibility element or not. If the `TrailingContent` has multiple
    /// focusable elements, then not combining it would allow for each element to receive focus with VoiceOver.
    /// - Parameter value: Whether or not the trailing content should be combined or be a separate accessibility element.
    /// - Returns: The modified `ListItem` with the property set.
    func combineTrailingContentAccessibilityElement(_ value: Bool) -> ListItem {
        var listItem = self
        listItem.combineTrailingContentAccessibilityElement = value
        return listItem
    }
}
