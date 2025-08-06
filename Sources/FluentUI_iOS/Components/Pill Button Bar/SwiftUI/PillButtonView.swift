//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import SwiftUI

/// A `PillButtonView` is a button in the shape of a pill.
public struct PillButtonView: View, TokenizedControlView {
    public typealias TokenSetKeyType = PillButtonTokenSet.Tokens
    @ObservedObject public var tokenSet: PillButtonTokenSet

    /// Initializes a `PillButtonView`.
    ///
    /// - Parameters:
    ///   - style: The style of the pill button.
    ///   - viewModel: The view model used to create the pill button.
    ///   - action: The action performed when the pill button is tapped.
    public init(style: PillButtonStyle,
                viewModel: PillButtonViewModel,
                action: (() -> Void)?) {
        self.tokenSet = PillButtonTokenSet(style: { style })
        self.action = action
        self.viewModel = viewModel
        self.isSelected = false
        self.title = viewModel.title
        self.accessibilityLabelWithUnreadDot = String(format: "Accessibility.TabBarItemView.UnreadFormat".localized, title)
    }
 
    public var body: some View {
        tokenSet.update(fluentTheme)

        return SwiftUI.Button {
            action?()

            if viewModel.isUnread {
                viewModel.isUnread = false
            }
        } label: {
            Text(title)
        }
        .buttonStyle(PillButtonViewStyle(isSelected: isSelected,
                                         isUnread: viewModel.isUnread,
                                         leadingImage: viewModel.leadingImage,
                                         tokenSet: tokenSet))
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityLabel(viewModel.isUnread ? accessibilityLabelWithUnreadDot : title)
        .showsLargeContentViewer(text: title)
    }

    @ObservedObject private var viewModel: PillButtonViewModel
    @Environment(\.fluentTheme) private var fluentTheme: FluentTheme

    private let action: (() -> Void)?
    private let isSelected: Bool
    private let title: String
    private let accessibilityLabelWithUnreadDot: String
}
