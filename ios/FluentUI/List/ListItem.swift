//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public typealias ListItemAccessoryType = TableViewCellAccessoryType
public typealias ListItemBackgroundStyleType = TableViewCellBackgroundStyleType
public typealias ListItemCustomViewSize = MSFTableViewCellCustomViewSize
public typealias ListItemTokenSet = TableViewCellTokenSet

/// View that represents an item in a List.
public struct ListItem<LeadingView: View,
                       TrailingView: View,
                       Title: StringProtocol,
                       Subtitle: StringProtocol,
                       Footer: StringProtocol>: View {

	// MARK: Initializer

	/// Creates a ListItem view
	/// - Parameters:
	///   - title: Text that appears as the first line of text
	///   - subtitle: Text that appears as the second line of text
	///   - footer: Text that appears as the third line of text
	///   - leadingView: The view that appears on the leading edge of the view
	///   - trailingView: The view that appears on the trailing edge of the view, next to the accessory type if provided
    public init(title: Title,
                subtitle: Subtitle = String(),
                footer: Footer = String(),
                @ViewBuilder leadingView: @escaping () -> LeadingView,
                @ViewBuilder trailingView: @escaping () -> TrailingView) {
        self.title = title
        self.subtitle = subtitle
        self.footer = footer
        self.leadingView = leadingView()
        self.trailingView = trailingView()
    }

    public var body: some View {
        tokenSet.update(fluentTheme)

        @ViewBuilder
        var labelStack: some View {
            let titleView = Text(title)
                                .foregroundColor(Color(uiColor: tokenSet[.titleColor].uiColor))
                                .font(Font(tokenSet[.titleFont].uiFont))
                                .frame(minHeight: ListItemTokenSet.titleHeight)
                                .lineLimit(state.titleLineLimit)
                                .truncationMode(state.titleTruncationMode)

            switch layoutType {
            case .oneLine:
                titleView
            case .twoLines, .threeLines:
                let subtitleView = Text(subtitle)
                    .foregroundColor(Color(uiColor: tokenSet[.subtitleColor].uiColor))
                    .lineLimit(state.subtitleLineLimit)
                    .truncationMode(state.subtitleTruncationMode)
                VStack(alignment: .leading, spacing: ListItemTokenSet.labelVerticalSpacing) {
                    titleView
                    if layoutType == .twoLines {
                        subtitleView
                            .font(Font(tokenSet[.subtitleTwoLinesFont].uiFont))
                            .frame(minHeight: ListItemTokenSet.subtitleTwoLineHeight)
                    } else if layoutType == .threeLines {
                        subtitleView
                            .font(Font(tokenSet[.subtitleThreeLinesFont].uiFont))
                            .frame(minHeight: ListItemTokenSet.subtitleThreeLineHeight)
                        Text(footer)
                            .foregroundColor(Color(uiColor: tokenSet[.footerColor].uiColor))
                            .font(Font(tokenSet[.footerFont].uiFont))
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
               let iconColor = accessoryType.iconColor(tokenSet: tokenSet, fluentTheme: fluentTheme) {
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
            if let backgroundColor = state.backgroundStyleType.defaultColor(tokenSet: tokenSet) {
                Color(backgroundColor)
            }
        }

        @ViewBuilder
        var contentView: some View {
            HStack(alignment: .center) {
                leadingView
                    .padding(.trailing, ListItemTokenSet.horizontalSpacing)
                labelStack
                    .padding(.trailing, ListItemTokenSet.horizontalSpacing)
                Spacer()
                trailingView
                    .tint(Color(fluentTheme.color(.brandForeground1)))
                accessoryView
                    .padding(.leading, ListItemTokenSet.horizontalSpacing)
            }
            .padding(EdgeInsets(top: ListItemTokenSet.paddingVertical + 1,
                                leading: ListItemTokenSet.paddingLeading,
                                bottom: ListItemTokenSet.paddingVertical + 1,
                                trailing: ListItemTokenSet.paddingTrailing))
            .frame(minHeight: layoutType.minHeight)
            .background(backgroundView)
            .listRowInsets(EdgeInsets())
        }

        return contentView
    }

    var state: ListItemState = ListItemState()

    private var layoutType: LayoutType {
        if !subtitle.isEmpty {
            if !footer.isEmpty {
                return .threeLines
            }
            return .twoLines
        }
        return .oneLine
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
    }

    @Environment(\.fluentTheme) private var fluentTheme: FluentTheme

    private var leadingView: LeadingView?
    private var trailingView: TrailingView?

    private let footer: Footer
    private let subtitle: Subtitle
    private let title: Title
    private let tokenSet: ListItemTokenSet = ListItemTokenSet(customViewSize: { ListItemCustomViewSize.zero })
}

// MARK: Additional Initializers

public extension ListItem where LeadingView == EmptyView, TrailingView == EmptyView {
    init(title: Title,
         subtitle: Subtitle = String(),
         footer: Footer = String()) {
        self.title = title
        self.subtitle = subtitle
        self.footer = footer
    }
}

public extension ListItem where TrailingView == EmptyView {
    init(title: Title,
         subtitle: Subtitle = String(),
         footer: Footer = String(),
         @ViewBuilder leadingView: @escaping () -> LeadingView) {
        self.title = title
        self.subtitle = subtitle
        self.footer = footer
        self.leadingView = leadingView()
    }
}

public extension ListItem where LeadingView == EmptyView {
    init(title: Title,
         subtitle: Subtitle = String(),
         footer: Footer = String(),
         @ViewBuilder trailingView: @escaping () -> TrailingView) {
        self.title = title
        self.subtitle = subtitle
        self.footer = footer
        self.trailingView = trailingView()
    }
}
