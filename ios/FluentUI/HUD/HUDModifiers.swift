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
                        // Ensures the View does not shrink compared to its
                        // previous size (calculated based on its content).
                        size = max(size,
                                   // Don't let the size be bigger than
                                   // the maximum defined by the caller.
                                   min(maxSize,
                                       // Don't let the size be smaller than
                                       // the minimum defined by the caller.
                                       max(minSize,
                                           // Sets the size the view with the
                                           // longer side (width or height).
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
        size = minSize
        self.minSize = minSize
        self.maxSize = maxSize
    }

    @State var size: CGFloat
    var minSize: CGFloat
    var maxSize: CGFloat
}

extension View {

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
