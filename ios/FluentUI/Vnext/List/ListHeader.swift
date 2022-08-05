//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

struct Header: View, TokenizedControlView {
    typealias TokenSetKeyType = HeaderTokenSet.Tokens
    var tokenSet: HeaderTokenSet

    init(state: MSFListSectionStateImpl) {
        self.state = state
        self.tokenSet = HeaderTokenSet(style: { state.style })
    }

    var body: some View {
        let backgroundColor: Color = {
            guard let stateBackgroundColor = state.backgroundColor else {
                return Color(dynamicColor: tokenSet[.backgroundColor].dynamicColor)
            }
            return Color(stateBackgroundColor)
        }()

        HStack(spacing: 0) {
            if let title = state.title, !title.isEmpty {
                Text(title)
                    .font(.fluent(tokenSet[.textFont].fontInfo))
                    .foregroundColor(Color(dynamicColor: tokenSet[.textColor].dynamicColor))
            }
            Spacer()
        }
        .padding(EdgeInsets(top: tokenSet[.topPadding].float,
                            leading: tokenSet[.leadingPadding].float,
                            bottom: tokenSet[.bottomPadding].float,
                            trailing: tokenSet[.trailingPadding].float))
        .frame(minHeight: tokenSet[.headerHeight].float)
        .background(backgroundColor)
        .fluentTokens(tokenSet, fluentTheme)
    }

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFListSectionStateImpl
}
