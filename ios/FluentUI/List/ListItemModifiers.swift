//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

public extension ListItem {

    /// The accessory type for the `ListItem`.
    /// - Parameter accessoryType: Type of accessory to display.
    /// - Returns: The modified `ListItem` with the property set.
    func accessoryType(_ accessoryType: ListItemAccessoryType) -> ListItem {
        state.accessoryType = accessoryType
        return self
    }

    /// The handler for when the `detailButton` accessory is tapped.
    /// - Parameter handler: The logic to execute when the accessory is tapped.
    /// - Returns: The modified `ListItem` with the property set.
    func onAccessoryTapped(_ handler: @escaping (() -> Void)) -> ListItem {
        state.onAccessoryTapped = handler
        return self
    }

    /// The line limit for `title`.
    /// - Parameter titleLineLimit: The  number of lines to display for the `title`.
    /// - Returns: The modified `ListItem` with the property set.
    func titleLineLimit(_ titleLineLimit: Int) -> ListItem {
        state.titleLineLimit = titleLineLimit
        return self
    }

    /// The line limit for `subtitle`.
    /// - Parameter subtitleLineLimit: The  number of lines to display for the `subtitle`.
    /// - Returns: The modified `ListItem` with the property set.
    func subtitleLineLimit(_ subtitleLineLimit: Int) -> ListItem {
        state.subtitleLineLimit = subtitleLineLimit
        return self
    }

    /// The line limit for `footer`.
    /// - Parameter footerLineLimit: The  number of lines to display for the `footer`.
    /// - Returns: The modified `ListItem` with the property set.
    func footerLineLimit(_ footerLineLimit: Int) -> ListItem {
        state.footerLineLimit = footerLineLimit
        return self
    }

    /// The background styling of the `ListItem` to match the type of `List` it is displayed in.
    /// - Parameter backgroundStyleType: The style of the background.
    /// - Returns: The modified `ListItem` with the property set.
    func backgroundStyleType(_ backgroundStyleType: ListItemBackgroundStyleType) -> ListItem {
        state.backgroundStyleType = backgroundStyleType
        return self
    }

    /// The size of the `LeadingContent`.
    /// - Parameter size: The size the leading content should be.
    /// - Returns: The modified `ListItem` with the property set.
    func leadingContentSize(_ size: ListItemLeadingContentSize) -> ListItem {
        state.tokenSet = ListItemTokenSet(customViewSize: { return size })
        return self
    }
}
