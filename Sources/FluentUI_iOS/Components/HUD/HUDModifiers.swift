//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public extension View {
    /// Presents a Heads-up display on top of the modified View.
    /// - Parameters:
    ///   - type: `MSFHUDType` enum value that defines the type of the HUD being presented.
    ///   - isBlocking: Whether the interaction with the view will be blocked while the HUD is being presented.
    ///   - isPresented: Controls whether the HUD is being presented.
    ///   - label: Label of the HUD being presented.
    ///
    ///   - customView: Custom View displayed in the HUD being presented. This parameter is only used if the paramerter `type` is `.custom`.
    ///
    ///   - tapAction: Handler that is executed when the HUD is tapped while being presented.
    /// - Returns: The modified view with the capability of presenting a HUD.
    func presentHUD(type: HUDType,
                    isBlocking: Bool = true,
                    isPresented: Binding<Bool>,
                    label: String? = nil,
                    tapAction: (() -> Void)? = nil) -> some View {
        self.presentingView(isPresented: isPresented,
                            isBlocking: isBlocking) {
            HeadsUpDisplay(type: type,
                           isPresented: isPresented,
                           label: label,
                           tapAction: tapAction)
        }
    }
}

public extension HeadsUpDisplay {

    /// Sets the label of the Heads-up display.
    /// - Parameter label: String to set the label value with.
    /// - Returns: Modified Heads-up display with the new label.
    func label(_ label: String) -> HeadsUpDisplay {
        state.label = label
        return self
    }
}

struct SquareShapedViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        let modifiedContent = HStack {
            content
                .alignmentGuide(HorizontalAlignment.center) { (viewDimensions) -> CGFloat in
                    DispatchQueue.main.async {
                        // Calculates the size the view with the
                        // longer side (width or height).
                        let longerSide = max(viewDimensions.height,
                                             viewDimensions.width)

                        // Don't let the size be smaller than
                        // the minimum defined by the caller.
                        let minimumCalculatedSize = max(minSize,
                                                        longerSide)

                        // Don't let the size be bigger than
                        // the maximum defined by the caller.
                        size = min(maxSize, minimumCalculatedSize)
                    }

                    return viewDimensions[HorizontalAlignment.center]
                }
        }

        modifiedContent
            .frame(width: size, height: size)
    }

    init(minSize: CGFloat, maxSize: CGFloat) {
        // Starts size at maxSize to give long labels enough space.
        // If the HUD contents will fit in a smaller size,
        // calculations with viewDimensions will shrink the HUD.
        size = maxSize
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
