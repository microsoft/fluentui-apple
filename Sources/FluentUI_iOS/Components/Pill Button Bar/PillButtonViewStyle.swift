//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import SwiftUI

struct PillButtonViewStyle: SwiftUI.ButtonStyle {
    let isSelected: Bool
    let isUnread: Bool
    let tokenSet: PillButtonTokenSet

    func makeBody(configuration: Configuration) -> some View {
        let backgroundColor: Color
        let titleColor: Color
        let unreadDotBackgroundColor: Color

        if isEnabled {
            unreadDotBackgroundColor = tokenSet[.enabledUnreadDotColor].color

            if isSelected {
                backgroundColor = tokenSet[.backgroundColorSelected].color
                titleColor = tokenSet[.titleColorSelected].color
            } else {
                backgroundColor = tokenSet[.backgroundColor].color
                titleColor = tokenSet[.titleColor].color
            }
        } else {
            unreadDotBackgroundColor = tokenSet[.disabledUnreadDotColor].color

            if isSelected {
                backgroundColor = tokenSet[.backgroundColorSelectedDisabled].color
                titleColor = tokenSet[.titleColorSelectedDisabled].color
            } else {
                backgroundColor = tokenSet[.backgroundColorDisabled].color
                titleColor = tokenSet[.titleColorDisabled].color
            }
        }

        @ViewBuilder var contentShape: some Shape {
            RoundedRectangle(cornerRadius: PillButtonTokenSet.cornerRadius)
        }

        @ViewBuilder var backgroundView: some View {
            backgroundColor.clipShape(contentShape)
        }

        return configuration.label
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

    @Environment(\.isEnabled) private var isEnabled: Bool
}
