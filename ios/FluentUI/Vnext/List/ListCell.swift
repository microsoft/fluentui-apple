//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// `MSFListCellState` contains properties that make up a cell content.
///
/// `title` is the first line of text, subsequently followed by `subtitle` on the second line.
/// Set line limits for text using `titleLineLimit` and `subtitleLineLimit`.
///
/// `leadingView` and `trailingView` allows any custom views. Currently only supports square views (width & height must be the same).
/// `leadingViewSize` can be specified using `MSFListCellLeadingViewSize`.
///
/// Set `accessoryType` using the variations specified in `MSFListAccessoryType`. This is displayed in the very trailing end of a cell.
///
/// `children`: define nested cells. `isExpanded` will determine if the children are initially expanded or collapsed.
///
/// `layoutType`:  override the default cell height.
///
/// `onTapAction`: perform an action on a cell tap.
///
@objc public class MSFListCellState: NSObject, ObservableObject, Identifiable {
    public var id = UUID()
    @objc @Published public var leadingView: UIView?
    @objc @Published public var leadingViewSize: MSFListCellLeadingViewSize = .medium
    @objc @Published public var title: String = ""
    @objc @Published public var subtitle: String?
    @objc @Published public var trailingView: UIView?
    @objc @Published public var accessoryType: MSFListAccessoryType = .none
    @objc @Published public var titleLineLimit: Int = 0
    @objc @Published public var subtitleLineLimit: Int = 0
    @objc @Published public var children: [MSFListCellState]?
    @objc @Published public var isExpanded: Bool = false
    @objc @Published public var layoutType: MSFListCellLayoutType = .oneLine
    @objc public var onTapAction: (() -> Void)?
}

/// Pre-defined layout heights of cells
@objc public enum MSFListCellLayoutType: Int, CaseIterable {
    case oneLine
    case twoLines
    case threeLines
}

/// View for List Cells
struct MSFListCellView: View {
    @ObservedObject var state: MSFListCellState
    @ObservedObject var tokens: MSFListCellTokens
    var hasDividers: Bool

    init(state: MSFListCellState, hasDividers: Bool = false, windowProvider: FluentUIWindowProvider?) {
        self.state = state
        self.hasDividers = hasDividers
        self.tokens = MSFListCellTokens(cellLeadingViewSize: state.leadingViewSize)
        if let windowProvider = windowProvider {
            self.tokens.windowProvider = windowProvider
        }
    }

    var body: some View {
        Button(action: state.onTapAction ?? {
            if state.children != nil {
                withAnimation {
                    state.isExpanded.toggle()
                }
            }
        }, label: {
            HStack(spacing: 0) {
                let hasTitle = !state.title.isEmpty
                if let leadingView = state.leadingView {
                    UIViewAdapter(leadingView)
                        .foregroundColor(Color(hasTitle ? tokens.backgroundColor : tokens.trailingItemForegroundColor))
                        .frame(width: tokens.leadingViewSize, height: tokens.leadingViewSize)
                        .padding(.trailing, tokens.iconInterspace)
                }
                VStack(alignment: .leading, spacing: 0) {
                    if hasTitle {
                        Text(state.title)
                            .font(Font(tokens.textFont))
                            .foregroundColor(Color(tokens.leadingTextColor))
                            .lineLimit(state.titleLineLimit == 0 ? nil : state.titleLineLimit)
                    }
                    if let subtitle = state.subtitle, !subtitle.isEmpty {
                        Text(subtitle)
                            .font(Font(tokens.subtitleFont))
                            .foregroundColor(Color(tokens.subtitleColor))
                            .lineLimit(state.subtitleLineLimit == 0 ? nil : state.subtitleLineLimit)
                    }
                }
                Spacer()
                if let trailingView = state.trailingView {
                    UIViewAdapter(trailingView)
                        .foregroundColor(Color(hasTitle ? tokens.backgroundColor : tokens.trailingItemForegroundColor))
                        .frame(width: tokens.trailingItemSize, height: tokens.trailingItemSize)
                        .fixedSize()
                }
                HStack(spacing: 0) {
                    if let accessoryType = state.accessoryType, accessoryType != .none, let accessoryIcon = accessoryType.icon {
                        let isDisclosure = accessoryType == .disclosure
                        let disclosureSize = tokens.disclosureSize
                        Image(uiImage: accessoryIcon)
                            .resizable()
                            .foregroundColor(Color(isDisclosure ? tokens.disclosureIconForegroundColor : tokens.trailingItemForegroundColor))
                            .frame(width: isDisclosure ? disclosureSize : tokens.trailingItemSize, height: isDisclosure ? disclosureSize : tokens.trailingItemSize)
                            .padding(.leading, isDisclosure ? tokens.disclosureInterspace : tokens.iconInterspace)
                    }
                }
            }
        })
        .buttonStyle(ListCellButtonStyle(tokens: tokens, layoutType: state.layoutType))
        if hasDividers {
            let padding = tokens.horizontalCellPadding + (state.leadingView != nil ? (tokens.leadingViewSize + tokens.iconInterspace) : 0)
            Divider()
                .padding(.leading, padding)
        }
        if let children = state.children, state.isExpanded == true {
            ForEach(children, id: \.self) { child in
                MSFListCellView(state: child,
                                hasDividers: hasDividers,
                                windowProvider: tokens.windowProvider)
                    .frame(maxWidth: .infinity)
                    .padding(.leading, (tokens.horizontalCellPadding + tokens.leadingViewSize))
            }
        }
    }
}

struct ListCellButtonStyle: ButtonStyle {
    let tokens: MSFListCellTokens
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
            .padding(EdgeInsets(top: tokens.horizontalCellPadding / 2,
                                leading: tokens.horizontalCellPadding,
                                bottom: tokens.horizontalCellPadding / 2,
                                trailing: tokens.horizontalCellPadding))
            .frame(minHeight: height)
            .background(configuration.isPressed ? Color(tokens.highlightedBackgroundColor) : Color(tokens.backgroundColor))
    }
}
