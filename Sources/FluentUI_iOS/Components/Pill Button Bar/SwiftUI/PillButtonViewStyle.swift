//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import SwiftUI

/// Configures a `PillButtonView` according to its style and design tokens.
struct PillButtonViewStyle: SwiftUI.ButtonStyle {
    let isSelected: Bool
    let isUnread: Bool
    let leadingImage: Image?
    let tokenSet: PillButtonTokenSet

    func makeBody(configuration: Configuration) -> some View {
        @ViewBuilder var contentShape: some Shape {
            RoundedRectangle(cornerRadius: PillButtonTokenSet.cornerRadius)
        }

        @ViewBuilder var backgroundView: some View {
            backgroundColor.clipShape(contentShape)
        }

        @ViewBuilder var labelView: some View {
            HStack(spacing: PillButtonTokenSet.iconAndLabelSpacing) {
                if let leadingImage {
                    leadingImage
                        .foregroundStyle(iconColor)
                        .frame(width: PillButtonTokenSet.iconSize,
                               height: PillButtonTokenSet.iconSize)
                }

                configuration.label
            }
        }

        return labelView
            .font(Font(tokenSet[.font].uiFont))
            .foregroundStyle(titleColor)
            .padding(.horizontal, PillButtonTokenSet.horizontalInset)
            .padding(.vertical, PillButtonTokenSet.verticalInset)
            .background(backgroundView)
            .overlay(alignment: .topTrailing) {
                if isUnread {
                    Circle()
                        .fill(unreadDotBackgroundColor)
                        .frame(width: PillButtonTokenSet.unreadDotSize,
                               height: PillButtonTokenSet.unreadDotSize)
                        .offset(x: -PillButtonTokenSet.unreadDotEdgeOffsetX,
                                y: PillButtonTokenSet.unreadDotEdgeOffsetY)
                        .transition(.identity)
                }
            }
            .contentShape(contentShape)
    }

    private var unreadDotBackgroundColor: Color {
        if isEnabled {
            return tokenSet[.enabledUnreadDotColor].color
        } else {
            return tokenSet[.disabledUnreadDotColor].color
        }
    }

    private var titleColor: Color {
        if isSelected {
            if isEnabled {
                return tokenSet[.titleColorSelected].color
            } else {
                return tokenSet[.titleColorSelectedDisabled].color
            }
        } else {
            if isEnabled {
                return tokenSet[.titleColor].color
            } else {
                return tokenSet[.titleColorDisabled].color
            }
        }
    }

    private var backgroundColor: Color {
        if isSelected {
            if isEnabled {
                return tokenSet[.backgroundColorSelected].color
            } else {
                return tokenSet[.backgroundColorSelectedDisabled].color
            }
        } else {
            if isEnabled {
                return tokenSet[.backgroundColor].color
            } else {
                return tokenSet[.backgroundColorDisabled].color
            }
        }
    }

    private var iconColor: Color {
        if isSelected {
            if isEnabled {
                return tokenSet[.iconColorSelected].color
            } else {
                return tokenSet[.iconColorSelectedDisabled].color
            }
        } else {
            if isEnabled {
                return tokenSet[.iconColor].color
            } else {
                return tokenSet[.iconColorDisabled].color
            }
        }
    }

    @Environment(\.isEnabled) private var isEnabled: Bool
}
