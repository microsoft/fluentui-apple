//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public typealias ListItemAccessoryType = TableViewCellAccessoryType
public typealias ListItemBackgroundStyleType = TableViewCellBackgroundStyleType
public typealias ListItemLeadingContentSize = MSFTableViewCellCustomViewSize
public typealias ListItemTokenSet = TableViewCellTokenSet

/// View that represents an item in a List.
public struct ListItem<LeadingContent: View,
                       TrailingContent: View,
                       Title: StringProtocol,
                       Subtitle: StringProtocol,
                       Footer: StringProtocol>: View {

	// MARK: Initializer

	/// Creates a ListItem view
	/// - Parameters:
	///   - title: Text that appears as the first line of text
	///   - subtitle: Text that appears as the second line of text
	///   - footer: Text that appears as the third line of text
	///   - leadingContent: The content that appears on the leading edge of the view
	///   - trailingContent: The content that appears on the trailing edge of the view, next to the accessory type if provided
    public init(title: Title,
                subtitle: Subtitle = String(),
                footer: Footer = String(),
                @ViewBuilder leadingContent: @escaping () -> LeadingContent,
                @ViewBuilder trailingContent: @escaping () -> TrailingContent) {
        self.title = title
        self.subtitle = subtitle
        self.footer = footer
        self.leadingContent = leadingContent
        self.trailingContent = trailingContent
        let layoutType = ListItem.layoutType(subtitle: subtitle, footer: footer)
        self.state = ListItemState(leadingContentSize: layoutType.leadingContentSize)
    }

    public var body: some View {
        state.tokenSet.update(fluentTheme)

        @ViewBuilder
        var labelStack: some View {
            let titleView = Text(title)
                                .foregroundColor(Color(uiColor: state.tokenSet[.titleColor].uiColor))
                                .font(Font(state.tokenSet[.titleFont].uiFont))
                                .frame(minHeight: ListItemTokenSet.titleHeight)
                                .lineLimit(state.titleLineLimit)
                                .truncationMode(state.titleTruncationMode)

            switch layoutType {
            case .oneLine:
                titleView
            case .twoLines, .threeLines:
                let subtitleView = Text(subtitle)
                    .foregroundColor(Color(uiColor: state.tokenSet[.subtitleColor].uiColor))
                    .lineLimit(state.subtitleLineLimit)
                    .truncationMode(state.subtitleTruncationMode)
                VStack(alignment: .leading, spacing: ListItemTokenSet.labelVerticalSpacing) {
                    titleView
                    if layoutType == .twoLines {
                        subtitleView
                            .font(Font(state.tokenSet[.subtitleTwoLinesFont].uiFont))
                            .frame(minHeight: ListItemTokenSet.subtitleTwoLineHeight)
                    } else if layoutType == .threeLines {
                        subtitleView
                            .font(Font(state.tokenSet[.subtitleThreeLinesFont].uiFont))
                            .frame(minHeight: ListItemTokenSet.subtitleThreeLineHeight)
                        Text(footer)
                            .foregroundColor(Color(uiColor: state.tokenSet[.footerColor].uiColor))
                            .font(Font(state.tokenSet[.footerFont].uiFont))
                            .frame(minHeight: ListItemTokenSet.footerHeight)
                            .lineLimit(state.footerLineLimit)
                            .truncationMode(state.footerTruncationMode)
                    }
                }
            }
        }

        @ViewBuilder
        var accessoryView: some View {
            if let accessoryType = state.accessoryType,
               let icon = accessoryType.icon,
               let iconColor = accessoryType.iconColor(tokenSet: state.tokenSet, fluentTheme: fluentTheme) {
                let image = Image(uiImage: icon)
                    .foregroundColor(Color(uiColor: iconColor))
                if accessoryType == .detailButton {
                    SwiftUI.Button {
                        if let onAccessoryTapped = state.onAccessoryTapped {
                            onAccessoryTapped()
                        }
                    } label: {
                        image
                    }
                } else {
                    image
                }
            }
        }

        @ViewBuilder
        var backgroundView: some View {
            if let backgroundColor = state.backgroundStyleType.defaultColor(tokenSet: state.tokenSet) {
                Color(backgroundColor)
            }
        }

        @ViewBuilder
        var contentView: some View {
            HStack(alignment: .center) {
                if let leadingContent {
                    leadingContent()
                        .frame(width: state.tokenSet[.customViewDimensions].float,
                               height: state.tokenSet[.customViewDimensions].float)
                        .padding(.trailing, state.tokenSet[.customViewTrailingMargin].float)
                }
                labelStack
                    .padding(.trailing, ListItemTokenSet.horizontalSpacing)
                Spacer()
                if let trailingContent {
                    trailingContent()
                        .tint(Color(fluentTheme.color(.brandForeground1)))
                }
                accessoryView
                    .padding(.leading, ListItemTokenSet.horizontalSpacing)
            }
            .padding(EdgeInsets(top: ListItemTokenSet.paddingVertical,
                                leading: ListItemTokenSet.paddingLeading,
                                bottom: ListItemTokenSet.paddingVertical,
                                trailing: ListItemTokenSet.paddingTrailing))
            .frame(minHeight: layoutType.minHeight)
            .background(backgroundView)
            .listRowInsets(EdgeInsets())
        }

        return contentView
    }

    @ObservedObject var state: ListItemState

    private static func layoutType(subtitle: Subtitle, footer: Footer) -> LayoutType {
        if !subtitle.isEmpty {
            if !footer.isEmpty {
                return .threeLines
            }
            return .twoLines
        }
        return .oneLine
    }

    private var layoutType: LayoutType {
        return ListItem.layoutType(subtitle: subtitle, footer: footer)
    }

    private enum LayoutType {
        case oneLine
        case twoLines
        case threeLines

        var minHeight: CGFloat {
            switch self {
            case .oneLine:
                return ListItemTokenSet.oneLineMinHeight
            case .twoLines:
                return ListItemTokenSet.twoLineMinHeight
            case .threeLines:
                return ListItemTokenSet.threeLineMinHeight
            }
        }

        var leadingContentSize: ListItemLeadingContentSize {
            switch self {
            case .oneLine:
                return .small
            case .twoLines, .threeLines:
                return .medium
            }
        }
    }

    @Environment(\.fluentTheme) private var fluentTheme: FluentTheme

    private var leadingContent: (() -> LeadingContent)?
    private var trailingContent: (() -> TrailingContent)?

    private let footer: Footer
    private let subtitle: Subtitle
    private let title: Title
}

// MARK: Additional Initializers

public extension ListItem where LeadingContent == EmptyView, TrailingContent == EmptyView {
    init(title: Title,
         subtitle: Subtitle = String(),
         footer: Footer = String()) {
        self.title = title
        self.subtitle = subtitle
        self.footer = footer
        let layoutType = ListItem.layoutType(subtitle: subtitle, footer: footer)
        self.state = ListItemState(leadingContentSize: layoutType.leadingContentSize)
    }
}

public extension ListItem where TrailingContent == EmptyView {
    init(title: Title,
         subtitle: Subtitle = String(),
         footer: Footer = String(),
         @ViewBuilder leadingContent: @escaping () -> LeadingContent) {
        self.title = title
        self.subtitle = subtitle
        self.footer = footer
        self.leadingContent = leadingContent
        let layoutType = ListItem.layoutType(subtitle: subtitle, footer: footer)
        self.state = ListItemState(leadingContentSize: layoutType.leadingContentSize)
    }
}

public extension ListItem where LeadingContent == EmptyView {
    init(title: Title,
         subtitle: Subtitle = String(),
         footer: Footer = String(),
         @ViewBuilder trailingContent: @escaping () -> TrailingContent) {
        self.title = title
        self.subtitle = subtitle
        self.footer = footer
        self.trailingContent = trailingContent
        let layoutType = ListItem.layoutType(subtitle: subtitle, footer: footer)
        self.state = ListItemState(leadingContentSize: layoutType.leadingContentSize)
    }
}
