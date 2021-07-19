//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Properties that make up section content
@objc public class MSFListSectionState: NSObject, ObservableObject, Identifiable {
    public var id = UUID()
    @objc @Published public var cells: [MSFListCellState] = []
    @objc @Published public var title: String?
    @objc @Published public var backgroundColor: UIColor?
    @objc @Published public var hasDividers: Bool = false
    @objc @Published public var style: MSFHeaderFooterStyle = .headerPrimary {
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
@objc public class MSFListState: NSObject, ObservableObject {
    @objc @Published public var sections: [MSFListSectionState] = []
}

public struct MSFListView: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var tokens: MSFListTokens
    @ObservedObject var state: MSFListState

    public init(sections: [MSFListSectionState]) {
        self.state = MSFListState()
        self.tokens = MSFListTokens()
        self.state.sections = sections
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
                            if let lastCell = section.cells.last {
                                let last = findLastCell(lastCell)
                            }
                            Divider()
                                .overlay(Color(tokens.borderColor))
                        }
                    }
                }
            }
            .environment(\.defaultMinListRowHeight, 0)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .designTokens(tokens,
                          from: theme,
                          with: windowProvider)
    }

    private func findLastCell(_ lastCell: MSFListCellState) -> MSFListCellState {
        if let children = lastCell.children {
            return lastDivider(findLastCell(children[children.count - 1]))
        } else {
            return lastDivider(lastCell)
        }
    }

    private func lastDivider(_ cell: MSFListCellState) -> MSFListCellState {
        let state = cell
        state.hasDivider = false
        return state
    }

    private func updateCellDividers() -> [MSFListSectionState] {
        state.sections.forEach { section in
            section.cells.forEach { cell in
                cell.hasDivider = section.hasDividers
            }
            section.cells.last?.hasDivider = false
        }
        return state.sections
    }
}

/// UIKit wrapper that exposes the SwiftUI List implementation
@objc open class MSFList: NSObject, FluentUIWindowProvider {

    @objc public init(sections: [MSFListSectionState],
                      theme: FluentUIStyle? = nil) {
        super.init()

        listView = MSFListView(sections: sections)
        hostingController = UIHostingController(rootView: AnyView(listView
                                                                    .windowProvider(self)
                                                                    .modifyIf(theme != nil, { listView in
                                                                        listView.customTheme(theme!)
                                                                    })))
        view.backgroundColor = UIColor.clear
    }

    @objc public convenience init(sections: [MSFListSectionState]) {
        self.init(sections: sections,
                  theme: nil)
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

    private var hostingController: UIHostingController<AnyView>!

    private var listView: MSFListView!
}
