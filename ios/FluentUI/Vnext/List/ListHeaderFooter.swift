//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

struct Header: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var tokens: MSFHeaderFooterTokens
    @ObservedObject var state: MSFListSectionState

    init(state: MSFListSectionState) {
        self.state = state
        self.tokens = state.headerTokens
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
        .background(Color(state.backgroundColor ?? tokens.backgroundColor))
        .designTokens(tokens,
                      from: theme,
                      with: windowProvider)
    }
}
