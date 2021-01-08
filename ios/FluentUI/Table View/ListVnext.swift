//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Pre-defined styles of icons
@objc(MSFListIconVnextStyle)
public enum MSFListIconVnextStyle: Int, CaseIterable {
    case none
    case iconOnly
    case large
}

/// Pre-defined accessory types
@objc(MSFListAccessoryType)
public enum MSFListAccessoryType: Int, CaseIterable {
    case none
    case disclosure
    case detailButton
    case checkmark

    var icon: UIImage? {
        let icon: UIImage?
        switch self {
        case .none:
            icon = nil
        case .disclosure:
            icon = UIImage.staticImageNamed("iOS-chevron-right-20x20")
        case .detailButton:
            icon = UIImage.staticImageNamed("more-24x24")
        case .checkmark:
            icon = UIImage.staticImageNamed("checkmark-24x24")
        }
        return icon
    }
}

/// Properties that make up cell content
@objc(MSFListVnextCellData)
public class MSFListVnextCellData: NSObject, ObservableObject, Identifiable {
    public var id = UUID()
    @objc @Published public var leadingView: UIView?
    @objc @Published public var title: String = ""
    @objc @Published public var subtitle: String?
    @objc @Published public var accessoryType: MSFListAccessoryType = .none
    @objc @Published public var titleLineLimit: Int = 1
    @objc @Published public var subtitleLineLimit: Int = 1
    @objc public var onTapAction: (() -> Void)?
}

/// Properties that make up section content
@objc(MSFListVnextSectionData)
public class MSFListVnextSectionData: NSObject, ObservableObject, Identifiable {
    public var id = UUID()
    @objc @Published public var cells: [MSFListVnextCellData] = []
    @objc @Published public var title: String?
    @objc @Published public var hasBorder: Bool = false
    @objc @Published public var layoutType: MSFListCellVnextLayoutType = .oneLine
}

/// Properties that make up list content
@objc(MSFListVnextState)
public class MSFListVnextState: NSObject, ObservableObject {
    @objc @Published public var sections: [MSFListVnextSectionData] = []
}

@objc(MSFListCellVnextHeight)
/// Pre-defined layout heights of cells
public enum MSFListCellVnextLayoutType: Int, CaseIterable {
    case oneLine
    case twoLines
    case threeLines
}

public class MSFListTokens: ObservableObject {
    @Published public var backgroundColor: UIColor!
    @Published public var borderColor: UIColor!
    @Published public var disclosureIconForegroundColor: UIColor!
    @Published public var iconColor: UIColor!
    @Published public var leadingTextColor: UIColor!
    @Published public var subtitleColor: UIColor!
    @Published public var trailingItemForegroundColor: UIColor!

    @Published public var highlightedBackgroundColor: UIColor!

    @Published public var borderSize: CGFloat!
    @Published public var cellHeightOneLine: CGFloat!
    @Published public var cellHeightTwoLines: CGFloat!
    @Published public var cellHeightThreeLines: CGFloat!
    @Published public var disclosureInterspace: CGFloat!
    @Published public var disclosureSize: CGFloat!
    @Published public var horizontalCellPadding: CGFloat!
    @Published public var iconInterspace: CGFloat!
    @Published public var iconSize: CGFloat!
    @Published public var subtitleFont: UIFont!
    @Published public var textFont: UIFont!

    var iconStyle: MSFListIconVnextStyle!

    public init(iconStyle: MSFListIconVnextStyle) {
        self.iconStyle = iconStyle
        self.themeAware = true

        didChangeAppearanceProxy()
    }

    @objc open func didChangeAppearanceProxy() {
        let appearanceProxy: ApperanceProxyType

        if iconStyle == MSFListIconVnextStyle.iconOnly {
            appearanceProxy = StylesheetManager.S.IconOnlyListTokens
        } else {
            appearanceProxy = StylesheetManager.S.MSFListTokens
        }

        backgroundColor = appearanceProxy.backgroundColor.rest
        borderColor = appearanceProxy.borderColor
        disclosureIconForegroundColor = appearanceProxy.disclosureIconForegroundColor
        iconColor = appearanceProxy.iconColor
        leadingTextColor = appearanceProxy.labelColor
        subtitleColor = appearanceProxy.sublabelColor
        trailingItemForegroundColor = appearanceProxy.trailingItemForegroundColor

        highlightedBackgroundColor = appearanceProxy.backgroundColor.pressed

        borderSize = appearanceProxy.borderSize
        cellHeightOneLine = appearanceProxy.cellHeight.oneLine
        cellHeightTwoLines = appearanceProxy.cellHeight.twoLines
        cellHeightThreeLines = appearanceProxy.cellHeight.threeLines
        disclosureInterspace = appearanceProxy.disclosureInterspace
        disclosureSize = appearanceProxy.disclosureSize
        horizontalCellPadding = appearanceProxy.horizontalCellPadding
        iconInterspace = appearanceProxy.iconInterspace
        iconSize = iconStyle == .large ? appearanceProxy.iconSize.large : appearanceProxy.iconSize.default
        subtitleFont = appearanceProxy.sublabelFont
        textFont = appearanceProxy.labelFont
    }
}

public struct MSFListView: View {
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
                    MSFListCellView(cell: cell, layoutType: section.layoutType, tokens: tokens)
                        .border(section.hasBorder ? Color(tokens.borderColor) : Color.clear, width: section.hasBorder ? tokens.borderSize : 0)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .environment(\.defaultMinListRowHeight, 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension MSFListView {
    /// View for List Cells
    struct MSFListCellView: View {
        var cell: MSFListVnextCellData
        var layoutType: MSFListCellVnextLayoutType
        var tokens: MSFListTokens

        init(cell: MSFListVnextCellData, layoutType: MSFListCellVnextLayoutType, tokens: MSFListTokens) {
            self.cell = cell
            self.layoutType = layoutType
            self.tokens = tokens
        }

        var body: some View {
            Button(action: cell.onTapAction ?? {}, label: {
                HStack(spacing: 0) {
                    if let leadingView = cell.leadingView {
                        UIViewWrapper(leadingView)
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
            .buttonStyle(ListCellButtonStyle(tokens: tokens, layoutType: layoutType))
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

@objc(MSFListVnext)
open class MSFListVnext: NSObject {

    private var hostingController: UIHostingController<MSFListView>

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc open var state: MSFListVnextState {
        return hostingController.rootView.state
    }

    @objc public init(sections: [MSFListVnextSectionData],
                      iconStyle: MSFListIconVnextStyle) {
        self.hostingController = UIHostingController(rootView: MSFListView(sections: sections, iconStyle: iconStyle))
        super.init()
    }
}
