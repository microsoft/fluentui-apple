//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

internal extension Drawer {
    func dragGesture(snapWidth: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let withinDragBounds = state.presentationDirection == .left ? value.translation.width < 0 : value.translation.width > 0
                if withinDragBounds {
                    draggedOffsetWidth = value.translation.width
                }
            }
            .onEnded { _ in
                if let draggedOffsetWidth = draggedOffsetWidth {
                    if abs(draggedOffsetWidth) < snapWidth {
                        state.isExpanded = true
                    } else {
                        state.isExpanded = false
                    }
                    self.draggedOffsetWidth = nil
                }
            }
    }
}
