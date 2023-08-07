//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

public extension ListActionItem {

    /// The type of separator on the top edge of `ListActionItem`.
    /// - Parameter separatorType: Type of separator to display.
    /// - Returns: The modified `ListActionItem` with the property set.
    func topSeparatorType(_ separatorType: ListActionItemSeparatorType) -> ListActionItem {
        var listActionItem = self
        listActionItem.topSeparatorType = separatorType
        return listActionItem
    }

    /// The type of separator on the bottom edge of `ListActionItem`.
    /// - Parameter separatorType: Type of separator to display.
    /// - Returns: The modified `ListActionItem` with the property set.
    func bottomSeparatorType(_ separatorType: ListActionItemSeparatorType) -> ListActionItem {
        var listActionItem = self
        listActionItem.bottomSeparatorType = separatorType
        return listActionItem
    }

    /// The background styling of the `ListActionItem` to match the type of `List` it is displayed in.
    /// - Parameter backgroundStyleType: The style of the background.
    /// - Returns: The modified `ListActionItem` with the property set.
    func backgroundStyleType(_ backgroundStyleType: ListItemBackgroundStyleType) -> ListActionItem {
        var listActionItem = self
        listActionItem.backgroundStyleType = backgroundStyleType
        return listActionItem
    }
}
