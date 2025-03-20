//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public typealias ListSectionHeaderFooterTokenSet = TableViewHeaderFooterViewTokenSet

/// Defines the visual style of the FluentListSectionHeader
public enum ListSectionHeaderStyle {
    case regular
    case primary
}

/// This component is a work in progress. Expect changes to be made to it on a somewhat regular basis.
///
/// It is intended to be used in conjunction with `FluentUI.FluentListSection` and `FluentUI.ListItem`
public struct FluentListSectionHeader<Title: StringProtocol, TrailingContent: View>: View {

    // MARK: Initializer

    /// Creates a `FluentListSectionHeader`
    /// - Parameters:
    ///   - title: title of the section to be shown in the header.
    ///   - style:  The visual style of how the header should be displayed.
    ///   - trailingContent: content that appears on the trailing edge of the view.
    public init(title: Title,
                style: ListSectionHeaderStyle,
                @ViewBuilder trailingContent: @escaping () -> TrailingContent) {
        self.title = title
        self.tokenSet = .init(style: { FluentListSectionHeader.tokenSetStyle(style) }, accessoryButtonStyle: { .regular })
        self.trailingContent = trailingContent
    }

    public var body: some View {
        tokenSet.update(fluentTheme)

        @ViewBuilder var titleView: some View {
            Text(title)
                // By default uppercasing is applied, setting nil to not enforce casing
                .textCase(nil)
                .font(Font(tokenSet[.textFont].uiFont))
                .foregroundStyle(tokenSet[.textColor].color)
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

    // MARK: private methods

    static func tokenSetStyle(_ style: ListSectionHeaderStyle) -> TableViewHeaderFooterView.Style {
        switch style {
        case .regular:
            return .header
        case .primary:
            return .headerPrimary
        }
    }

    // MARK: Private variables

    private var trailingContent: (() -> TrailingContent)?
    private let title: Title
    private let tokenSet: ListSectionHeaderFooterTokenSet
    @Environment(\.fluentTheme) private var fluentTheme: FluentTheme
}

// MARK: Additional Initializers

public extension FluentListSectionHeader where TrailingContent == EmptyView {
    init(title: Title) {
        self.title = title
        self.tokenSet = .init(style: { .header }, accessoryButtonStyle: { .regular })
    }
}

public extension FluentListSectionHeader where TrailingContent == EmptyView {
    init(title: Title, style: ListSectionHeaderStyle) {
        self.title = title
        self.tokenSet = .init(style: { FluentListSectionHeader.tokenSetStyle(style) }, accessoryButtonStyle: { .regular })
    }
}
