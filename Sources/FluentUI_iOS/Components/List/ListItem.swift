//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import SwiftUI

public typealias ListItemAccessoryType = TableViewCellAccessoryType
public typealias ListItemBackgroundStyleType = TableViewCellBackgroundStyleType
public typealias ListItemLeadingContentSize = MSFTableViewCellCustomViewSize
public typealias ListItemTokenSet = TableViewCellTokenSet
public typealias ListItemToken = TableViewCellToken

/// View that represents an item in a List.
public struct ListItem<LeadingContent: View,
                       TrailingContent: View,
                       Title: StringProtocol,
                       Subtitle: StringProtocol,
                       Footer: StringProtocol,
                       DetailedContent: View>: View {

    // MARK: Initializer

    /// Creates a `ListItem`
    /// - Parameters:
    ///   - title: Text that appears as the first line of text
    ///   - subtitle: Text that appears as the second line of text
    ///   - footer: Text that appears as the third line of text
    ///   - leadingContent: The content that appears on the leading edge of the view
    ///   - trailingContent: The content that appears on the trailing edge of the view, next to the accessory type if provided
    ///   - detailedContent: The content that appears in a sheet when the accessory detail button is tapped
    ///   - action: The action to be dispatched by tapping on the `ListItem`
    public init(title: Title,
                subtitle: Subtitle = String(),
                footer: Footer = String(),
                @ViewBuilder leadingContent: @escaping () -> LeadingContent,
                @ViewBuilder trailingContent: @escaping () -> TrailingContent,
                @ViewBuilder detailedContent: @escaping () -> DetailedContent,
                action: (() -> Void)? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.footer = footer
        self.leadingContent = leadingContent
        self.trailingContent = trailingContent
        self.detailedContent = detailedContent
        self.action = action
    }

    public var body: some View {
        let tokenSet = ListItemTokenSet(customViewSize: { leadingContentSize })
        tokenSet.replaceAllOverrides(with: tokenOverrides)
        tokenSet.update(fluentTheme)

        @ViewBuilder
        var titleView: some View {
            Text(title)
                .foregroundColor(Color(uiColor: tokenSet[.titleColor].uiColor))
                .font(Font(tokenSet[.titleFont].uiFont))
                .frame(minHeight: ListItemTokenSet.titleHeight)
                .lineLimit(titleLineLimit)
                .truncationMode(titleTruncationMode)
                .accessibilityIdentifier(AccessibilityIdentifiers.title)
        }

        @ViewBuilder
        var subtitleView: some View {
            let subtitleView = Text(subtitle)
                .foregroundColor(Color(uiColor: tokenSet[.subtitleColor].uiColor))
                .lineLimit(subtitleLineLimit)
                .truncationMode(subtitleTruncationMode)
                .accessibilityIdentifier(AccessibilityIdentifiers.subtitle)

            switch layoutType {
            case .oneLine:
                // Subtitle is not shown for oneLine
                EmptyView()
            case .twoLines:
                subtitleView
                    .font(Font(tokenSet[.subtitleTwoLinesFont].uiFont))
                    .frame(minHeight: ListItemTokenSet.subtitleTwoLineHeight)
            case .threeLines:
                subtitleView
                    .font(Font(tokenSet[.subtitleThreeLinesFont].uiFont))
                    .frame(minHeight: ListItemTokenSet.subtitleThreeLineHeight)
            }
        }

        @ViewBuilder
        var footerView: some View {
            Text(footer)
                .foregroundColor(Color(uiColor: tokenSet[.footerColor].uiColor))
                .font(Font(tokenSet[.footerFont].uiFont))
                .frame(minHeight: ListItemTokenSet.footerHeight)
                .lineLimit(footerLineLimit)
                .truncationMode(footerTruncationMode)
                .accessibilityIdentifier(AccessibilityIdentifiers.footer)
        }

        @ViewBuilder
        var labelStack: some View {
            VStack(alignment: .leading, spacing: ListItemTokenSet.labelVerticalSpacing) {
                switch layoutType {
                case .oneLine:
                    titleView
                case .twoLines:
                    titleView
                    subtitleView
                case .threeLines:
                    titleView
                    subtitleView
                    footerView
                }
            }
        }

        @ViewBuilder
        var accessoryView: some View {
            if accessoryType != .none,
               let icon = accessoryType.icon,
               let iconColor = accessoryType.iconColor(tokenSet: tokenSet, fluentTheme: fluentTheme) {
                let image = Image(uiImage: icon)
                    .foregroundColor(Color(uiColor: iconColor))
                    .accessibilityIdentifier(AccessibilityIdentifiers.accessoryImage)
                Group {
                    if accessoryType == .detailButton {
                        SwiftUI.Button {
                            if let onAccessoryTapped = onAccessoryTapped {
                                onAccessoryTapped()
                            }

                            if detailedContent != nil {
                                showingDetailedContent = true
                            }
                        } label: {
                            image
                        }
#if os(visionOS)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.circle)
#else
                        .buttonStyle(.plain)
#endif
                        .accessibilityIdentifier(AccessibilityIdentifiers.accessoryDetailButton)
                        .accessibility(label: Text("Accessibility.TableViewCell.MoreActions.Label".localized))
                        .accessibility(hint: Text("Accessibility.TableViewCell.MoreActions.Hint".localized))
                        .popover(isPresented: $showingDetailedContent, content: {
                            if let detailedContent {
                                detailedContent()
                            }
                        })
                    } else {
                        image
                            .accessibilityHidden(true)
                    }
                }
                .padding(.leading, ListItemTokenSet.horizontalSpacing)
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
        var leadingContentView: some View {
            if let leadingContent {
                leadingContent()
                    .frame(width: tokenSet[.customViewWidth].float,
                           height: tokenSet[.customViewHeight].float)
                    .padding(.trailing, tokenSet[.customViewTrailingMargin].float)
                    .accessibilityIdentifier(AccessibilityIdentifiers.leadingContent)
            }
        }

        @ViewBuilder
        var trailingContentView: some View {
            if let trailingContent {
                trailingContent()
                    .tint(Color(fluentTheme.color(.brandForeground1)))
                    .padding(.leading, ListItemTokenSet.horizontalSpacing)
                    .accessibilityIdentifier(AccessibilityIdentifiers.trailingContent)
            }
        }

        @ViewBuilder
        var innerContent: some View {
            HStack(alignment: .center) {
                HStack(spacing: 0) {
                    leadingContentView
                    labelStack
                        .animation(.default, value: layoutType)
                    Spacer(minLength: 0)
                    if combineTrailingContentAccessibilityElement {
                        trailingContentView
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilitySortPriority(2)
                if !combineTrailingContentAccessibilityElement {
                    trailingContentView
                        .accessibilitySortPriority(1)
                }
                accessoryView
            }
            .padding(EdgeInsets(top: ListItemTokenSet.paddingVertical,
                                leading: ListItemTokenSet.paddingLeading,
                                bottom: ListItemTokenSet.paddingVertical,
                                trailing: ListItemTokenSet.paddingTrailing))
            .frame(minHeight: layoutType.minHeight)
            .opacity(isEnabled ? ListItemTokenSet.enabledAlpha : ListItemTokenSet.disabledAlpha)
            .background(backgroundView)
            .listRowBackground(backgroundView)
        }

        @ViewBuilder
        var contentView: some View {
            Group {
                if let action = action {
                    SwiftUI.Button(action: action, label: {
                        innerContent
                            .accessibilityElement(children: .combine)
                    })
                    .buttonStyle(ListItemButtonStyle(backgroundStyleType: backgroundStyleType, tokenSet: tokenSet))
                } else {
                    innerContent
                        // This is necessary so that the VoiceOver focus ring includes the `innerContent` padding.
                        // When accessoryType == .detailButton, the detail button should be its own accessiblity element.
                        .modifyIf(accessoryType != .detailButton, { content in
                            content
                                .accessibilityElement(children: .combine)
                        })
                }
            }
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

    /// The `ListItemAccessoryType` that the `ListItem` should display.
    var accessoryType: ListItemAccessoryType = .none

    /// The custom background styling of the `ListItem`, which is preferred over the `FluentListStyle` environment value.
    var customBackgroundStyleType: ListItemBackgroundStyleType?

    /// The handler for when the `detailButton` accessory view is tapped.
    var onAccessoryTapped: (() -> Void)?

    /// The maximum amount of lines shown for the `title`.
    var titleLineLimit: Int?

    /// The maximum amount of lines shown for the `subtitle`.
    var subtitleLineLimit: Int?

    /// The maximum amount of lines shown for the `footer`.
    var footerLineLimit: Int?

    /// The truncation mode of the `title`.
    var titleTruncationMode: Text.TruncationMode = .tail

    /// The truncation mode of the `subtitle`.
    var subtitleTruncationMode: Text.TruncationMode = .tail

    /// The truncation mode of the `footer`.
    var footerTruncationMode: Text.TruncationMode = .tail

    /// The size of the `LeadingContent`.
    var leadingContentSize: ListItemLeadingContentSize = .default

    /// Whether or not the `TrailingContent` should be combined or be a separate accessibility element.
    var combineTrailingContentAccessibilityElement: Bool = true

    // MARK: Private variables

    /// The background styling of the `ListItem`.
    private var backgroundStyleType: ListItemBackgroundStyleType {
        let styleType: ListItemBackgroundStyleType
        if let customBackgroundStyleType {
            styleType = customBackgroundStyleType
        } else {
            switch listStyle {
            case .plain, .inset:
                styleType = .plain
            case .insetGrouped:
                styleType = .grouped
            }
        }
        return styleType
    }

    @Environment(\.fluentTheme) private var fluentTheme: FluentTheme
    @Environment(\.isEnabled) private var isEnabled: Bool
    /// The style of the parent `FluentList`.
    @Environment(\.listStyle) private var listStyle: FluentListStyle

    /// If a popover with the content for the detail button is currently being displayed
    @State private var showingDetailedContent: Bool = false

    private var leadingContent: (() -> LeadingContent)?
    private var trailingContent: (() -> TrailingContent)?
    private var detailedContent: (() -> DetailedContent)?
    private var action: (() -> Void)?

    private let footer: Footer
    private let subtitle: Subtitle
    private let title: Title

    private var tokenOverrides: [ListItemToken: ControlTokenValue]?
}

// MARK: Internal structs

private struct ListItemButtonStyle: SwiftUI.ButtonStyle {
    init(backgroundStyleType: ListItemBackgroundStyleType, tokenSet: ListItemTokenSet) {
        self.backgroundStyleType = backgroundStyleType
        self.tokenSet = tokenSet
    }

    func makeBody(configuration: Configuration) -> some View {
        let backgroundColor = configuration.isPressed ? tokenSet[.cellBackgroundSelectedColor].uiColor : .clear
        let cornerRadius = backgroundStyleType == .plain && Compatibility.isDeviceIdiomVision() ? 16.0 : 0

        return configuration.label
            .background(Color(backgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
            .pointerInteraction(isEnabled)
    }

    let backgroundStyleType: ListItemBackgroundStyleType
    let tokenSet: ListItemTokenSet

    @Environment(\.isEnabled) private var isEnabled: Bool
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

public extension ListItem where LeadingContent == EmptyView, TrailingContent == EmptyView, DetailedContent == EmptyView {
    init(title: Title,
         subtitle: Subtitle = String(),
         footer: Footer = String(),
         action: (() -> Void)? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.footer = footer
        self.action = action
    }
}

public extension ListItem where LeadingContent == EmptyView, TrailingContent == EmptyView {
    init(title: Title,
         subtitle: Subtitle = String(),
         footer: Footer = String(),
         @ViewBuilder detailedContent: @escaping () -> DetailedContent,
         action: (() -> Void)? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.footer = footer
        self.detailedContent = detailedContent
        self.action = action
    }
}

public extension ListItem where LeadingContent == EmptyView, DetailedContent == EmptyView {
    init(title: Title,
         subtitle: Subtitle = String(),
         footer: Footer = String(),
         @ViewBuilder trailingContent: @escaping () -> TrailingContent,
         action: (() -> Void)? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.footer = footer
        self.trailingContent = trailingContent
        self.action = action
    }
}

public extension ListItem where TrailingContent == EmptyView, DetailedContent == EmptyView {
    init(title: Title,
         subtitle: Subtitle = String(),
         footer: Footer = String(),
         @ViewBuilder leadingContent: @escaping () -> LeadingContent,
         action: (() -> Void)? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.footer = footer
        self.leadingContent = leadingContent
        self.action = action
    }
}

public extension ListItem where TrailingContent == EmptyView {
    init(title: Title,
         subtitle: Subtitle = String(),
         footer: Footer = String(),
         @ViewBuilder leadingContent: @escaping () -> LeadingContent,
         @ViewBuilder detailedContent: @escaping () -> DetailedContent,
         action: (() -> Void)? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.footer = footer
        self.leadingContent = leadingContent
        self.detailedContent = detailedContent
        self.action = action
    }
}

public extension ListItem where LeadingContent == EmptyView {
    init(title: Title,
         subtitle: Subtitle = String(),
         footer: Footer = String(),
         @ViewBuilder trailingContent: @escaping () -> TrailingContent,
         @ViewBuilder detailedContent: @escaping () -> DetailedContent,
         action: (() -> Void)? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.footer = footer
        self.trailingContent = trailingContent
        self.detailedContent = detailedContent
        self.action = action
    }
}

public extension ListItem where DetailedContent == EmptyView {
    init(title: Title,
         subtitle: Subtitle = String(),
         footer: Footer = String(),
         @ViewBuilder leadingContent: @escaping () -> LeadingContent,
         @ViewBuilder trailingContent: @escaping () -> TrailingContent,
         action: (() -> Void)? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.footer = footer
        self.leadingContent = leadingContent
        self.trailingContent = trailingContent
        self.action = action
    }
}

/// Provide defaults for generic types so static methods can be called without needing to specify them.
public extension ListItem where LeadingContent == EmptyView, TrailingContent == EmptyView, DetailedContent == EmptyView, Title == String, Subtitle == String, Footer == String {

    /// The background color of `ListItem` based on the style.
    /// - Parameter backgroundStyle: The background style of the `List`.
    /// - Returns: The color to use for the background of `ListItem`.
    @available(*, deprecated, renamed: "ListItemTokenSet.listItemBackgroundColor(for:)")
    static func listItemBackgroundColor(for backgroundStyle: ListItemBackgroundStyleType) -> Color {
        let tokenSet = ListItemTokenSet(customViewSize: { .default })
        switch backgroundStyle {
        case .grouped:
            return Color(uiColor: tokenSet[.cellBackgroundGroupedColor].uiColor)
        case .plain:
            return Color(uiColor: tokenSet[.cellBackgroundColor].uiColor)
        case .clear, .custom:
            return .clear
        }
    }
}

public extension ListItem {
    /// Provide override values for various `ListItem` values.
    mutating func overrideTokens(_ overrides: [ListItemToken: ControlTokenValue]) -> Self {
        tokenOverrides = overrides
        return self
    }
}
