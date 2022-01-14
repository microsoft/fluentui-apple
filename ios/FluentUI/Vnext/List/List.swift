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

@objc public protocol MSFListSectionState {
    var cells: [MSFListCellState] { get set }
    var title: String? { get set }
    var backgroundColor: UIColor? { get set }
    var hasDividers: Bool { get set }
    var style: MSFHeaderFooterStyle { get set }
}

@objc public protocol MSFListState {
    /// Creates a new Section within the List.
    func createSection() -> MSFListSectionState

    /// Creates a new Section within the List at a specific index.
    func createSection(at index: Int) -> MSFListSectionState

    /// Retrieves the state object for a specific Section so its appearance can be customized.
    /// - Parameter index: The zero-based index of the Section in the List.
    func getSectionState(at index: Int) -> MSFListSectionState

    /// Remove an Section from the List.
    /// - Parameter index: The zero-based index of the Section that will be removed from the List.
    func removeSection(at index: Int)
}

public struct MSFListView: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var tokens: MSFListTokens
    @ObservedObject var state: MSFListStateImpl

    public init() {
        self.state = MSFListStateImpl()
        self.tokens = MSFListTokens()
//        self.state.sections = sections
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

    /// Finds the last cell directly adjacent to the end of a list section. This is used to remove the redundant separator that is
    /// inserted between each cell. Used as a fix until we are able to use the new List Separators in iOS 15.
    private func findLastCell(_ lastCell: MSFListCellState) -> MSFListCellState {
        if let children = lastCell.children {
            if lastCell.isExpanded {
                guard let lastChild = children.last else {
                    preconditionFailure("Does not contain any children cells")
                }
                return findLastCell(lastChild)
            }
        }
        return lastCell
    }

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
    var id = UUID()
    @Published var cells: [MSFListCellState] = []
    @Published var title: String?
    @Published var backgroundColor: UIColor?
    @Published var hasDividers: Bool = false
    @Published var style: MSFHeaderFooterStyle = .headerPrimary {
        didSet {
            if style != oldValue {
                headerTokens.style = style
                headerTokens.updateForCurrentTheme()
            }
        }
    }

    var headerTokens = MSFHeaderFooterTokens(style: .headerPrimary)
}

/// Properties that make up list content
class MSFListStateImpl: NSObject, ObservableObject, MSFListState {
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

    @Published var sections: [MSFListSectionStateImpl] = []

    var tokens: MSFListTokens

    override init() {
        self.tokens = MSFListTokens()
        super.init()
    }
}
