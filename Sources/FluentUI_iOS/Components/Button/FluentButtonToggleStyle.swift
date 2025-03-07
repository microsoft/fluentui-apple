//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI_common
import SwiftUI

/// `ToggleStyle` which configures the `Toggle` according to its state and design tokens.
public struct FluentButtonToggleStyle: ToggleStyle {
    public init() {}

    @Environment(\.fluentTheme) private var fluentTheme: FluentTheme

    public func makeBody(configuration: Configuration) -> some View {
        SwiftUI.Button(action: {
            configuration.isOn.toggle()
        }, label: {
            configuration.label
        })
        .buttonStyle(configuration.isOn ? buttonStyleOn : buttonStyle)
    }

    private var buttonStyle: FluentButtonStyle {
        var style = FluentButtonStyle(style: .transparentNeutral)
        style.overrideTokens(buttonTokens)
        return style
    }

    private var buttonStyleOn: FluentButtonStyle {
        var style = FluentButtonStyle(style: .subtle)
        style.overrideTokens(buttonOnTokens)
        return style
    }

    private var buttonTokens: [ButtonToken: ControlTokenValue] {
        var tokens: [ButtonToken: ControlTokenValue] = [
            .cornerRadius: .float { GlobalTokens.corner(.radius40) }
        ]

        if let tokenOverrides = tokenOverrides {
            tokens = tokens.merging(tokenOverrides) { (_, new) in new }
        }

        return tokens
    }

    private var buttonOnTokens: [ButtonToken: ControlTokenValue] {
        let backgroundColor = fluentTheme.swiftUIColor(.brandBackgroundTint)
        var tokens: [ButtonToken: ControlTokenValue] = buttonTokens.merging([
            .backgroundColor: .color { backgroundColor },
            .backgroundPressedColor: .color { backgroundColor },
            .backgroundFocusedColor: .color { backgroundColor }
        ]) { (_, new) in new }

        if let tokenOverrides = tokenOverrides {
            tokens = tokens.merging(tokenOverrides) { (_, new) in new }
        }

        return tokens
    }

    private var tokenOverrides: [ButtonToken: ControlTokenValue]?
}

public extension FluentButtonToggleStyle {
    /// Provide override values for various `ButtonToken` values.
    mutating func overrideTokens(_ overrides: [ButtonToken: ControlTokenValue]) {
        tokenOverrides = overrides
    }
}
