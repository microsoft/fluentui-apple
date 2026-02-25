//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public enum MessageBarToken: Int, TokenSetKey {
    /// The background color of the `MessageBar`.
    case backgroundColor

    case titleFont
    case messageFont
}

public class MessageBarTokenSet: ControlTokenSet<MessageBarToken> {
    public init() {
        super.init { token, theme in
            switch token {
            case .backgroundColor:
                return .color { theme.swiftUIColor(.warningBackground1) }
            case.titleFont:
                return .font { .fluent(theme.typographyInfo(.body1Strong)) }
            case .messageFont:
                return .font { .fluent(theme.typographyInfo(.body1)) }
            }
        }
    }
}
