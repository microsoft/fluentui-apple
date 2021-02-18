//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

struct MSFSlideOutPanelElevation: ViewModifier {
    var direction: MSFDrawerDirection
    var tokens: MSFDrawerTokens

    private struct LegacyShadowConstant {
        static let shadowRadius: CGFloat = 4
        static let shadowOffset: CGFloat = 2
        static let shadowOpacity: Double = 0.05
        static let shadowColor: Color = .black
    }

    func body(content: Content) -> some View {
        switch direction {
        case .left,
             .right:
            return AnyView(content
                            .shadow(color: tokens.shadow1Color,
                                    radius: tokens.shadow1Blur,
                                    x: tokens.shadow1DepthX,
                                    y: tokens.shadow1DepthY)
                            .shadow(color: tokens.shadow2Color,
                                    radius: tokens.shadow2Blur,
                                    x: tokens.shadow2DepthX,
                                    y: tokens.shadow2DepthY))
        case.top:
            return AnyView(
                content
                    .shadow(color: LegacyShadowConstant.shadowColor.opacity(LegacyShadowConstant.shadowOpacity),
                            radius: LegacyShadowConstant.shadowRadius,
                            x: 0,
                            y: LegacyShadowConstant.shadowOffset)
            )
        case.bottom:
            return AnyView(
                content
                    .shadow(color: LegacyShadowConstant.shadowColor.opacity(LegacyShadowConstant.shadowOpacity),
                            radius: LegacyShadowConstant.shadowRadius,
                            x: 0,
                            y: -LegacyShadowConstant.shadowOffset)
            )
        }
    }
}

// MARK: - View Modifiers

extension View {
    /// Custom elevation for the pandel
    func elevation(with tokens: MSFDrawerTokens, alignment: MSFDrawerDirection) -> some View {
        self.modifier(MSFSlideOutPanelElevation(direction: alignment, tokens: tokens))
    }
}
