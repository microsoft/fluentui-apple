//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// `MSFListCellState` contains properties that make up a cell content.
///
/// `title` is the first line of text, subsequently followed by `subtitle` on the second line and `footnote` on the third line.
/// Set line limits for text using `titleLineLimit`, `subtitleLineLimit`, and `footnoteLineLimit`.
///
/// Any label`AccessoryView` property is a custom view at the leading/trailing end of a label, including the title, subtitle, or footnote.
/// Currently only supports square views (width & height must be the same).
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
    @objc @Published public var subtitle: String = ""
    @objc @Published public var footnote: String = ""
    @objc @Published public var titleLeadingAccessoryView: UIView?
    @objc @Published public var titleTrailingAccessoryView: UIView?
    @objc @Published public var subtitleLeadingAccessoryView: UIView?
    @objc @Published public var subtitleTrailingAccessoryView: UIView?
    @objc @Published public var footnoteLeadingAccessoryView: UIView?
    @objc @Published public var footnoteTrailingAccessoryView: UIView?
    @objc @Published public var trailingView: UIView?
    @objc @Published public var accessoryType: MSFListAccessoryType = .none
    @objc @Published public var titleLineLimit: Int = 0
    @objc @Published public var subtitleLineLimit: Int = 0
    @objc @Published public var footnoteLineLimit: Int = 0
    @objc @Published public var children: [MSFListCellState]?
    @objc @Published public var isExpanded: Bool = false
    @objc @Published public var layoutType: MSFListCellLayoutType = .automatic
    @objc @Published public var hasDivider: Bool = false
    @objc public var onTapAction: (() -> Void)?
}

/// Pre-defined layout heights of cells
@objc public enum MSFListCellLayoutType: Int, CaseIterable {
    case automatic
    case oneLine
    case twoLines
    case threeLines
}

/// View for List Cells
struct MSFListCellView: View {
    @ObservedObject var state: MSFListCellState
    @ObservedObject var tokens: MSFListCellTokens

    init(state: MSFListCellState, windowProvider: FluentUIWindowProvider?) {
        self.state = state
        self.tokens = MSFListCellTokens(cellLeadingViewSize: state.leadingViewSize)
        self.tokens.windowProvider = windowProvider
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
                let labelAccessoryInterspace = tokens.labelAccessoryInterspace
                let labelAccessorySize = tokens.labelAccessorySize

                if let leadingView = state.leadingView {
                    UIViewAdapter(leadingView)
                        .foregroundColor(Color(hasTitle ? tokens.backgroundColor : tokens.trailingItemForegroundColor))
                        .frame(width: tokens.leadingViewSize, height: tokens.leadingViewSize)
                        .padding(.trailing, tokens.iconInterspace)
                }

                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        if let titleLeadingAccessoryView = state.titleLeadingAccessoryView {
                            UIViewAdapter(titleLeadingAccessoryView)
                                .frame(width: labelAccessorySize, height: labelAccessorySize)
                                .padding(.trailing, labelAccessoryInterspace)
                        }
                        if hasTitle {
                            Text(state.title)
                                .font(Font(tokens.textFont))
                                .foregroundColor(Color(tokens.leadingTextColor))
                                .lineLimit(state.titleLineLimit == 0 ? nil : state.titleLineLimit)
                        }
                        if let titleTrailingAccessoryView = state.titleTrailingAccessoryView {
                            UIViewAdapter(titleTrailingAccessoryView)
                                .frame(width: labelAccessorySize, height: labelAccessorySize)
                                .padding(.leading, labelAccessoryInterspace)
                        }
                    }

                    HStack(spacing: 0) {
                        if let subtitleLeadingAccessoryView = state.subtitleLeadingAccessoryView {
                            UIViewAdapter(subtitleLeadingAccessoryView)
                                .frame(width: labelAccessorySize, height: labelAccessorySize)
                                .padding(.trailing, labelAccessoryInterspace)
                        }
                        if !state.subtitle.isEmpty {
                            Text(state.subtitle)
                                .font(Font(state.footnote.isEmpty ? tokens.footnoteFont : tokens.subtitleFont))
                                .foregroundColor(Color(tokens.sublabelColor))
                                .lineLimit(state.subtitleLineLimit == 0 ? nil : state.subtitleLineLimit)
                        }
                        if let subtitleTrailingAccessoryView = state.subtitleTrailingAccessoryView {
                            UIViewAdapter(subtitleTrailingAccessoryView)
                                .frame(width: labelAccessorySize, height: labelAccessorySize)
                                .padding(.leading, labelAccessoryInterspace)
                        }
                    }

                    HStack(spacing: 0) {
                        if let footnoteLeadingAccessoryView = state.footnoteLeadingAccessoryView {
                            UIViewAdapter(footnoteLeadingAccessoryView)
                                .frame(width: labelAccessorySize, height: labelAccessorySize)
                                .padding(.trailing, labelAccessoryInterspace)
                        }
                        if !state.footnote.isEmpty {
                            Text(state.footnote)
                                .font(Font(tokens.footnoteFont))
                                .foregroundColor(Color(tokens.sublabelColor))
                                .lineLimit(state.footnoteLineLimit == 0 ? nil : state.footnoteLineLimit)
                        }
                        if let footnoteTrailingAccessoryView = state.footnoteTrailingAccessoryView {
                            UIViewAdapter(footnoteTrailingAccessoryView)
                                .frame(width: labelAccessorySize, height: labelAccessorySize)
                                .padding(.leading, labelAccessoryInterspace)
                        }
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
        .buttonStyle(ListCellButtonStyle(tokens: tokens, state: state))

        if state.hasDivider {
            let padding = tokens.horizontalCellPadding + (state.leadingView != nil ? (tokens.leadingViewSize + tokens.iconInterspace) : 0)
            Divider()
                .overlay(Color(tokens.borderColor))
                .padding(.leading, padding)
        }

        if let children = state.children, state.isExpanded == true {
            ForEach(children, id: \.self) { child in
                MSFListCellView(state: child,
                                windowProvider: tokens.windowProvider)
                    .frame(maxWidth: .infinity)
                    .padding(.leading, (tokens.horizontalCellPadding + tokens.leadingViewSize))
            }
        }
    }
}

struct ListCellButtonStyle: ButtonStyle {
    let tokens: MSFListCellTokens
    let state: MSFListCellState

    func makeBody(configuration: Self.Configuration) -> some View {
        let height: CGFloat
        switch state.layoutType {
        case .automatic:
            height = !state.subtitle.isEmpty ? tokens.cellHeightTwoLines : tokens.cellHeightOneLine
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
