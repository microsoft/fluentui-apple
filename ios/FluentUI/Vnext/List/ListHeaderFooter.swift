//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// View for List Header (availble for iOS 14.0+)
struct Header: View {
    let title: String
    var tokens: MSFListTokens

    init(title: String, tokens: MSFListTokens) {
        self.title = title
        self.tokens = tokens
    }

    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(Font(tokens.subtitleFont))
                .foregroundColor(Color(tokens.subtitleColor))
                .listRowInsets(EdgeInsets())
                .padding(.top, tokens.horizontalCellPadding / 2)
                .padding(.leading, tokens.horizontalCellPadding)
                .padding(.trailing, tokens.horizontalCellPadding)
                .padding(.bottom, tokens.horizontalCellPadding / 2)
            Spacer()
        }
        .background(Color(tokens.backgroundColor))
    }
}
