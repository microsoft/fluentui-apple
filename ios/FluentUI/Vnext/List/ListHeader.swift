//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

struct Header: View, ConfigurableTokenizedControl {
    init(configuration: MSFListSectionConfigurationImpl) {
        self.configuration = configuration
    }

    var body: some View {
        let backgroundColor: Color = {
            guard let configurationBackgroundColor = configuration.backgroundColor else {
                return Color(dynamicColor: tokens.backgroundColor)
            }
            return Color(configurationBackgroundColor)
        }()

        HStack(spacing: 0) {
            if let title = configuration.title, !title.isEmpty {
                Text(title)
                    .font(.fluent(tokens.textFont))
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
    }

    let defaultTokens: HeaderTokens = .init()
    var tokens: HeaderTokens {
        return resolvedTokens
    }
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var configuration: MSFListSectionConfigurationImpl
}
