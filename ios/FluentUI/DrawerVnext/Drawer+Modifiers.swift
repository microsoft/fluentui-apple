//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public extension Drawer {
    /// Custom modifier for adding a callback placeholder when drawer's state is changed
    /// - Parameter didChangedState: closure executed with drawer is expanded or collapsed
    /// - Returns: Drawer
    func didChangedState(_ didChangedState: @escaping DrawerStateChangedCompletionBlock) -> Drawer {
        let drawerState = state
        drawerState.onStateChange = didChangedState
        return Drawer(
            content: content,
            state: drawerState,
            tokens: tokens,
            viewModel: viewModel,
            draggedOffsetWidth: draggedOffsetWidth)
    }
}
