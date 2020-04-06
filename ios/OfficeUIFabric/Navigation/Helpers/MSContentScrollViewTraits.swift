//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSContentScrollViewTraits

/// Defines various properties of a scroll view and user's scroll behavior
/// Used to understand user behavior over time
struct MSContentScrollViewTraits {
    /// Speed of the gesture
    let yVelocity: CGFloat

    /// If the user was interacting with the scroll view, or if the scroll was momentum-based
    let userIsScrolling: Bool

    //direction of the scroll (inversion of the swipe, i.e. a swipeUp will scrollDown
    let scrollDirection: UIScrollView.VerticalScrollDirection?

    //if the user had switched direction, in relation to the previous scrollview update
    let switchedDirection: Bool

    //content offset of the y axis
    let yOffset: CGFloat

    //describes the location of the scroll interaction relative to the content
    let scrollLocationDescriptor: UIScrollView.ScrollLocationDescriptor?

    init(yVelocity: CGFloat = 0.0,
         userScrolling: Bool = false,
         scrollDirection: UIScrollView.VerticalScrollDirection? = nil,
         switchedDirection: Bool = false,
         yOffset: CGFloat = 0.0,
         scrollLocationDescriptor: UIScrollView.ScrollLocationDescriptor? = nil) {

        self.yVelocity = yVelocity
        self.userIsScrolling = userScrolling
        self.scrollDirection = scrollDirection
        self.switchedDirection = switchedDirection
        self.yOffset = yOffset
        self.scrollLocationDescriptor = scrollLocationDescriptor
    }
}
