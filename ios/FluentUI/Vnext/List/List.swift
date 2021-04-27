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
    @objc @Published public var style: MSFHeaderFooterStyle = .headerPrimary
    @objc @Published public var title: String?
    @objc @Published public var backgroundColor: UIColor?
    @objc @Published public var hasDividers: Bool = false
}

/// Properties that make up list content
@objc public class MSFListState: NSObject, ObservableObject {
    @objc @Published public var sections: [MSFListSectionState] = []
}

public struct MSFListView: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @ObservedObject var state: MSFListState
    @ObservedObject var tokens: MSFListTokens

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
                            Header(state: section, windowProvider: tokens.windowProvider)
                        }

                        ForEach(section.cells.indices, id: \.self) { index in
                            let cellState = section.cells[index]
                            MSFListCellView(state: cellState,
                                            windowProvider: tokens.windowProvider)
                                .frame(maxWidth: .infinity)
                        }
                        if section.hasDividers {
                            Divider()
                                .overlay(Color(tokens.borderColor))
                        }
                    }
                }
            }
            .environment(\.defaultMinListRowHeight, 0)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                // When environment values are available through the view hierarchy:
                //  - If we get a non-default theme through the environment values,
                //    we use to override the theme from this view and its hierarchy.
                //  - Otherwise we just refresh the tokens to reflect the theme
                //    associated with the window that this View belongs to.
                if theme == ThemeKey.defaultValue {
                    self.tokens.updateForCurrentTheme()
                } else {
                    self.tokens.theme = theme
                }
            }
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
        listView = MSFListView(sections: sections)
        hostingController = UIHostingController(rootView: AnyView(listView.modifyIf(theme != nil, { listView in
            listView.usingTheme(theme!)
        })))

        super.init()

        listView.tokens.windowProvider = self
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
