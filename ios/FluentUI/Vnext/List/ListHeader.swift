//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

struct Header: View, TokenizedControlInternal {
    init(state: FluentListSectionStateImpl) {
        self.state = state
    }

    var body: some View {
        let backgroundColor: Color = {
            guard let stateBackgroundColor = state.backgroundColor else {
                return Color(dynamicColor: tokens.backgroundColor)
            }
            return Color(stateBackgroundColor)
        }()

        HStack(spacing: 0) {
            if let title = state.title, !title.isEmpty {
                Text(title)
                    .scalableFont(font: .fluent(tokens.textFont))
                    .foregroundColor(Color(dynamicColor: tokens.textColor))
            }
            Spacer()
        }
        .padding(EdgeInsets(top: tokens.topPadding,
                            leading: tokens.leadingPadding,
                            bottom: tokens.bottomPadding,
                            trailing: tokens.trailingPadding))
        .frame(minHeight: tokens.headerHeight)
        .background(backgroundColor)
        .resolveTokens(self)
    }

    var tokens: HeaderTokens { state.tokens }
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: FluentListSectionStateImpl
}
