//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// A container that stores a dynamic set of `Color` values.
struct DynamicColor: Hashable {

    /// Creates a custom `ShapeStyle` that stores a dynamic set of `Color` values.
    ///
    /// - Parameter light: The default `Color` for a light context. Required.
    /// - Parameter dark: The override `Color` for a dark context. Optional.
    /// - Parameter darkElevated: The override `Color` for a dark elevated context. Optional.
    init(light: Color,
         dark: Color? = nil,
         darkElevated: Color? = nil) {
        self.light = light
        self.dark = dark
        self.darkElevated = darkElevated
    }

    let light: Color
    let dark: Color?
    let darkElevated: Color?
}

@available(iOS 17, macOS 14, *)
extension DynamicColor: ShapeStyle {
    /// Evaluate to a resolved `Color` (in the form of a `ShapeStyle`) given the current `environment`.
    func resolve(in environment: EnvironmentValues) -> Color.Resolved {
        if environment.colorScheme == .dark {
            if environment.isPresented, let darkElevated = darkElevated {
                return darkElevated.resolve(in: environment)
            } else if let dark = dark {
                return dark.resolve(in: environment)
            }
        }

        // default
        return light.resolve(in: environment)
    }
}
