//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

struct SquareShapedViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        let modifiedContent = HStack {
            content
                .alignmentGuide(HorizontalAlignment.center) { (viewDimensions) -> CGFloat in
                    DispatchQueue.main.async {
                        self.size = max(size, // ensures the View does not shrink
                                        min(maxSize,
                                            max(minSize,
                                                max(viewDimensions.height,
                                                    viewDimensions.width))))
                    }

                    return viewDimensions[HorizontalAlignment.center]
                }
        }

        modifiedContent
            .frame(width: size, height: size)
    }

    init(minSize: CGFloat, maxSize: CGFloat) {
        self.size = minSize
        self.minSize = minSize
        self.maxSize = maxSize
    }

    @State var size: CGFloat
    var minSize: CGFloat
    var maxSize: CGFloat
}

extension View {
    /// Applies modifiers defined in a closure if a condition is met.
    /// - Parameters:
    ///   - condition: Condition that need to be met so that the closure is applied to the View.
    ///   - modifications: Closure that outlines the modifiers that will be applied to the View should the condition evaluate to true.
    /// - Returns: The resulting View either with the modifications applied (if condition is true) or in its original state (if condition is false).
    @ViewBuilder
    func modifyIf<Content: View>(_ condition: Bool,
                                 _ modifications: (Self) -> Content) -> some View {
        if condition {
            modifications(self)
        } else {
            self
        }
    }

    /// Enables iPad Pointer interaction for the view if available.
    /// - Parameter isEnabled: Whether the pointer interaction should be enabled.
    /// - Returns: The modified view.
    func pointerInteraction(_ isEnabled: Bool) -> AnyView {
        if isEnabled {
            return AnyView(self.hoverEffect())
        }

        return AnyView(self)
    }

    /// Ensures that the modified View has equal height and width values based on the
    /// maximum of either dimension considering its dynamic content size.
    /// Minimum and maximum cap values need to be specified.
    /// - Parameters:
    ///   - minSize: Minimum heigh/width value of the view.
    ///   - maxSize: Maximum heigh/width value of the view.
    /// - Returns: Modified view in a square shaped format.
    func squareShaped(minSize: CGFloat, maxSize: CGFloat) -> some View {
        modifier(SquareShapedViewModifier(minSize: minSize,
                                          maxSize: maxSize))
    }
}
