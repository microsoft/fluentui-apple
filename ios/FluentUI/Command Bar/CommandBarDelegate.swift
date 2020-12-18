//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFCommandBarDelegate)
public protocol CommandBarDelegate: AnyObject {
    @objc optional func commandBar(_ commandBar: CommandBar, shouldSelectItem item: CommandBarItem) -> Bool
    @objc optional func commandBar(_ commandBar: CommandBar, didSelectItem item: CommandBarItem)
    @objc optional func commandBar(_ commandBar: CommandBar, shouldDeselectItem item: CommandBarItem) -> Bool
    @objc optional func commandBar(_ commandBar: CommandBar, didDeselectItem item: CommandBarItem)
}
