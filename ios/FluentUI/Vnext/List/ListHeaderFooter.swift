//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

struct Header: View {
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
                    .listRowInsets(EdgeInsets())
                    .padding(.top, tokens.horizontalCellPadding / 2)
                    .padding(.leading, tokens.horizontalCellPadding)
                    .padding(.trailing, tokens.horizontalCellPadding)
                    .padding(.bottom, tokens.horizontalCellPadding / 2)
            }
            Spacer()
        }
        .background(Color(tokens.backgroundColor))
    }
}
