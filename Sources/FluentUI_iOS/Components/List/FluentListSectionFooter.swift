//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// This component is a work in progress. Expect changes to be made to it on a somewhat regular basis.
///
/// It is intended to be used in conjunction with `FluentUI.FluentListSection` and `FluentUI.ListItem`
public struct FluentListSectionFooter<Description: StringProtocol>: View {

    // MARK: Initializer

    /// Creates a `FluentListSectionFooter`
    /// - Parameters:
    ///   - description: description of the section to be shown in the footer.
    public init(description: Description) {
        self.description = description
        self.tokenSet = .init(style: { .footer }, accessoryButtonStyle: { .regular })
    }

    public var body: some View {
        tokenSet.update(fluentTheme)

        @ViewBuilder var descriptionView: some View {
            Text(description)
                .textCase(nil)
                .font(Font(tokenSet[.textFont].uiFont))
                .foregroundStyle(tokenSet[.textColor].color)
        }

        return descriptionView
    }

    // MARK: Private variables

    private let description: Description
    private let tokenSet: ListSectionHeaderFooterTokenSet
    @Environment(\.fluentTheme) private var fluentTheme: FluentTheme
}
