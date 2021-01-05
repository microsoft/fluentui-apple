//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public extension Drawer {
    /// Custom modifier for adding a callback placeholder when drawer's state is changed
    /// - Parameter `didChangeState`: closure executed with drawer is expanded or collapsed
    /// - Returns: `Drawer`
    func didChangeState(_ didChangeState: @escaping () -> Void) -> Drawer {
        let drawerState = state
        drawerState.onStateChange = didChangeState
        return Drawer(content: content,
                      state: drawerState,
                      tokens: tokens,
                      draggedOffsetWidth: draggedOffsetWidth)
    }
}
