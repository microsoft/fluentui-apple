//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

/// Represents the set of `DynamicColor` values for the various states of a button.
public struct ButtonDynamicColors: Equatable {
    public init(rest: DynamicColor,
                hover: DynamicColor,
                pressed: DynamicColor,
                selected: DynamicColor,
                disabled: DynamicColor) {
        self.rest = rest
        self.hover = hover
        self.pressed = pressed
        self.selected = selected
        self.disabled = disabled
    }

    public let rest: DynamicColor
    public let hover: DynamicColor
    public let pressed: DynamicColor
    public let selected: DynamicColor
    public let disabled: DynamicColor
}

/// Represents the set of `DynamicColor` values for the various states of a `PillButton`
public struct PillButtonDynamicColors: Equatable {
    public init(rest: DynamicColor,
                selected: DynamicColor,
                disabled: DynamicColor,
                selectedDisabled: DynamicColor) {
        self.rest = rest
        self.selected = selected
        self.disabled = disabled
        self.selectedDisabled = selectedDisabled
    }

    public let rest: DynamicColor
    public let selected: DynamicColor
    public let disabled: DynamicColor
    public let selectedDisabled: DynamicColor
}
