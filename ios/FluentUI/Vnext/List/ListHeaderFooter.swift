//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

struct Header: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @ObservedObject var state: MSFListSectionState
    @ObservedObject var tokens: MSFHeaderFooterTokens

    init(state: MSFListSectionState, windowProvider: FluentUIWindowProvider?) {
        self.state = state
        self.tokens = MSFHeaderFooterTokens(style: state.style)
        self.tokens.windowProvider = windowProvider
    }

    var body: some View {
        HStack(spacing: 0) {
            if let title = state.title, !title.isEmpty {
                Text(title)
                    .font(Font(tokens.textFont))
                    .foregroundColor(Color(tokens.textColor))
            }
            Spacer()
        }
        .padding(EdgeInsets(top: tokens.topPadding,
                            leading: tokens.leadingPadding,
                            bottom: tokens.bottomPadding,
                            trailing: tokens.trailingPadding))
        .frame(minHeight: tokens.headerHeight)
        .background(Color(tokens.backgroundColor))
        .onAppear {
            // When environment values are available through the view hierarchy:
            //  - If we get a non-default theme through the environment values,
            //    we use to override the theme from this view and its hierarchy.
            //  - Otherwise we just refresh the tokens to reflect the theme
            //    associated with the window that this View belongs to.
            if theme == ThemeKey.defaultValue {
                self.tokens.updateForCurrentTheme()
            } else {
                self.tokens.theme = theme
            }
        }
    }
}
