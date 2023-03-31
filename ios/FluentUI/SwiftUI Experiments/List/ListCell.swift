//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Properties that can be used to customize the appearance of the List Cell.
@objc public protocol MSFListCellState {
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

    /// Configures max number of lines in the title.
    var titleLineLimit: Int { get set }

    /// Configures max number of lines in the subtitle.
    var subtitleLineLimit: Int { get set }

    /// Configures max number of lines in the footnote.
    var footnoteLineLimit: Int { get set }

    /// Configures whether the cell is expanded or collapsed if it has children cells.
    var isExpanded: Bool { get set }

    /// Sets the cell as a one-line, two-line, or three-line layout type.
    var layoutType: MSFListCellLayoutType { get set }

    /// Configures divider visibility, which is located under the cell.
    var hasDivider: Bool { get set }

    /// Assigns an action to the cell when it is tapped.
    var onTapAction: (() -> Void)? { get set }

    /// The number of children cells in the Cell.
    var childrenCellCount: Int { get }

    /// Creates a new child cell and appends it to the array of children cells in a Cell.
    func createChildCell() -> MSFListCellState

    /// Creates a new child cell within the array of children cells at a specific index.
    /// - Parameter index: The zero-based index of the child cell that will be inserted into the array of children cells.
    func createChildCell(at index: Int) -> MSFListCellState

    /// Retrieves the state object for a specific child cell so its appearance can be customized.
    /// - Parameter index: The zero-based index of the child cell in the array of children cells.
    func getChildCellState(at index: Int) -> MSFListCellState

    /// Remove a child cell from the Cell.
    /// - Parameter index: The zero-based index of the child cell that will be removed from the array of children cells.
    func removeChildCell(at index: Int)
}

/// `MSFListCellStateImpl` contains properties that make up a cell content.
class MSFListCellStateImpl: ControlState, MSFListCellState {
    init(cellLeadingViewSize: MSFListCellLeadingViewSize = .medium) {
        self.leadingViewSize = cellLeadingViewSize

        super.init()
    }

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
    @Published private(set) var children: [MSFListCellStateImpl] = []
    var onTapAction: (() -> Void)?
    var id = UUID()
    var onSelectAction: ((MSFListCellStateImpl) -> Void)?
    @Published var isSelected: Bool = false
    var selectionStyle: MSFListSelectionStyle = .trailingCheckmark

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

    func createChildCell() -> MSFListCellState {
        return createChildCell(at: children.endIndex)
    }

    func createChildCell(at index: Int) -> MSFListCellState {
        guard index <= children.count && index >= 0 else {
            preconditionFailure("Index is out of bounds")
        }
        let cell = MSFListCellStateImpl()
        cell.onSelectAction = onSelectAction
        children.insert(cell, at: index)
        return cell
    }

    func getChildCellState(at index: Int) -> MSFListCellState {
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
struct MSFListCellView: View, TokenizedControlView {
    public typealias TokenSetKeyType = ListCellTokenSet.Tokens
    @ObservedObject public var tokenSet: ListCellTokenSet

    init(state: MSFListCellStateImpl) {
        self.state = state
        self.tokenSet = ListCellTokenSet(cellLeadingViewSize: { state.leadingViewSize })
    }

    /// Used by extended cells to provide custom `CellBaseTokenSet` subclasses.
    init(state: MSFListCellStateImpl,
         tokenSet: ListCellTokenSet) {
        self.state = state
        self.tokenSet = tokenSet
    }

    var body: some View {
        let labelColor: Color
        let sublabelColor: Color
        let trailingItemColor: Color
        if state.isSelected {
            labelColor = Color(tokenSet[.labelSelectedColor].uiColor)
            sublabelColor = Color(tokenSet[.sublabelSelectedColor].uiColor)
            trailingItemColor = Color(tokenSet[.trailingItemSelectedForegroundColor].uiColor)
        } else {
            labelColor = Color(tokenSet[.labelColor].uiColor)
            sublabelColor = Color(tokenSet[.sublabelColor].uiColor)
            trailingItemColor = Color(tokenSet[.trailingItemForegroundColor].uiColor)
        }
        let horizontalCellPadding: CGFloat = tokenSet[.horizontalCellPadding].float
        let leadingViewAreaSize: CGFloat = tokenSet[.leadingViewAreaSize].float

        @ViewBuilder
        var cellLabel: some View {
            let leadingViewSize: CGFloat = tokenSet[.leadingViewSize].float

            HStack(spacing: 0) {
                let title = state.title
                let labelAccessoryInterspace: CGFloat = tokenSet[.labelAccessoryInterspace].float
                let labelAccessorySize: CGFloat = tokenSet[.labelAccessorySize].float
                let sublabelAccessorySize: CGFloat = tokenSet[.sublabelAccessorySize].float
                let trailingItemSize: CGFloat = tokenSet[.trailingItemSize].float

                if let leadingView = state.leadingView {
                    HStack(alignment: .center, spacing: 0) {
                        leadingView
                            .frame(width: leadingViewSize, height: leadingViewSize)
                    }
                    .frame(width: leadingViewAreaSize)
                    .padding(.trailing, horizontalCellPadding)
                }

                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        if let titleLeadingAccessoryView = state.titleLeadingAccessoryView {
                            titleLeadingAccessoryView
                                .frame(width: labelAccessorySize, height: labelAccessorySize)
                                .padding(.trailing, labelAccessoryInterspace)
                        }
                        if !title.isEmpty {
                            Text(title)
                                .animation(nil, value: title)
                                .font(.init(tokenSet[.labelFont].uiFont))
                                .foregroundColor(labelColor)
                                .lineLimit(state.titleLineLimit == 0 ? nil : state.titleLineLimit)
                        }
                        if let titleTrailingAccessoryView = state.titleTrailingAccessoryView {
                            titleTrailingAccessoryView
                                .frame(width: labelAccessorySize, height: labelAccessorySize)
                                .padding(.leading, labelAccessoryInterspace)
                        }
                    }

                    HStack(spacing: 0) {
                        if let subtitleLeadingAccessoryView = state.subtitleLeadingAccessoryView {
                            subtitleLeadingAccessoryView
                                .frame(width: sublabelAccessorySize, height: sublabelAccessorySize)
                                .padding(.trailing, labelAccessoryInterspace)
                        }
                        if !state.subtitle.isEmpty {
                            Text(state.subtitle)
                                .font(.init(state.footnote.isEmpty ?
                                                            tokenSet[.footnoteFont].uiFont : tokenSet[.sublabelFont].uiFont))
                                .foregroundColor(sublabelColor)
                                .lineLimit(state.subtitleLineLimit == 0 ? nil : state.subtitleLineLimit)
                        }
                        if let subtitleTrailingAccessoryView = state.subtitleTrailingAccessoryView {
                            subtitleTrailingAccessoryView
                                .frame(width: sublabelAccessorySize, height: sublabelAccessorySize)
                                .padding(.leading, labelAccessoryInterspace)
                        }
                    }

                    HStack(spacing: 0) {
                        if let footnoteLeadingAccessoryView = state.footnoteLeadingAccessoryView {
                            footnoteLeadingAccessoryView
                                .frame(width: labelAccessorySize, height: labelAccessorySize)
                                .padding(.trailing, labelAccessoryInterspace)
                        }
                        if !state.footnote.isEmpty {
                            Text(state.footnote)
                                .font(.init(tokenSet[.footnoteFont].uiFont))
                                .foregroundColor(sublabelColor)
                                .lineLimit(state.footnoteLineLimit == 0 ? nil : state.footnoteLineLimit)
                        }
                        if let footnoteTrailingAccessoryView = state.footnoteTrailingAccessoryView {
                            footnoteTrailingAccessoryView
                                .frame(width: labelAccessorySize, height: labelAccessorySize)
                                .padding(.leading, labelAccessoryInterspace)
                        }
                    }
                }

                Spacer()

                if let trailingView = state.trailingView {
                    trailingView
                        .frame(width: trailingItemSize, height: trailingItemSize)
                        .fixedSize()
                }

                HStack(spacing: 0) {
                    let accessoryType =
                        state.isSelected && state.selectionStyle == .trailingCheckmark
                        ? .checkmark
                        : state.accessoryType
                    if accessoryType != .none, let accessoryIcon = accessoryType.icon {
                        let isDisclosure = accessoryType == .disclosure
                        let disclosureSize = tokenSet[.disclosureSize].float
                        Image(uiImage: accessoryIcon)
                            .resizable()
                            .foregroundColor(isDisclosure ?
                                                   Color(tokenSet[.disclosureIconForegroundColor].uiColor) : trailingItemColor)
                            .frame(width: isDisclosure ? disclosureSize : trailingItemSize,
                                   height: isDisclosure ? disclosureSize : trailingItemSize)
                            .padding(.leading, isDisclosure ? tokenSet[.disclosureInterspace].float : tokenSet[.iconInterspace].float)
                    }
                }
            }

        }

        @ViewBuilder
        var cellContent: some View {
            let children: [MSFListCellStateImpl] = state.children
            let hasChildren: Bool = children.count > 0

            Button(action: {
                if hasChildren {
                    withAnimation {
                        state.isExpanded.toggle()
                    }
                } else if let onSelectAction = state.onSelectAction {
                    onSelectAction(state)
                }
                if let onTapAction = state.onTapAction {
                    onTapAction()
                }
            }, label: {
                cellLabel
            })
            .buttonStyle(ListCellButtonStyle(state: state,
                                             tokenSet: tokenSet))

            if state.hasDivider {
                let padding = horizontalCellPadding +
                    (state.leadingView != nil ? horizontalCellPadding + leadingViewAreaSize : 0)
                Divider()
                    .padding(.leading, padding)
            }

            if hasChildren, state.isExpanded == true {
                ForEach(children, id: \.self) { child in
                    MSFListCellView(state: child)
                        .frame(maxWidth: .infinity)
                        .padding(.leading, (horizontalCellPadding + leadingViewAreaSize))
                }
            }
        }

        return cellContent
    }

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFListCellStateImpl
}

struct ListCellButtonStyle: ButtonStyle {
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFListCellStateImpl
    @ObservedObject var tokenSet: ListCellTokenSet

    func makeBody(configuration: Self.Configuration) -> some View {
        let height: CGFloat
        let horizontalCellPadding: CGFloat = tokenSet[.horizontalCellPadding].float
        let verticalCellPadding: CGFloat = tokenSet[.verticalCellPadding].float
        switch state.layoutType {
        case .automatic:
            height = !state.footnote.isEmpty ? tokenSet[.cellHeightThreeLines].float :
                    (!state.subtitle.isEmpty ? tokenSet[.cellHeightTwoLines].float : tokenSet[.cellHeightOneLine].float)
        case .oneLine:
            height = tokenSet[.cellHeightOneLine].float
        case .twoLines:
            height = tokenSet[.cellHeightTwoLines].float
        case .threeLines:
            height = tokenSet[.cellHeightThreeLines].float
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
            guard let stateHighlightedBackgroundColor = state.highlightedBackgroundColor else {
                return Color(tokenSet[.highlightedBackgroundColor].uiColor)
            }
            return Color(stateHighlightedBackgroundColor)
        }()

        let backgroundColor: Color = {
            guard let stateBackgroundColor = state.backgroundColor else {
                return Color(tokenSet[.backgroundColor].uiColor)
            }
            return Color(stateBackgroundColor)
        }()

        if isPressed && !state.isSelected {
            return highlightedBackgroundColor
        }
        return backgroundColor
    }
}
