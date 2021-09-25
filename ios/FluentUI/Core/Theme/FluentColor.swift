//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Wrapper view that returns the appropriate `Color` for a given `ColorSet` in a given environment.
struct FluentColor: View {

    /// Representative of the various color values that the rendered `Color` body could represent.
    let colorSet: ColorSet

    var body: some View {
        color(from: colorValue)
    }

    // MARK: - Private

    @Environment(\.colorSchemeContrast) private var contrast: ColorSchemeContrast
    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    // TODO: How do we know if we're elevated?
    private let isElevated: Bool = false

    private var colorValue: ColorValue {
        return colorSet.value(colorScheme: colorScheme,
                              contrast: contrast,
                              isElevated: isElevated)
    }

    @ViewBuilder
    private func color(from value: ColorValue) -> Color {
        Color(red: Double((value & 0xFF0000) >> 16) / 255.0,
              green: Double((value & 0x00FF00) >> 8) / 255.0,
              blue: Double((value & 0x0000FF) >> 0) / 255.0)
    }
}
