//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// This component is a work in progress. Expect changes to be made to it on a somewhat regular basis.
///
/// It is intended to be used in conjunction with `FluentUI.FluentListSection` and `FluentUI.ListItem`
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
                // By default uppercasing is applied, setting nil to not enforce casing
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
