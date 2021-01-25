//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Properties that make up cell content
@objc public class MSFListCellState: NSObject, ObservableObject, Identifiable {
    public var id = UUID()
    @objc @Published public var leadingView: UIView?
    @objc @Published public var title: String = ""
    @objc @Published public var subtitle: String?
    @objc @Published public var accessoryType: MSFListAccessoryType = .none
    @objc @Published public var titleLineLimit: Int = 1
    @objc @Published public var subtitleLineLimit: Int = 1
    @objc @Published public var children: [MSFListCellState]?
    @objc @Published public var isExpanded: Bool = false
    @objc @Published public var layoutType: MSFListCellLayoutType = .oneLine
    @objc public var onTapAction: (() -> Void)?
}

/// Properties that make up section content
@objc public class MSFListSectionState: NSObject, ObservableObject, Identifiable {
    public var id = UUID()
    @objc @Published public var cells: [MSFListCellState] = []
    @objc @Published public var title: String?
    @objc @Published public var hasDividers: Bool = false
}

/// Properties that make up list content
@objc public class MSFListState: NSObject, ObservableObject {
    @objc @Published public var sections: [MSFListSectionState] = []
}

/// Pre-defined layout heights of cells
@objc public enum MSFListCellLayoutType: Int, CaseIterable {
    case oneLine
    case twoLines
    case threeLines
}

public struct MSFListView: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @ObservedObject var state: MSFListState
    @ObservedObject var tokens: MSFListTokens

    public init(sections: [MSFListSectionState],
                iconStyle: MSFListIconStyle) {
        self.state = MSFListState()
        self.tokens = MSFListTokens(iconStyle: iconStyle)
        self.state.sections = sections
    }

    public var body: some View {
        let sections = state.sections
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(sections, id: \.self) { section in
                        if let sectionTitle = section.title {
                            Header(title: sectionTitle, tokens: tokens)
                        }

                        ForEach(section.cells.indices, id: \.self) { index in
                            let cell = section.cells[index]
                            let hasDividers = (index < section.cells.count - 1 && section.hasDividers) || (section.hasDividers && (cell.children != nil))
                            MSFListCellView(cell: cell,
                                            tokens: tokens,
                                            hasDividers: hasDividers)
                                .frame(maxWidth: .infinity)
                        }
                        Divider()
                            .background(Color(tokens.borderColor))
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
}

extension MSFListView {
    /// View for List Cells
    struct MSFListCellView: View {
        var cell: MSFListCellState
        @ObservedObject var tokens: MSFListTokens
        var hasDividers: Bool

        init(cell: MSFListCellState, tokens: MSFListTokens, hasDividers: Bool = false) {
            self.cell = cell
            self.tokens = tokens
            self.hasDividers = hasDividers
        }

        var body: some View {
            Button(action: cell.onTapAction ?? {
                if cell.children != nil {
                    withAnimation {
                        cell.isExpanded.toggle()
                    }
                }
            }, label: {
                HStack(spacing: 0) {
                    if let leadingView = cell.leadingView {
                        UIViewAdapter(leadingView)
                            .frame(width: tokens.iconSize, height: tokens.iconSize)
                            .padding(.trailing, tokens.iconInterspace)
                    }
                    VStack(alignment: .leading) {
                        if let title = cell.title {
                            Text(title)
                                .font(Font(tokens.textFont))
                                .foregroundColor(Color(tokens.leadingTextColor))
                                .lineLimit(cell.titleLineLimit)
                        }
                        if let subtitle = cell.subtitle, !subtitle.isEmpty {
                                Text(subtitle)
                                    .font(Font(tokens.subtitleFont))
                                    .foregroundColor(Color(tokens.subtitleColor))
                                    .lineLimit(cell.titleLineLimit)
                        }
                    }
                    Spacer()
                    HStack {
                        if let accessoryType = cell.accessoryType, accessoryType != .none, let accessoryIcon = accessoryType.icon {
                            let isDisclosure = accessoryType == .disclosure
                            let disclosureSize = tokens.disclosureSize
                            let iconSize = tokens.iconSize
                            Image(uiImage: accessoryIcon)
                                .resizable()
                                .foregroundColor(Color(isDisclosure ? tokens.disclosureIconForegroundColor : tokens.trailingItemForegroundColor))
                                .frame(width: isDisclosure ? disclosureSize : iconSize,
                                       height: isDisclosure ? disclosureSize : iconSize)
                                .padding(.leading, isDisclosure ? tokens.disclosureInterspace : tokens.iconInterspace)
                        }
                    }
                }
            })
            .buttonStyle(ListCellButtonStyle(tokens: tokens, layoutType: cell.layoutType))
            if hasDividers {
                Divider()
                    .padding(.leading, (tokens.horizontalCellPadding + tokens.iconSize + tokens.iconInterspace))
            }
            if let children = cell.children, cell.isExpanded == true {
                ForEach(children, id: \.self) { child in
                    MSFListCellView(cell: child,
                                    tokens: tokens,
                                    hasDividers: hasDividers)
                        .frame(maxWidth: .infinity)
                        .padding(.leading, (tokens.horizontalCellPadding + tokens.iconSize))
                }
            }
        }
    }

    struct ListCellButtonStyle: ButtonStyle {
        let tokens: MSFListTokens
        let layoutType: MSFListCellLayoutType

        func makeBody(configuration: Self.Configuration) -> some View {
            let height: CGFloat
            switch layoutType {
            case .oneLine:
                height = tokens.cellHeightOneLine
            case .twoLines:
                height = tokens.cellHeightTwoLines
            case .threeLines:
                height = tokens.cellHeightThreeLines
            }
            return configuration.label
                .contentShape(Rectangle())
                .frame(minHeight: height)
                .listRowInsets(EdgeInsets())
                .padding(.leading, tokens.horizontalCellPadding)
                .padding(.trailing, tokens.horizontalCellPadding)
                .background(configuration.isPressed ? Color(tokens.highlightedBackgroundColor) : Color(tokens.backgroundColor))
        }
    }

    /// View for List Header (availble for iOS 14.0+)
    struct Header: View {
        let title: String
        var tokens: MSFListTokens

        init(title: String, tokens: MSFListTokens) {
            self.title = title
            self.tokens = tokens
        }

        var body: some View {
            HStack(spacing: 0) {
                Text(title)
                    .font(Font(tokens.subtitleFont))
                    .foregroundColor(Color(tokens.subtitleColor))
                    .listRowInsets(EdgeInsets())
                    .padding(.top, tokens.horizontalCellPadding / 2)
                    .padding(.leading, tokens.horizontalCellPadding)
                    .padding(.trailing, tokens.horizontalCellPadding)
                    .padding(.bottom, tokens.horizontalCellPadding / 2)
                Spacer()
            }
            .background(Color(tokens.backgroundColor))
        }
    }
}

@objc open class MSFList: NSObject, FluentUIWindowProvider {

    @objc public init(sections: [MSFListSectionState],
                      iconStyle: MSFListIconStyle,
                      theme: FluentUIStyle? = nil) {
        listView = MSFListView(sections: sections,
                               iconStyle: iconStyle)
        hostingController = UIHostingController(rootView: theme != nil ? AnyView(listView.usingTheme(theme!)) : AnyView(listView))

        super.init()

        listView.tokens.windowProvider = self
        view.backgroundColor = UIColor.clear
    }

    @objc public convenience init(sections: [MSFListSectionState],
                                  iconStyle: MSFListIconStyle) {
        self.init(sections: sections,
                  iconStyle: iconStyle,
                  theme: nil)
    }

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc open var state: MSFListState {
        return listView.state
    }

    public var window: UIWindow? {
        return self.view.window
    }

    private var hostingController: UIHostingController<AnyView>!

    private var listView: MSFListView!
}
