//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// This a wrapper around `SwiftUI.Section` that has fluent style applied. It is intended to be used in conjunction with `FluentUI.FluentList` and `FluentUI.ListItem`
/// to provide a completely fluentized list, however, it can be used on it's own if desired.
public struct FluentListSection<SectionContent: View, SectionHeaderContent: View, SectionFooterContent: View>: View {

    // MARK: Initializer

    /// Creates a `FluentListSection`
    /// - Parameters:
    ///   - content: content to show inside of the section.
    ///   - header: content to show inside of the header. Defaults to an `EmptyView`.
    ///   - footer: content to show inside of the footer. Defaults to an `EmptyView`.
    public init(@ViewBuilder content: @escaping () -> SectionContent,
                @ViewBuilder header: @escaping () -> SectionHeaderContent = { EmptyView() },
                @ViewBuilder footer: @escaping () -> SectionFooterContent = { EmptyView() }) {
        self.content = content
        self.header = header
        self.footer = footer
    }

    public var body: some View {
        @ViewBuilder
        var sectionView: some View {
            Section {
                content()
            } header: {
                header()
            } footer: {
                footer()
            }
        }
        return sectionView
    }

    // MARK: Private variables

    /// Content to display in the body of the section
    private var content: () -> SectionContent

    /// Content to display in the footer of the section
    private var footer: () -> SectionFooterContent

    /// Content to display in the header of the section
    private var header: () -> SectionHeaderContent

 }
