//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

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
        [
            .cornerRadius: .float { GlobalTokens.corner(.radius40) }
        ]
    }

    private var buttonOnTokens: [ButtonToken: ControlTokenValue] {
        let backgroundColor = fluentTheme.color(.brandBackgroundTint)
        return buttonTokens.merging([
            .backgroundColor: .uiColor { backgroundColor },
            .backgroundPressedColor: .uiColor { backgroundColor },
            .backgroundFocusedColor: .uiColor { backgroundColor }
        ]) { (_, new) in new }
    }
}
