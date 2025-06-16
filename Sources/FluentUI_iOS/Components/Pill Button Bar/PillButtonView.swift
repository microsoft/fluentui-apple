//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import SwiftUI

public struct PillButtonView: View, TokenizedControlView {
    public typealias TokenSetKeyType = PillButtonTokenSet.Tokens
    @ObservedObject public var tokenSet: PillButtonTokenSet

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @Environment(\.isFocused) var isFocused: Bool
    @Environment(\.isEnabled) private var isEnabled: Bool

    @State var isUnread: Bool
    @State var isSelected: Bool

    public init(style: PillButtonStyle,
                title: String,
                leadingImage: Image? = nil,
                isSelected: Bool = false,
                isUnread: Bool = false,
                action: (() -> Void)?) {
        self.tokenSet = PillButtonTokenSet(style: { style })
        self.style = style
        self.title = title
        self.isSelected = isSelected
        self.isUnread = isUnread
        self.action = action
        self.leadingImage = leadingImage
    }
 
    public var body: some View {
        tokenSet.update(fluentTheme)

        let accessibilityLabel = title
        let accessibilityLabelWithUnreadDot = String(format: "Accessibility.TabBarItemView.UnreadFormat".localized, title)
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

        return SwiftUI.Button {
            action?()
            
            if isUnread {
                isUnread = false
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
                                          isUnread: isUnread,
                                          tokenSet: tokenSet))
        .modifyIf(isSelected, { pillButton in
            pillButton
                .accessibilityAddTraits(.isSelected)
        })
        .modifyIf(!isSelected, { pillButton in
            pillButton
                .accessibilityRemoveTraits(.isSelected)
        })
        .accessibilityLabel(isUnread ? accessibilityLabelWithUnreadDot : accessibilityLabel)
    }

    private let leadingImage: Image?
    private let style: PillButtonStyle
    private let title: String
    private let action: (() -> Void)?
}
