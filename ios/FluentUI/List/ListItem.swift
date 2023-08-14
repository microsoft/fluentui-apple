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
        self.tokenSet = ListItemTokenSet(customViewSize: { layoutType.leadingContentSize })
    }

    public var body: some View {
        tokenSet.update(fluentTheme)

        @ViewBuilder
        var labelStack: some View {
            let titleView = Text(title)
                                .foregroundColor(Color(uiColor: tokenSet[.titleColor].uiColor))
                                .font(Font(tokenSet[.titleFont].uiFont))
                                .frame(minHeight: ListItemTokenSet.titleHeight)
                                .lineLimit(titleLineLimit)
                                .truncationMode(titleTruncationMode)
                                .accessibilityIdentifier(AccessibilityIdentifiers.title)

            switch layoutType {
            case .oneLine:
                titleView
            case .twoLines, .threeLines:
                let subtitleView = Text(subtitle)
                    .foregroundColor(Color(uiColor: tokenSet[.subtitleColor].uiColor))
                    .lineLimit(subtitleLineLimit)
                    .truncationMode(subtitleTruncationMode)
                    .accessibilityIdentifier(AccessibilityIdentifiers.subtitle)
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
                            .lineLimit(footerLineLimit)
                            .truncationMode(footerTruncationMode)
                            .accessibilityIdentifier(AccessibilityIdentifiers.footer)
                    }
                }
            }
        }

        @ViewBuilder
        var accessoryView: some View {
            if let accessoryType = accessoryType,
               let icon = accessoryType.icon,
               let iconColor = accessoryType.iconColor(tokenSet: tokenSet, fluentTheme: fluentTheme) {
                let image = Image(uiImage: icon)
                    .foregroundColor(Color(uiColor: iconColor))
                    .accessibilityIdentifier(AccessibilityIdentifiers.accessoryImage)
                if accessoryType == .detailButton {
                    SwiftUI.Button {
                        if let onAccessoryTapped = onAccessoryTapped {
                            onAccessoryTapped()
                        }
                    } label: {
                        image
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.accessoryDetailButton)
                    .accessibility(label: Text("Accessibility.TableViewCell.MoreActions.Label".localized))
                    .accessibility(hint: Text("Accessibility.TableViewCell.MoreActions.Hint".localized))
                } else {
                    image
                }
            }
        }

        @ViewBuilder
        var backgroundView: some View {
            if let backgroundColor = backgroundStyleType.defaultColor(tokenSet: tokenSet) {
                Color(backgroundColor)
            } else {
                EmptyView()
            }
        }

        @ViewBuilder
        var contentView: some View {
            HStack(alignment: .center) {
                if let leadingContent {
                    leadingContent()
                        .frame(width: tokenSet[.customViewDimensions].float,
                               height: tokenSet[.customViewDimensions].float)
                        .padding(.trailing, tokenSet[.customViewTrailingMargin].float)
                        .accessibilityIdentifier(AccessibilityIdentifiers.leadingContent)
                }
                labelStack
                    .padding(.trailing, ListItemTokenSet.horizontalSpacing)
                Spacer()
                if let trailingContent {
                    trailingContent()
                        .tint(Color(fluentTheme.color(.brandForeground1)))
                        .accessibilityIdentifier(AccessibilityIdentifiers.trailingContent)
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

    // MARK: Internal variables

    /// The `ListItemAccessoryType` that the view should display.
    var accessoryType: ListItemAccessoryType?

    /// The background styling of the `ListItem` to match the type of `List` it is displayed in.
    var backgroundStyleType: ListItemBackgroundStyleType = .plain

    /// The handler for when the `detailButton` accessory view is tapped.
    var onAccessoryTapped: (() -> Void)?

    /// The maximum amount of lines shown for the `title`.
    var titleLineLimit: Int = 1

    /// The maximum amount of lines shown for the `subtitle`.
    var subtitleLineLimit: Int = 1

    /// The maximum amount of lines shown for the `footer`.
    var footerLineLimit: Int = 1

    /// The truncation mode of the `title`.
    var titleTruncationMode: Text.TruncationMode = .tail

    /// The truncation mode of the `subtitle`.
    var subtitleTruncationMode: Text.TruncationMode = .tail

    /// The truncation mode of the `footer`.
    var footerTruncationMode: Text.TruncationMode = .tail

    /// Tokens associated with the `ListItem`.
    var tokenSet: ListItemTokenSet

    // MARK: Private variables

    @Environment(\.fluentTheme) private var fluentTheme: FluentTheme

    private var leadingContent: (() -> LeadingContent)?
    private var trailingContent: (() -> TrailingContent)?

    private let footer: Footer
    private let subtitle: Subtitle
    private let title: Title
}

// MARK: Constants

private struct AccessibilityIdentifiers {
    static let title: String = "ListItemTitle"
    static let subtitle: String = "ListItemSubtitle"
    static let footer: String = "ListItemFooter"
    static let leadingContent: String = "ListItemLeadingContent"
    static let trailingContent: String = "ListItemTrailingContent"
    static let accessoryImage: String = "ListItemAccessoryImage"
    static let accessoryDetailButton: String = "ListItemAccessoryDetailButton"
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
        self.tokenSet = ListItemTokenSet(customViewSize: { layoutType.leadingContentSize })
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
        self.tokenSet = ListItemTokenSet(customViewSize: { layoutType.leadingContentSize })
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
        self.tokenSet = ListItemTokenSet(customViewSize: { layoutType.leadingContentSize })
    }
}
