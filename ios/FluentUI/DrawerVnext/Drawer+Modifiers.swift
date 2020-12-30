//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public extension Drawer {
    /// called when drawer is collapsed/expanded.
    /// - Parameter isExpanded: Bool if true means drawer is open
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
