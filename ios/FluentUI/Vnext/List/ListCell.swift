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

/// Pre-defined layout heights of cells
@objc public enum MSFListCellLayoutType: Int, CaseIterable {
    case oneLine
    case twoLines
    case threeLines
}

/// View for List Cells
struct MSFListCellView: View {
    @ObservedObject var state: MSFListCellState
    @ObservedObject var tokens: MSFListTokens
    var hasDividers: Bool

    init(state: MSFListCellState, tokens: MSFListTokens, hasDividers: Bool = false) {
        self.state = state
        self.tokens = tokens
        self.hasDividers = hasDividers
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
                if let leadingView = state.leadingView {
                    UIViewAdapter(leadingView)
                        .frame(width: tokens.iconSize, height: tokens.iconSize)
                        .padding(.trailing, tokens.iconInterspace)
                }
                VStack(alignment: .leading) {
                    if let title = state.title {
                        Text(title)
                            .font(Font(tokens.textFont))
                            .foregroundColor(Color(tokens.leadingTextColor))
                            .lineLimit(state.titleLineLimit)
                    }
                    if let subtitle = state.subtitle, !subtitle.isEmpty {
                            Text(subtitle)
                                .font(Font(tokens.subtitleFont))
                                .foregroundColor(Color(tokens.subtitleColor))
                                .lineLimit(state.titleLineLimit)
                    }
                }
                Spacer()
                HStack {
                    if let accessoryType = state.accessoryType, accessoryType != .none, let accessoryIcon = accessoryType.icon {
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
        .buttonStyle(ListCellButtonStyle(tokens: tokens, layoutType: state.layoutType))
        if hasDividers {
            Divider()
                .padding(.leading, state.leadingView != nil ? (tokens.horizontalCellPadding + tokens.iconSize + tokens.iconInterspace) : tokens.horizontalCellPadding)
        }
        if let children = state.children, state.isExpanded == true {
            ForEach(children, id: \.self) { child in
                MSFListCellView(state: child,
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
