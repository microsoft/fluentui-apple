//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// UIKit wrapper that exposes the SwiftUI List implementation
@objc open class MSFList: NSObject, FluentUIWindowProvider {

    @objc public init(theme: FluentUIStyle? = nil) {
        super.init()

        listView = MSFListView()
        hostingController = FluentUIHostingController(rootView: AnyView(listView
                                                                            .windowProvider(self)
                                                                            .modifyIf(theme != nil, { listView in
                                                                                listView.customTheme(theme!)
                                                                            })))
        hostingController.disableSafeAreaInsets()
        view.backgroundColor = UIColor.clear
    }

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc open var state: MSFListState {
        return listView.state
    }

    var window: UIWindow? {
        return self.view.window
    }

    private var hostingController: FluentUIHostingController!

    private var listView: MSFListView!
}

/// Properties that can be used to customize the appearance of the List Section.
@objc public protocol MSFListSectionState {
    /// Sets the Section title.
    var title: String? { get set }

    /// Sets a custom background color for the List Section.
    var backgroundColor: UIColor? { get set }

    /// Configures divider presence within the Section.
    var hasDividers: Bool { get set }

    /// Configures the Section's `HeaderFooter` style.
    var style: MSFHeaderFooterStyle { get set }

    /// The number of Cells in the Section.
    var cellCount: Int { get }

    /// Creates a new Cell and appends it to the array of cells in a Section.
    func createCell() -> MSFListCellState

    /// Creates a new Cell within the Section at a specific index.
    /// - Parameter index: The zero-based index of the Cell that will be inserted into the Section.
    func createCell(at index: Int) -> MSFListCellState

    /// Retrieves the state object for a specific Cell so its appearance can be customized.
    /// - Parameter index: The zero-based index of the Cell in the Section.
    func getCellState(at index: Int) -> MSFListCellState

    /// Remove a Cell from the Section.
    /// - Parameter index: The zero-based index of the Cell that will be removed from the Section.
    func removeCell(at index: Int)
}

/// Properties that can be used to customize the appearance of the List.
@objc public protocol MSFListState {
    /// The number of Sections in the List.
    var sectionCount: Int { get }

    /// Creates a new Section and appends it to the array of sections in a List.
    func createSection() -> MSFListSectionState

    /// Creates a new Section within the List at a specific index.
    /// - Parameter index: The zero-based index of the Section that will be inserted into the List.
    func createSection(at index: Int) -> MSFListSectionState

    /// Retrieves the state object for a specific Section so its appearance can be customized.
    /// - Parameter index: The zero-based index of the Section in the List.
    func getSectionState(at index: Int) -> MSFListSectionState

    /// Remove a Section from the List.
    /// - Parameter index: The zero-based index of the Section that will be removed from the List.
    func removeSection(at index: Int)
}

public struct MSFListView: View {
    public init() {
        self.state = MSFListStateImpl()
        self.tokens = MSFListTokens()
    }

    public var body: some View {
        let sections = self.updateCellDividers()
        ScrollView {
            VStack(spacing: 0) {
                ForEach(sections, id: \.self) { section in
                    if let sectionTitle = section.title, !sectionTitle.isEmpty {
                        Header(state: section)
                    }

                    ForEach(section.cells.indices, id: \.self) { index in
                        let cellState = section.cells[index]
                        MSFListCellView(state: cellState)
                            .frame(maxWidth: .infinity)
                    }

                    if section.hasDividers {
                        FluentDivider()
                    }
                }
            }
        }
        .animation(.default)
        .environment(\.defaultMinListRowHeight, 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .designTokens(tokens,
                      from: theme,
                      with: windowProvider)
    }

    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var tokens: MSFListTokens
    @ObservedObject var state: MSFListStateImpl

    /// Finds the last cell directly adjacent to the end of a list section. This is used to remove the redundant separator that is
    /// inserted between each cell. Used as a fix until we are able to use the new List Separators in iOS 15.
    private func findLastCell(_ lastCell: MSFListCellState) -> MSFListCellState {
        let childrenCellCount = lastCell.childrenCellCount
        if childrenCellCount > 0, lastCell.isExpanded {
            let lastChild = lastCell.getChildCellState(at: childrenCellCount - 1)
            return findLastCell(lastChild)
        }
        return lastCell
    }

    /// Updates the status of dividers presence within the entire List.
    private func updateCellDividers() -> [MSFListSectionStateImpl] {
        state.sections.forEach { section in
            section.cells.forEach { cell in
                cell.hasDivider = section.hasDividers
            }
            if section.hasDividers, let lastCell = section.cells.last {
                findLastCell(lastCell).hasDivider = false
            }
        }
        return state.sections
    }
}

/// Properties that make up section content
class MSFListSectionStateImpl: NSObject, ObservableObject, Identifiable, MSFListSectionState {
    var headerTokens: MSFHeaderFooterTokens
    var id = UUID()

    @Published private(set) var cells: [MSFListCellStateImpl] = []
    @Published var title: String?
    @Published var backgroundColor: UIColor?
    @Published var hasDividers: Bool = false

    init(style: MSFHeaderFooterStyle = .headerPrimary) {
        self.headerTokens = MSFHeaderFooterTokens(style: style)
        super.init()
    }

    // MARK: - MSFListSectionStateImpl accessors

    var cellCount: Int {
        return cells.count
    }

    var style: MSFHeaderFooterStyle {
        get {
            return headerTokens.style
        }
        set {
            headerTokens.style = newValue
        }
    }

    func createCell() -> MSFListCellState {
        return createCell(at: cells.endIndex)
    }

    func createCell(at index: Int) -> MSFListCellState {
        guard index <= cells.count && index >= 0 else {
            preconditionFailure("Index is out of bounds")
        }
        let cell = MSFListCellStateImpl()
        cells.insert(cell, at: index)
        return cell
    }

    func getCellState(at index: Int) -> MSFListCellState {
        guard cells.indices.contains(index) else {
            preconditionFailure("Index is out of bounds")
        }
        return cells[index]
    }

    func removeCell(at index: Int) {
        guard cells.indices.contains(index) else {
            preconditionFailure("Index is out of bounds")
        }
        cells.remove(at: index)
    }
}

/// Properties that make up list content
class MSFListStateImpl: NSObject, ObservableObject, MSFListState {
    var tokens: MSFListTokens
    @Published private(set) var sections: [MSFListSectionStateImpl] = []

    override init() {
        self.tokens = MSFListTokens()
        super.init()
    }

    // MARK: - MSFListStateImpl accessors

    var sectionCount: Int {
        return sections.count
    }

    func createSection() -> MSFListSectionState {
        return createSection(at: sections.endIndex)
    }

    func createSection(at index: Int) -> MSFListSectionState {
        guard index <= sections.count && index >= 0 else {
            preconditionFailure("Index is out of bounds")
        }
        let section = MSFListSectionStateImpl()
        sections.insert(section, at: index)
        return section
    }

    func getSectionState(at index: Int) -> MSFListSectionState {
        guard sections.indices.contains(index) else {
            preconditionFailure("Index is out of bounds")
        }
        return sections[index]
    }

    func removeSection(at index: Int) {
        guard sections.indices.contains(index) else {
            preconditionFailure("Index is out of bounds")
        }
        sections.remove(at: index)
    }
}
