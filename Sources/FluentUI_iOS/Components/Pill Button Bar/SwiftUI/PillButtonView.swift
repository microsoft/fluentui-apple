//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import SwiftUI

/// A `PillButton` is a button in the shape of a pill that can have two states: on (Selected) and off (not selected)
public struct PillButtonView: View, TokenizedControlView {
    public typealias TokenSetKeyType = PillButtonTokenSet.Tokens
    @ObservedObject public var tokenSet: PillButtonTokenSet

    /// Initializes a `PillButtonView`.
    ///
    /// - Parameters:
    ///   - style: The style of the pill button.
    ///   - model: The model of the pill button.
    ///   - leadingImage: The leading icon image of the pill button.
    ///   - action: The action perform when the pill button is tapped.
    public init(style: PillButtonStyle,
                model: PillButtonViewModel,
                leadingImage: Image? = nil,
                action: (() -> Void)?) {
        self.tokenSet = PillButtonTokenSet(style: { style })
        self.style = style
        self.title = model.title
        self.action = action
        self.leadingImage = leadingImage
        self.model = model
        self.isSelected = false
    }
 
    public var body: some View {
        tokenSet.update(fluentTheme)

        let accessibilityLabel = title
        let accessibilityLabelWithUnreadDot = String(format: "Accessibility.TabBarItemView.UnreadFormat".localized,
                                                     title)
        let iconColor: Color
        if isSelected {
            if isEnabled {
                iconColor = tokenSet[.iconColorSelected].color
            } else {
                iconColor = tokenSet[.iconColorSelectedDisabled].color
            }
        } else {
            if isEnabled {
                iconColor = tokenSet[.iconColor].color
            } else {
                iconColor = tokenSet[.iconColorDisabled].color
            }
        }

        @ViewBuilder
        var button: some View {
            SwiftUI.Button {
                action?()
                
                if model.isUnread {
                    model.isUnread = false
                }
            } label: {
                HStack(spacing: PillButtonTokenSet.iconAndLabelSpacing) {
                    if let leadingImage {
                        leadingImage
                            .foregroundStyle(iconColor)
                            .frame(width: PillButtonTokenSet.iconSize,
                                   height: PillButtonTokenSet.iconSize)
                    }
                    
                    Text(title)
                }
            }
            .buttonStyle(PillButtonViewStyle(isSelected: isSelected,
                                             isUnread: model.isUnread,
                                             tokenSet: tokenSet))
            .modifyIf(isSelected, { pillButton in
                pillButton
                    .accessibilityAddTraits(.isSelected)
            })
            .modifyIf(!isSelected, { pillButton in
                pillButton
                    .accessibilityRemoveTraits(.isSelected)
            })
            .accessibilityLabel(model.isUnread ? accessibilityLabelWithUnreadDot : accessibilityLabel)
            .showsLargeContentViewer(text: title)
        }

        return button
    }

    @ObservedObject private var model: PillButtonViewModel
    @Environment(\.fluentTheme) private var fluentTheme: FluentTheme
    @Environment(\.isEnabled) private var isEnabled: Bool

    private let leadingImage: Image?
    private let style: PillButtonStyle
    private let title: String
    private let action: (() -> Void)?
    private let isSelected: Bool
}
