//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

///Properties that make up cell content
@objc(MSFListVnextCell)
public class MSFListVnextCell: NSObject, ObservableObject, Identifiable {
    public var id = UUID()
    @objc @Published public var leadingView: UIImage?
    @objc @Published public var title: String = ""
    @objc @Published public var subtitle: String?
    @objc @Published public var lineLimit: Int = 1
}

///Properties that make up list content
@objc(MSFListVnextState)
public class MSFListVnextState: NSObject, ObservableObject {
    @objc @Published public var sectionTitle: String?
}

@objc(MSFListIconVnextStyle)
/// Pre-defined styles of icons
public enum MSFListIconVnextStyle: Int, CaseIterable {
    case none
    case iconOnly
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
    @Published public var largeIconSize: CGFloat!
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
        iconSize = appearanceProxy.iconSize.icon
        largeIconSize = appearanceProxy.iconSize.largeIcon
        subtitleFont = appearanceProxy.textFont.subLabel
        textFont = appearanceProxy.textFont.label
    }
}

public struct MSFListView: View {
    @ObservedObject var tokens: MSFListTokens
    var cells: [MSFListVnextCell]
    var state: MSFListVnextState

    public init(cells: [MSFListVnextCell],
                layoutType: MSFListCellVnextLayoutType,
                iconStyle: MSFListIconVnextStyle) {
        self.state = MSFListVnextState()
        self.tokens = MSFListTokens(layoutType: layoutType, iconStyle: iconStyle)
        self.cells = cells
    }

    public var body: some View {
        List {
            ForEach(cells) { item in
                MSFListCellView(cell: item, tokens: tokens)
            }
            .listRowInsets(EdgeInsets())
            .frame(minHeight: tokens.layoutType.height)
        }
        .frame(width: .infinity, height: .infinity)
        .environment(\.defaultMinListRowHeight, 0)
    }
}

/// View for List Cells
extension MSFListView {
    struct MSFListCellView: View {
        var cell: MSFListVnextCell
        var tokens: MSFListTokens

        init(cell: MSFListVnextCell, tokens: MSFListTokens) {
            self.cell = cell
            self.tokens = tokens
        }

        var body: some View {
            HStack {
                if let leadingView = cell.leadingView {
                    Image(uiImage: leadingView)
                        .resizable()
                        .frame(width: tokens.iconSize, height: tokens.iconSize)
                }
                VStack(alignment: .leading) {
                    if let title = cell.title {
                        Text(title)
                            .lineLimit(cell.lineLimit)
                            .font(Font(tokens.textFont))
                            .foregroundColor(Color(tokens.leadingTextColor))
                    }
                    if let subtitle = cell.subtitle {
                        if subtitle != "" {
                            Text(subtitle)
                                .lineLimit(cell.lineLimit)
                                .font(Font(tokens.subtitleFont))
                                .foregroundColor(Color(tokens.subtitleColor))
                        }
                    }
                }
                Spacer()
            }
            .padding(.leading, tokens.horizontalCellPadding)
            .padding(.trailing, tokens.horizontalCellPadding)
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

    @objc public init(cells: [MSFListVnextCell],
                      layoutType: MSFListCellVnextLayoutType,
                      iconStyle: MSFListIconVnextStyle) {
        self.hostingController = UIHostingController(rootView: MSFListView(cells: cells, layoutType: layoutType, iconStyle: iconStyle))
        super.init()
    }
}
