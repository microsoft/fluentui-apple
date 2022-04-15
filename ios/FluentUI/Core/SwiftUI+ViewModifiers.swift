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

    /// Measures the size of a view, monitors when its size is updated, and takes a closure to be called when it does
    /// - Parameter onChange: Block to be performed on size change
    /// - Returns The modified view.
    func measureSize(onChange: @escaping (CGSize) -> Void) -> some View {
      background(
        GeometryReader { geometryReader in
          Color.clear
            .preference(key: SizePreferenceKey.self,
                        value: geometryReader.size)
        }
      )
      .onPreferenceChange(SizePreferenceKey.self,
                          perform: onChange)
    }
}

/// PreferenceKey that will store the measured size of the view
struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
