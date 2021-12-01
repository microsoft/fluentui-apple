//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

struct ScalableFont: ViewModifier {
    let font: UIFont
    let shouldScale: Bool

    func body(content: Content) -> some View {
        let familyName = font.familyName
        let size = font.fixedFont.pointSize
        let scalableFont: Font

        if shouldScale {
            scalableFont = .custom(familyName,
                                   size: size)
        } else {
            scalableFont = .custom(familyName,
                                   fixedSize: size)
        }

        return content.font(scalableFont)
    }
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

    /// Applies a scalable SwiftUI Font type in a scalable way.
    /// - Parameters:
    ///   - font: UIFont instance of that needs to be converted into a scalable SwiftUI Font struct.
    ///   - shouldScale: Whether the SwiftUI Font returned should be scaled or not.
    /// - Returns: The resulting scaled Font.
    func scalableFont(font: UIFont, shouldScale: Bool = true) -> some View {
        modifier(ScalableFont(font: font,
                              shouldScale: shouldScale))
    }
}
