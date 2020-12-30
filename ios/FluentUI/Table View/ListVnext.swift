//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

///Properties that make up cell content
@objc(MSFListVnextCellData)
public class MSFListVnextCellData: NSObject, ObservableObject, Identifiable {
    public var id = UUID()
    @objc @Published public var leadingIcon: UIImage?
    @objc @Published public var title: String = ""
    @objc @Published public var subtitle: String?
    @objc @Published public var trailingIcon: MSFListAccessoryType = .none
    @objc @Published public var titleLineLimit: Int = 1
    @objc @Published public var subtitleLineLimit: Int = 1
    @objc public var onTapAction: (() -> Void)?
}

///Properties that make up list content
@objc(MSFListVnextState)
public class MSFListVnextState: NSObject, ObservableObject {
    @objc @Published public var sectionTitle: String?
    @objc @Published public var hasBorder: Bool = false
}

@objc(MSFListIconVnextStyle)
/// Pre-defined styles of icons
public enum MSFListIconVnextStyle: Int, CaseIterable {
    case none
    case iconOnly
    case large
}

@objc(MSFListAccessoryType)
/// Pre-defined types of icons
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

@objc(MSFListCellVnextHeight)
/// Pre-defined layout heights of cells
public enum MSFListCellVnextLayoutType: Int, CaseIterable {
    case oneLine
    case twoLines
    case threeLines

    var height: CGFloat {
        switch self {
        case .oneLine:
            return 48
        case .twoLines:
            return 64
        case .threeLines:
            return 84
        }
    }
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
    @Published public var disclosureInterspace: CGFloat!
    @Published public var disclosureSize: CGFloat!
    @Published public var horizontalCellPadding: CGFloat!
    @Published public var iconInterspace: CGFloat!
    @Published public var iconSize: CGFloat!
//    @Published public var largeIconSize: CGFloat!
    @Published public var subtitleFont: UIFont!
    @Published public var textFont: UIFont!

    var iconStyle: MSFListIconVnextStyle!
    var layoutType: MSFListCellVnextLayoutType!

    public init(layoutType: MSFListCellVnextLayoutType, iconStyle: MSFListIconVnextStyle) {
        self.layoutType = layoutType
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
        disclosureInterspace = appearanceProxy.disclosureInterspace
        disclosureSize = appearanceProxy.disclosureSize
        horizontalCellPadding = appearanceProxy.horizontalCellPadding
        iconInterspace = appearanceProxy.iconInterspace
        iconSize = iconStyle == MSFListIconVnextStyle.large ? appearanceProxy.iconSize.large : appearanceProxy.iconSize.default
        subtitleFont = appearanceProxy.sublabelFont
        textFont = appearanceProxy.labelFont
    }
}

public struct MSFListView: View {
    @ObservedObject var state: MSFListVnextState
    @ObservedObject var tokens: MSFListTokens
    var cells: [MSFListVnextCellData]

    public init(cells: [MSFListVnextCellData],
                layoutType: MSFListCellVnextLayoutType,
                iconStyle: MSFListIconVnextStyle) {
        self.state = MSFListVnextState()
        self.tokens = MSFListTokens(layoutType: layoutType, iconStyle: iconStyle)
        self.cells = cells
    }

    public var body: some View {
        List {
            if state.sectionTitle != nil {
                if #available(iOS 14.0, *) {
                    Section(header: Header(title: state.sectionTitle ?? "", tokens: tokens)) {}
                        .textCase(.none)
                        .listRowInsets(EdgeInsets())
                        .padding(.leading, tokens.horizontalCellPadding)
                        .padding(.trailing, tokens.horizontalCellPadding)
                        .background(Color(tokens.backgroundColor))
                } else {
                    Text(state.sectionTitle ?? "")
                        .listRowInsets(EdgeInsets(
                                top: 0,
                                leading: tokens.horizontalCellPadding,
                                bottom: tokens.horizontalCellPadding / 2,
                                trailing: tokens.horizontalCellPadding))
                        .font(Font(tokens.subtitleFont))
                        .foregroundColor(Color(tokens.subtitleColor))
                }
            }
            ForEach(cells, id: \.self) { item in
                MSFListCellView(cell: item, tokens: tokens)
                    .border(state.hasBorder ? Color(tokens.borderColor) : Color.clear, width: state.hasBorder ? tokens.borderSize : 0)
                    .frame(maxWidth: .infinity)
            }
        }
        .environment(\.defaultMinListRowHeight, 0)
        .frame(width: UIScreen.main.bounds.width, height: 300)
    }
}

extension MSFListView {
    /// View for List Cells
    struct MSFListCellView: View {
        var cell: MSFListVnextCellData
        var tokens: MSFListTokens
        @State var isTapped: Bool = false

        init(cell: MSFListVnextCellData, tokens: MSFListTokens) {
            self.cell = cell
            self.tokens = tokens
        }

        var body: some View {
            Button(action: cell.onTapAction ?? {}, label: {
                HStack(spacing: 0) {
                    if let leadingIcon = cell.leadingIcon {
                        Image(uiImage: leadingIcon)
                            .resizable()
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
                        if let subtitle = cell.subtitle {
                            if subtitle != "" {
                                Text(subtitle)
                                    .font(Font(tokens.subtitleFont))
                                    .foregroundColor(Color(tokens.subtitleColor))
                                    .lineLimit(cell.titleLineLimit)
                            }
                        }
                    }
                    Spacer()
                    HStack {
                        if let trailingIcon = cell.trailingIcon {
                            if trailingIcon != .none {
                                let isDisclosure = trailingIcon == .disclosure
                                let disclosureSize = tokens.disclosureSize
                                let iconSize = tokens.iconSize
                                Image(uiImage: trailingIcon.icon!)
                                    .resizable()
                                    .foregroundColor(Color(isDisclosure ? tokens.disclosureIconForegroundColor : tokens.trailingItemForegroundColor))
                                    .frame(width: isDisclosure ? disclosureSize : iconSize,
                                           height: isDisclosure ? disclosureSize : iconSize)
                                    .padding(.leading, isDisclosure ? tokens.disclosureInterspace : tokens.iconInterspace)
                            }
                        }
                    }
                }
            })
            .buttonStyle(ListCellButton(tokens: tokens))
        }
    }

    struct ListCellButton: ButtonStyle {
        let tokens: MSFListTokens
        func makeBody(configuration: Self.Configuration) -> some View {
            return configuration.label
                .contentShape(Rectangle())
                .frame(minHeight: tokens.layoutType.height)
                .listRowInsets(EdgeInsets())
                .padding(.leading, tokens.horizontalCellPadding)
                .padding(.trailing, tokens.horizontalCellPadding)
                .background(configuration.isPressed ? Color(tokens.highlightedBackgroundColor) : Color.clear)
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

    @objc open var cells: [MSFListVnextCellData] {
        return hostingController.rootView.cells
    }

    @objc public init(cells: [MSFListVnextCellData],
                      layoutType: MSFListCellVnextLayoutType,
                      iconStyle: MSFListIconVnextStyle) {
        self.hostingController = UIHostingController(rootView: MSFListView(cells: cells, layoutType: layoutType, iconStyle: iconStyle))
        super.init()
    }
}
