//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

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

    /// Adds a large content viewer for the view. If the text and image are both nil,
    /// the default large content viewer will be used.
    /// - Parameters
    ///  - text: Optional String to display in the large content viewer.
    ///  - image: Optional UIImage to display in the large content viewer.
    /// - Returns: The modified view.
    func showsLargeContentViewer(text: String? = nil, image: UIImage? = nil) -> some View {
        modifier(LargeContentViewerModifier(text: text, image: image))
    }
}

/// ViewModifier for showing the large content viewer with optional text and optional image.
/// If both the text and image are nil, the default large content viewer will be used.
struct LargeContentViewerModifier: ViewModifier {
    init(text: String?, image: UIImage?) {
        self.text = text
        self.image = image
    }

    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            if text != nil || image != nil {
                content.accessibilityShowsLargeContentViewer({
                    if let image = image {
                        Image(uiImage: image)
                    }
                    if let text = text {
                        Text(text)
                    }
                })
            } else {
                content.accessibilityShowsLargeContentViewer()
            }
        } else {
            content
        }
    }

    private var text: String?
    private var image: UIImage?
}
