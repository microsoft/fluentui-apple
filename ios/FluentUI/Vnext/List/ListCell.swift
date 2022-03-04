//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Properties that can be used to customize the appearance of the List Cell.
@objc public protocol MSFListCellConfiguration {
    /// Custom view on the leading side of the Cell.
    var leadingUIView: UIView? { get set }

    /// Size of the `leadingView`.
    var leadingViewSize: MSFListCellLeadingViewSize { get set }

    /// Custom view on the trailing side of the Cell.
    var trailingUIView: UIView? { get set }

    /// Custom view on the leading side of the Cell title.
    var titleLeadingAccessoryUIView: UIView? { get set }

    /// Custom view on the trailing side of the Cell title.
    var titleTrailingAccessoryUIView: UIView? { get set }

    /// Custom view on the leading side of the Cell subtitle.
    var subtitleLeadingAccessoryUIView: UIView? { get set }

    /// Custom view on the trailing side of the Cell subtitle.
    var subtitleTrailingAccessoryUIView: UIView? { get set }

    /// Custom view on the leading side of the Cell footnote.
    var footnoteLeadingAccessoryUIView: UIView? { get set }

    /// Custom view on the trailing side of the Cell footnote.
    var footnoteTrailingAccessoryUIView: UIView? { get set }

    /// The first line of the Cell.
    var title: String { get set }

    /// The second line of the Cell.
    var subtitle: String { get set }

    /// The third line of the Cell.
    var footnote: String { get set }

    /// Type of List accessory, located on the Cell's trailing side.
    var accessoryType: MSFListAccessoryType { get set }

    /// Sets a custom background color for the Cell.
    var backgroundColor: UIColor? { get set }

    /// Sets a custom highlighed background color for the Cell.
    var highlightedBackgroundColor: UIColor? { get set }

    /// Configuress max number of lines in the title.
    var titleLineLimit: Int { get set }

    /// Configuress max number of lines in the subtitle.
    var subtitleLineLimit: Int { get set }

    /// Configuress max number of lines in the footnote.
    var footnoteLineLimit: Int { get set }

    /// Configuress whether the cell is expanded or collapsed if it has children cells.
    var isExpanded: Bool { get set }

    /// Sets the cell as a one-line, two-line, or three-line layout type.
    var layoutType: MSFListCellLayoutType { get set }

    /// Configuress divider visibility, which is located under the cell.
    var hasDivider: Bool { get set }

    /// Assigns an action to the cell when it is tapped.
    var onTapAction: (() -> Void)? { get set }

    /// The number of children cells in the Cell.
    var childrenCellCount: Int { get }

    /// Creates a new child cell and appends it to the array of children cells in a Cell.
    func createChildCell() -> MSFListCellConfiguration

    /// Creates a new child cell within the array of children cells at a specific index.
    /// - Parameter index: The zero-based index of the child cell that will be inserted into the array of children cells.
    func createChildCell(at index: Int) -> MSFListCellConfiguration

    /// Retrieves the configuration object for a specific child cell so its appearance can be customized.
    /// - Parameter index: The zero-based index of the child cell in the array of children cells.
    func getChildCellConfiguration(at index: Int) -> MSFListCellConfiguration

    /// Remove a child cell from the Cell.
    /// - Parameter index: The zero-based index of the child cell that will be removed from the array of children cells.
    func removeChildCell(at index: Int)
}

/// `MSFListCellConfigurationImpl` contains properties that make up a cell content.
class MSFListCellConfigurationImpl: NSObject, ObservableObject, Identifiable, ControlConfiguration, MSFListCellConfiguration {
    init(cellLeadingViewSize: MSFListCellLeadingViewSize = .medium) {
        self.leadingViewSize = cellLeadingViewSize

        super.init()
    }

    @Published var overrideTokens: CellBaseTokens?
    @Published var leadingView: AnyView?
    @Published var titleLeadingAccessoryView: AnyView?
    @Published var titleTrailingAccessoryView: AnyView?
    @Published var subtitleLeadingAccessoryView: AnyView?
    @Published var subtitleTrailingAccessoryView: AnyView?
    @Published var footnoteLeadingAccessoryView: AnyView?
    @Published var footnoteTrailingAccessoryView: AnyView?
    @Published var trailingView: AnyView?

    @Published var title: String = ""
    @Published var subtitle: String = ""
    @Published var footnote: String = ""
    @Published var accessoryType: MSFListAccessoryType = .none
    @Published var backgroundColor: UIColor?
    @Published var highlightedBackgroundColor: UIColor?
    @Published var titleLineLimit: Int = 0
    @Published var subtitleLineLimit: Int = 0
    @Published var footnoteLineLimit: Int = 0
    @Published var isExpanded: Bool = false
    @Published var layoutType: MSFListCellLayoutType = .automatic
    @Published var hasDivider: Bool = false
    @Published private(set) var children: [MSFListCellConfigurationImpl] = []
    var onTapAction: (() -> Void)?
    var id = UUID()

    var leadingUIView: UIView? {
        didSet {
            guard let view = leadingUIView else {
                leadingView = nil
                return
            }

            leadingView = AnyView(UIViewAdapter(view))
        }
    }

    @Published var leadingViewSize: MSFListCellLeadingViewSize

    var trailingUIView: UIView? {
        didSet {
            guard let view = trailingUIView else {
                trailingView = nil
                return
            }

            trailingView = AnyView(UIViewAdapter(view))
        }
    }

    var titleLeadingAccessoryUIView: UIView? {
        didSet {
            guard let view = titleLeadingAccessoryUIView else {
                titleLeadingAccessoryView = nil
                return
            }

            titleLeadingAccessoryView = AnyView(UIViewAdapter(view))
        }
    }

    var titleTrailingAccessoryUIView: UIView? {
        didSet {
            guard let view = titleTrailingAccessoryUIView else {
                titleTrailingAccessoryView = nil
                return
            }

            titleTrailingAccessoryView = AnyView(UIViewAdapter(view))
        }
    }

    var subtitleLeadingAccessoryUIView: UIView? {
        didSet {
            guard let view = subtitleLeadingAccessoryUIView else {
                subtitleLeadingAccessoryView = nil
                return
            }

            subtitleLeadingAccessoryView = AnyView(UIViewAdapter(view))
        }
    }

    var subtitleTrailingAccessoryUIView: UIView? {
        didSet {
            guard let view = subtitleTrailingAccessoryUIView else {
                subtitleTrailingAccessoryView = nil
                return
            }

            subtitleTrailingAccessoryView = AnyView(UIViewAdapter(view))
        }
    }

    var footnoteLeadingAccessoryUIView: UIView? {
        didSet {
            guard let view = footnoteLeadingAccessoryUIView else {
                footnoteLeadingAccessoryView = nil
                return
            }

            footnoteLeadingAccessoryView = AnyView(UIViewAdapter(view))
        }
    }

    var footnoteTrailingAccessoryUIView: UIView? {
        didSet {
            guard let view = footnoteTrailingAccessoryUIView else {
                footnoteTrailingAccessoryView = nil
                return
            }

            footnoteTrailingAccessoryView = AnyView(UIViewAdapter(view))
        }
    }

    var childrenCellCount: Int {
        return children.count
    }

    func createChildCell() -> MSFListCellConfiguration {
        return createChildCell(at: children.endIndex)
    }

    func createChildCell(at index: Int) -> MSFListCellConfiguration {
        guard index <= children.count && index >= 0 else {
            preconditionFailure("Index is out of bounds")
        }
        let cell = MSFListCellConfigurationImpl()
        children.insert(cell, at: index)
        return cell
    }

    func getChildCellConfiguration(at index: Int) -> MSFListCellConfiguration {
        guard children.indices.contains(index) else {
            preconditionFailure("Index is out of bounds")
        }
        return children[index]
    }

    func removeChildCell(at index: Int) {
        guard children.indices.contains(index) else {
            preconditionFailure("Index is out of bounds")
        }
        children.remove(at: index)
    }
}

/// Pre-defined layout heights of cells
@objc public enum MSFListCellLayoutType: Int, CaseIterable {
    case automatic
    case oneLine
    case twoLines
    case threeLines
}

/// View for List Cells
struct MSFListCellView: View, ConfigurableTokenizedControl {

    init(configuration: MSFListCellConfigurationImpl) {
        self.configuration = configuration
    }

    var body: some View {

        @ViewBuilder
        var cellLabel: some View {
            let horizontalCellPadding: CGFloat = tokens.horizontalCellPadding
            let leadingViewSize: CGFloat = tokens.leadingViewSize
            let leadingViewAreaSize: CGFloat = tokens.leadingViewAreaSize

            HStack(spacing: 0) {
                let hasTitle: Bool = !configuration.title.isEmpty
                let labelAccessoryInterspace: CGFloat = tokens.labelAccessoryInterspace
                let labelAccessorySize: CGFloat = tokens.labelAccessorySize
                let sublabelAccessorySize: CGFloat = tokens.sublabelAccessorySize
                let trailingItemSize: CGFloat = tokens.trailingItemSize

                if let leadingView = configuration.leadingView {
                    HStack(alignment: .center, spacing: 0) {
                        leadingView
                            .frame(width: leadingViewSize, height: leadingViewSize)
                    }
                    .frame(width: leadingViewAreaSize)
                    .padding(.trailing, horizontalCellPadding)
                }

                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        if let titleLeadingAccessoryView = configuration.titleLeadingAccessoryView {
                            titleLeadingAccessoryView
                                .frame(width: labelAccessorySize, height: labelAccessorySize)
                                .padding(.trailing, labelAccessoryInterspace)
                        }
                        if hasTitle {
                            Text(configuration.title)
                                .font(.fluent(tokens.labelFont))
                                .foregroundColor(Color(dynamicColor: tokens.labelColor))
                                .lineLimit(configuration.titleLineLimit == 0 ? nil : configuration.titleLineLimit)
                        }
                        if let titleTrailingAccessoryView = configuration.titleTrailingAccessoryView {
                            titleTrailingAccessoryView
                                .frame(width: labelAccessorySize, height: labelAccessorySize)
                                .padding(.leading, labelAccessoryInterspace)
                        }
                    }

                    HStack(spacing: 0) {
                        if let subtitleLeadingAccessoryView = configuration.subtitleLeadingAccessoryView {
                            subtitleLeadingAccessoryView
                                .frame(width: sublabelAccessorySize, height: sublabelAccessorySize)
                                .padding(.trailing, labelAccessoryInterspace)
                        }
                        if !configuration.subtitle.isEmpty {
                            Text(configuration.subtitle)
                                .font(.fluent(configuration.footnote.isEmpty ?
                                                            tokens.footnoteFont : tokens.sublabelFont))
                                .foregroundColor(Color(dynamicColor: tokens.sublabelColor))
                                .lineLimit(configuration.subtitleLineLimit == 0 ? nil : configuration.subtitleLineLimit)
                        }
                        if let subtitleTrailingAccessoryView = configuration.subtitleTrailingAccessoryView {
                            subtitleTrailingAccessoryView
                                .frame(width: sublabelAccessorySize, height: sublabelAccessorySize)
                                .padding(.leading, labelAccessoryInterspace)
                        }
                    }

                    HStack(spacing: 0) {
                        if let footnoteLeadingAccessoryView = configuration.footnoteLeadingAccessoryView {
                            footnoteLeadingAccessoryView
                                .frame(width: labelAccessorySize, height: labelAccessorySize)
                                .padding(.trailing, labelAccessoryInterspace)
                        }
                        if !configuration.footnote.isEmpty {
                            Text(configuration.footnote)
                                .font(.fluent(tokens.footnoteFont))
                                .foregroundColor(Color(dynamicColor: tokens.sublabelColor))
                                .lineLimit(configuration.footnoteLineLimit == 0 ? nil : configuration.footnoteLineLimit)
                        }
                        if let footnoteTrailingAccessoryView = configuration.footnoteTrailingAccessoryView {
                            footnoteTrailingAccessoryView
                                .frame(width: labelAccessorySize, height: labelAccessorySize)
                                .padding(.leading, labelAccessoryInterspace)
                        }
                    }
                }

                Spacer()

                if let trailingView = configuration.trailingView {
                    trailingView
                        .frame(width: trailingItemSize, height: trailingItemSize)
                        .fixedSize()
                }

                HStack(spacing: 0) {
                    if let accessoryType = configuration.accessoryType, accessoryType != .none, let accessoryIcon = accessoryType.icon {
                        let isDisclosure = accessoryType == .disclosure
                        let disclosureSize = tokens.disclosureSize
                        Image(uiImage: accessoryIcon)
                            .resizable()
                            .foregroundColor(Color(dynamicColor: isDisclosure ?
                                                   tokens.disclosureIconForegroundColor : tokens.trailingItemForegroundColor))
                            .frame(width: isDisclosure ? disclosureSize : trailingItemSize,
                                   height: isDisclosure ? disclosureSize : trailingItemSize)
                            .padding(.leading, isDisclosure ? tokens.disclosureInterspace : tokens.iconInterspace)
                    }
                }
            }

        }

        @ViewBuilder
        var cellContent: some View {
            let children: [MSFListCellConfigurationImpl] = configuration.children
            let hasChildren: Bool = children.count > 0
            let horizontalCellPadding: CGFloat = tokens.horizontalCellPadding
            let leadingViewAreaSize: CGFloat = tokens.leadingViewAreaSize

            Button(action: configuration.onTapAction ?? {
                if hasChildren {
                    withAnimation {
                        configuration.isExpanded.toggle()
                    }
                }
            }, label: {
                cellLabel
            })
            .buttonStyle(ListCellButtonStyle(tokens: tokens, configuration: configuration))

            if configuration.hasDivider {
                let padding = horizontalCellPadding +
                    (configuration.leadingView != nil ? horizontalCellPadding + leadingViewAreaSize : 0)
                FluentDivider()
                    .padding(.leading, padding)
            }

            if hasChildren, configuration.isExpanded == true {
                ForEach(children, id: \.self) { child in
                    MSFListCellView(configuration: child)
                        .frame(maxWidth: .infinity)
                        .padding(.leading, (horizontalCellPadding + leadingViewAreaSize))
                }
            }
        }

        return cellContent
    }

    func overrideTokens(_ tokens: CellBaseTokens?) -> MSFListCellView {
        configuration.overrideTokens = tokens
        return self
    }

    let defaultTokens: CellBaseTokens = .init()
    var tokens: CellBaseTokens {
        let tokens = resolvedTokens
        tokens.cellLeadingViewSize = configuration.leadingViewSize
        return tokens
    }
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var configuration: MSFListCellConfigurationImpl
}

struct ListCellButtonStyle: ButtonStyle {
    let tokens: CellBaseTokens
    let configuration: MSFListCellConfiguration

    func makeBody(configuration: Self.Configuration) -> some View {
        let height: CGFloat
        let horizontalCellPadding: CGFloat = tokens.horizontalCellPadding
        let verticalCellPadding: CGFloat = tokens.verticalCellPadding
        switch self.configuration.layoutType {
        case .automatic:
            height = !self.configuration.footnote.isEmpty ? tokens.cellHeightThreeLines :
                    (!self.configuration.subtitle.isEmpty ? tokens.cellHeightTwoLines : tokens.cellHeightOneLine)
        case .oneLine:
            height = tokens.cellHeightOneLine
        case .twoLines:
            height = tokens.cellHeightTwoLines
        case .threeLines:
            height = tokens.cellHeightThreeLines
        }
        return configuration.label
            .contentShape(Rectangle())
            .padding(EdgeInsets(top: verticalCellPadding,
                                leading: horizontalCellPadding,
                                bottom: verticalCellPadding,
                                trailing: horizontalCellPadding))
            .frame(minHeight: height)
            .background(backgroundColor(configuration.isPressed))
    }

    private func backgroundColor(_ isPressed: Bool = false) -> Color {
        let highlightedBackgroundColor: Color = {
            guard let configurationHighlightedBackgroundColor = configuration.highlightedBackgroundColor else {
                return Color(dynamicColor: tokens.highlightedBackgroundColor)
            }
            return Color(configurationHighlightedBackgroundColor)
        }()

        let backgroundColor: Color = {
            guard let configurationBackgroundColor = configuration.backgroundColor else {
                return Color(dynamicColor: tokens.backgroundColor)
            }
            return Color(configurationBackgroundColor)
        }()

        if isPressed {
            return highlightedBackgroundColor
        }
        return backgroundColor
    }
}
