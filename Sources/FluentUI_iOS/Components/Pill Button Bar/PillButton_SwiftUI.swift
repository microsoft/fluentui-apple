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

    @State var isUnread: Bool
    @State var isSelected: Bool
    @State var isDisabled: Bool

    public init(style: PillButtonStyle,
                title: String,
                leadingImage: Image? = nil,
                isSelected: Bool = false,
                isDisabled: Bool = false,
                isUnread: Bool = false,
                action: (() -> Void)?) {
        self.tokenSet = PillButtonTokenSet(style: { style })
        self.style = style
        self.title = title
        self.isSelected = isSelected
        self.isDisabled = isDisabled
        self.isUnread = isUnread
        self.action = action
        self.leadingImage = leadingImage
    }
 
    public var body: some View {
        tokenSet.update(fluentTheme)

        let accessibilityLabel = title
        let accessibilityLabelWithUnreadDot = String(format: "Accessibility.TabBarItemView.UnreadFormat".localized, title)

        @ViewBuilder
        var button: some View {
            SwiftUI.Button {
                action?()

                if isUnread {
                    isUnread = false
                }
                print("Configuration label tapped")
            } label: {
                HStack(spacing: 4.0) {
                    if let leadingImage {
                        leadingImage
                            .foregroundStyle(iconColor)
                            .frame(width: 16, height: 16)
                    }

                    Text(title)
                        .foregroundStyle(titleColor)
                }
            }
            .buttonStyle(PillButtonStateStyle(isSelected: isSelected,
                                              isDisabled: isDisabled,
                                              isUnread: isUnread,
                                              tokenSet: tokenSet))
            .disabled(isDisabled)
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

        return button
    }

    private let leadingImage: Image?
    private let style: PillButtonStyle
    private let title: String
    private let action: (() -> Void)?

    private var titleColor: Color {
        if isSelected {
            if isDisabled {
                return tokenSet[.titleColorSelectedDisabled].color
            } else {
                return tokenSet[.titleColorSelected].color
            }
        } else {
            if isDisabled {
                return tokenSet[.titleColorDisabled].color
            } else {
                return tokenSet[.titleColor].color
            }
        }
    }

    private var iconColor: Color {
        if isSelected {
            if isDisabled {
                return tokenSet[.iconColorSelectedDisabled].color
            } else {
                return tokenSet[.iconColorSelected].color
            }
        } else {
            if isDisabled {
                return tokenSet[.iconColorDisabled].color
            } else {
                return tokenSet[.iconColor].color
            }
        }
    }
}

private struct PillButtonStateStyle: SwiftUI.ButtonStyle {
    let isSelected: Bool
    let isDisabled: Bool
    let isUnread: Bool
    let tokenSet: PillButtonTokenSet

    fileprivate func makeBody(configuration: Configuration) -> some View {
        @ViewBuilder var contentShape: some Shape {
            RoundedRectangle(cornerRadius: PillButtonTokenSet.cornerRadius)
        }

        @ViewBuilder var backgroundView: some View {
            backgroundColor.clipShape(contentShape)
        }

        return configuration.label
            .font(Font(tokenSet[.font].uiFont))
            .padding(.horizontal, PillButtonTokenSet.horizontalInset)
            .padding(.top, PillButtonTokenSet.topInset)
            .padding(.bottom, PillButtonTokenSet.bottomInset)
            .background(backgroundView)
            .overlay(alignment: .topTrailing) {
                if isUnread {
                    Circle()
                        .fill(unreadDotBackgroundColor)
                        .frame(width: PillButtonTokenSet.unreadDotSize,
                               height: PillButtonTokenSet.unreadDotSize)
                        .offset(x: -8, y: 8)
                        .transition(.identity)
                }
            }
            .clipShape(contentShape)
            .contentShape(contentShape)
    }

    var backgroundColor: Color {
        if isSelected {
            if isDisabled {
                return tokenSet[.backgroundColorSelectedDisabled].color
            } else {
                return tokenSet[.backgroundColorSelected].color
            }
        } else {
            if isDisabled {
                return tokenSet[.backgroundColorDisabled].color
            } else {
                return tokenSet[.backgroundColor].color
            }
        }
    }

    @Environment(\.isFocused) var isFocused: Bool

    var unreadDotBackgroundColor: Color {
        return isDisabled ? tokenSet[.disabledUnreadDotColor].color : tokenSet[.enabledUnreadDotColor].color
    }
}
