//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Simple view that renders the appropriate `Color` for a given `ColorSet` in a given environment.
struct DynamicColor: View {
    @Environment(\.colorSchemeContrast) var contrast: ColorSchemeContrast
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    let isElevated: Bool = false // TODO: How do we know if we're elevated?
    let colorSet: ColorSet

    init(_ colorSet: ColorSet) {
        self.colorSet = colorSet
    }

    var body: some View {
        dynamicColor(colorSet: colorSet,
                     colorScheme: colorScheme,
                     contrast: contrast,
                     isElevated: isElevated)
    }
}

// MARK: - View extensions

extension View {
    /// Applies a dynamic foreground color.
    ///
    /// - Parameters:
    ///   - colorSet: The set of color values to apply dynamically.
    func dynamicForegroundColor(_ colorSet: ColorSet) -> some View {
        self.modifier(DynamicForeground(colorSet: colorSet))
    }
}

// MARK: - Private helpers

private struct DynamicForeground: ViewModifier {
    @Environment(\.colorSchemeContrast) var contrast: ColorSchemeContrast
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    private let isElevated: Bool = false // TODO: How do we know if we're elevated?
    let colorSet: ColorSet

    func body(content: Content) -> some View {
        content
            .foregroundColor(
                dynamicColor(colorSet: colorSet,
                             colorScheme: colorScheme,
                             contrast: contrast,
                             isElevated: isElevated))
    }
}

/// This helper function is used by `DynamicColor` and any `Dynamic` view modifiers.
@ViewBuilder
private func dynamicColor(colorSet: ColorSet, colorScheme: ColorScheme, contrast: ColorSchemeContrast, isElevated: Bool) -> Color {
    let value = colorSet.value(colorScheme: colorScheme,
                               contrast: contrast,
                               isElevated: isElevated)

    Color(red: Double((value & 0xFF0000) >> 16) / 255.0,
          green: Double((value & 0x00FF00) >> 8) / 255.0,
          blue: Double((value & 0x0000FF) >> 0) / 255.0)
}
