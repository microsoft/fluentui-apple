//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Properties that make up cell content
@objc public class MSFListVnextCellData: NSObject, ObservableObject, Identifiable {
    public var id = UUID()
    @objc @Published public var leadingView: UIView?
    @objc @Published public var title: String = ""
    @objc @Published public var subtitle: String?
    @objc @Published public var accessoryType: MSFListAccessoryType = .none
    @objc @Published public var titleLineLimit: Int = 1
    @objc @Published public var subtitleLineLimit: Int = 1
    @objc @Published public var layoutType: MSFListCellVnextLayoutType = .oneLine
    @objc public var onTapAction: (() -> Void)?
}

/// Properties that make up section content
@objc public class MSFListVnextSectionData: NSObject, ObservableObject, Identifiable {
    public var id = UUID()
    @objc @Published public var cells: [MSFListVnextCellData] = []
    @objc @Published public var title: String?
    @objc @Published public var hasBorder: Bool = false
}

/// Properties that make up list content
@objc public class MSFListVnextState: NSObject, ObservableObject {
    @objc @Published public var sections: [MSFListVnextSectionData] = []
}

/// Pre-defined layout heights of cells
@objc public enum MSFListCellVnextLayoutType: Int, CaseIterable {
    case oneLine
    case twoLines
    case threeLines
}

public struct MSFListView: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @ObservedObject var state: MSFListVnextState
    @ObservedObject var tokens: MSFListTokens

    public init(sections: [MSFListVnextSectionData],
                iconStyle: MSFListIconVnextStyle) {
        self.state = MSFListVnextState()
        self.tokens = MSFListTokens(iconStyle: iconStyle)
        self.state.sections = sections
    }

    public var body: some View {
        let sections = state.sections
        List {
            ForEach(sections, id: \.self) { section in
                if let sectionTitle = section.title {
                    if #available(iOS 14.0, *) {
                        Section(header: Header(title: sectionTitle, tokens: tokens)) {}
                            .textCase(.none)
                            .listRowInsets(EdgeInsets())
                            .padding(.top, tokens.horizontalCellPadding / 2)
                            .padding(.leading, tokens.horizontalCellPadding)
                            .padding(.trailing, tokens.horizontalCellPadding)
                            .background(Color(tokens.backgroundColor))
                    } else {
                        Text(sectionTitle)
                            .listRowInsets(EdgeInsets(top: tokens.horizontalCellPadding / 2,
                                                      leading: tokens.horizontalCellPadding,
                                                      bottom: tokens.horizontalCellPadding / 2,
                                                      trailing: tokens.horizontalCellPadding))
                            .font(Font(tokens.subtitleFont))
                            .foregroundColor(Color(tokens.subtitleColor))
                    }
                }

                ForEach(section.cells, id: \.self) { cell in
                    MSFListCellView(cell: cell,
                                    tokens: tokens)
                        .border(section.hasBorder ? Color(tokens.borderColor) : Color.clear, width: section.hasBorder ? tokens.borderSize : 0)
                        .frame(maxWidth: .infinity)
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
        var cell: MSFListVnextCellData
        @ObservedObject var tokens: MSFListTokens

        init(cell: MSFListVnextCellData, tokens: MSFListTokens) {
            self.cell = cell
            self.tokens = tokens
        }

        var body: some View {
            Button(action: cell.onTapAction ?? {}, label: {
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
        }
    }

    struct ListCellButtonStyle: ButtonStyle {
        let tokens: MSFListTokens
        let layoutType: MSFListCellVnextLayoutType

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
            GeometryReader { _ in
                HStack(spacing: 0) {
                    Text(title)
                        .font(Font(tokens.subtitleFont))
                        .foregroundColor(Color(tokens.subtitleColor))
                    Spacer()
                }
            }
        }
    }
}

@objc open class MSFListVnext: NSObject, FluentUIWindowProvider {

    @objc public init(sections: [MSFListVnextSectionData],
                      iconStyle: MSFListIconVnextStyle,
                      theme: FluentUIStyle? = nil) {
        listView = MSFListView(sections: sections,
                               iconStyle: iconStyle)
        hostingController = UIHostingController(rootView: theme != nil ? AnyView(listView.usingTheme(theme!)) : AnyView(listView))

        super.init()

        listView.tokens.windowProvider = self
        view.backgroundColor = UIColor.clear
    }

    @objc public convenience init(sections: [MSFListVnextSectionData],
                                  iconStyle: MSFListIconVnextStyle) {
        self.init(sections: sections,
                  iconStyle: iconStyle,
                  theme: nil)
    }

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc open var state: MSFListVnextState {
        return listView.state
    }

    public var window: UIWindow? {
        return self.view.window
    }

    private var hostingController: UIHostingController<AnyView>!

    private var listView: MSFListView!
}
