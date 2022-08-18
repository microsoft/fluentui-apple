//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

/// `CommandBarDelegate` is used to notify consumers of the `CommandBar` of certain events occurring within the `CommandBar`
public protocol CommandBarDelegate: AnyObject {
    /// Called when a scroll occurs in the `CommandBar`
    /// - Parameter commandBar: the instance of `CommandBar` that received the scroll
    func commandBarDidScroll(_ commandBar: CommandBar)
}
