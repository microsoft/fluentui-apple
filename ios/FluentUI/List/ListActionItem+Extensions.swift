//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

public extension ListActionItem {

    func topSeparatorType(_ separatorType: ListActionItemSeparatorType) -> ListActionItem {
        var listActionItem = self
        listActionItem.topSeparatorType = separatorType
        return listActionItem
    }

    func bottomSeparatorType(_ separatorType: ListActionItemSeparatorType) -> ListActionItem {
        var listActionItem = self
        listActionItem.bottomSeparatorType = separatorType
        return listActionItem
    }

    func backgroundStyleType(_ backgroundStyleType: ListItemBackgroundStyleType) -> ListActionItem {
        var listActionItem = self
        listActionItem.backgroundStyleType = backgroundStyleType
        return listActionItem
    }
}
