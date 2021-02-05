//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

struct Header: View {
    @Environment(\.theme) var theme: FluentUIStyle
    let state: MSFListSectionState
    var tokens: MSFListHeaderFooterTokens

    init(state: MSFListSectionState) {
        self.state = state
        self.tokens = MSFListHeaderFooterTokens(style: state.style)
    }

    var body: some View {
        HStack(spacing: 0) {
            if let title = state.title {
                Text(title)
                    .font(Font(tokens.textFont))
                    .foregroundColor(Color(tokens.textColor))
            }
            Spacer()
        }
        .background(Color(tokens.backgroundColor))
        .listRowInsets(EdgeInsets())
        .frame(minHeight: tokens.headerHeight)
        .padding(EdgeInsets(top: tokens.topHeaderPadding,
                            leading: tokens.horizontalHeaderPadding,
                            bottom: tokens.horizontalHeaderPadding / 2,
                            trailing: tokens.horizontalHeaderPadding))
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
