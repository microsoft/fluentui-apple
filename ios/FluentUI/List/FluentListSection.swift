//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// This a wrapper around `SwiftUI.Section` that has fluent style applied. It is intended to be used in conjunction with `FluentUI.FluentList` and `FluentUI.ListItem`
/// to provide a completely fluentized list, however, it can be used on it's own if desired.
///
/// This component is a work in progress. Expect changes to be made to it on a somewhat regular basis.
public struct FluentListSection<SectionContent: View, SectionHeaderContent: View, SectionFooterContent: View>: View {

    // MARK: Initializer

    /// Creates a `FluentListSection`
    /// - Parameters:
    ///   - content: content to show inside of the section.
    ///   - header: content to show inside of the header.
    ///   - footer: content to show inside of the footer.
    public init(@ViewBuilder content: @escaping () -> SectionContent,
                @ViewBuilder header: @escaping () -> SectionHeaderContent,
                @ViewBuilder footer: @escaping () -> SectionFooterContent) {
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
                if let header = header {
                    header()
                } else {
                    if listStyle == .insetGrouped {
                        // Currently only a minimum header height and section spacing can
                        // be specified for a SwiftUI.List. To have a consistent
                        // minimum height it needs to be specified but it doesn't account for section spacing.
                        // This is an issue as it will always be larger then we want unless we set
                        // section spacing to 0. If we do that and don't have a header, there will
                        // be no spacing between sections so providing a default header.
                        Text("")
                            .accessibilityHidden(true)
                    }
                }
            } footer: {
                if let footer = footer {
                    footer()
                }
            }
        }
        return sectionView
    }

    // MARK: Private variables

    /// Content to display in the body of the section
    private var content: () -> SectionContent

    /// Content to display in the footer of the section
    private var footer: (() -> SectionFooterContent)?

    /// Content to display in the header of the section
    private var header: (() -> SectionHeaderContent)?

    /// The style of the parent list for the section
    @Environment(\.listStyle) private var listStyle: FluentListStyle
}

public extension FluentListSection where SectionHeaderContent == EmptyView, SectionFooterContent == EmptyView {
    init(@ViewBuilder content: @escaping () -> SectionContent) {
        self.content = content
    }
}

public extension FluentListSection where SectionFooterContent == EmptyView {
    init(@ViewBuilder content: @escaping () -> SectionContent, @ViewBuilder header: @escaping () -> SectionHeaderContent) {
        self.content = content
        self.header = header
    }
}

public extension FluentListSection where SectionHeaderContent == EmptyView {
    init(@ViewBuilder content: @escaping () -> SectionContent, @ViewBuilder footer: @escaping () -> SectionFooterContent) {
        self.content = content
        self.footer = footer
    }
}
