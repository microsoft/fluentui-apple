//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public protocol CommandBarDelegate: AnyObject {
    func commandBar(_ commandBar: CommandBar, shouldSelectItem item: CommandBarItem) -> Bool
    func commandBar(_ commandBar: CommandBar, didSelectItem item: CommandBarItem)
    func commandBar(_ commandBar: CommandBar, shouldDeselectItem item: CommandBarItem) -> Bool
    func commandBar(_ commandBar: CommandBar, didDeselectItem item: CommandBarItem)
}

public extension CommandBarDelegate {
    func commandBar(_ commandBar: CommandBar, shouldSelectItem item: CommandBarItem) -> Bool {
        true
    }

    func commandBar(_ commandBar: CommandBar, didSelectItem item: CommandBarItem) {}

    func commandBar(_ commandBar: CommandBar, shouldDeselectItem item: CommandBarItem) -> Bool {
        true
    }

    func commandBar(_ commandBar: CommandBar, didDeselectItem item: CommandBarItem) {}
}
