//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public struct FluentListSectionHeader<Title: StringProtocol, TrailingContent: View>: View {

    // MARK: Initializer

    /// Creates a `FluentListSectionHeader`
    /// - Parameters:
    ///   - title: title of the section to be shown in the header.
    ///   - trailingContent: content that appears on the trailing edge of the view.
    public init(title: Title,
                @ViewBuilder trailingContent: @escaping () -> TrailingContent) {
        self.title = title
        self.trailingContent = trailingContent
    }

    public var body: some View {
        @ViewBuilder var titleView: some View {
            Text(title)
                .textCase(nil)
        }

        @ViewBuilder var contentView: some View {
            if let trailingContent {
                HStack {
                    titleView
                    Spacer(minLength: 0)
                    trailingContent()
                }
            } else {
                titleView
            }
        }

        return contentView
    }

    // MARK: Private variables

    private var trailingContent: (() -> TrailingContent)?
    private let title: Title
}

// MARK: Additional Initializers

public extension FluentListSectionHeader where TrailingContent == EmptyView {
    init(title: Title) {
        self.title = title
    }
}
