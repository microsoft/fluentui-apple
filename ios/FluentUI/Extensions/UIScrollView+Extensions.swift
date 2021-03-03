//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

extension UIScrollView {
    /// Inverted from user's finger directionality
    /// e.g A user moves their finger from the screen's bottom to the top (an "upward" direction) to scroll down the view
    /// - up: scrolling up, AKA user is moving finger down
    /// - down: scrolling down, AKA user is moving finger up
    enum VerticalScrollDirection {
        case up
        case down
    }

    // Describes the location of the scroll offset, relative to the content and scrollView
    enum ScrollLocationDescriptor {
        case excessivelyPrecedingContent // analogous to "Pull to Refresh"
        case inbounds // "normal scrolling", the user is moving through the content
        case excessivelyBeyondContent // the user has reached the bottom of the content and continues to scroll past, aka "past the last"
    }

    /// Whether the user is actively engaged with the scroll view
    /// Concatenation of various properties
    var userIsScrolling: Bool {
        return isTracking && isDragging
    }

    // Calculated Property reflecting the current ScrollLocationDescriptor based on various properties of the scrollView
    var scrollLocationDescriptor: ScrollLocationDescriptor {
        // The y-offset is adjusted to consider the top inset so the top scroll position is always 0 regardless of the content inset.
        let adjustedYOffset = contentOffset.y + contentInset.top
        let topInset = contentInset.top
        let bottomInset = contentInset.bottom //the footer's height is not reflected in contentSize, apparently?
        let contentHeight = contentSize.height + topInset + bottomInset //bottom inset can vary within the same list as the footer is dynamically loaded during scrolling (i.e. it will equal 1.0 until the footer is actually dequeued)
        let viewHeight = bounds.size.height

        //a negative y-offset is indicative of "pull to refresh"
        if adjustedYOffset < 0.0 {
            return .excessivelyPrecedingContent
        }

        //if the y offset combined with the height of the view is greater than the content, we're past the bottom of the scrollView's content
        if adjustedYOffset + viewHeight > contentHeight {
            return .excessivelyBeyondContent
        }

        //all other scenarios reflect the user scrolling between the top and bottom of the list
        return .inbounds
    }
}
