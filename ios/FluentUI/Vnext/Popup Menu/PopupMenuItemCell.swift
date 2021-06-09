//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

// MARK: - State

public class PopupMenuItemCellState: MSFListCellState {

	// Set/Unset selection for item cell
	@objc @Published public var isSelected: Bool = false {
		didSet {
			if isSelected {
				leadingUIView?.tintColor = cellTokens.selectionColor
				tokens.labelColor = cellTokens.selectionColor
				tokens.sublabelColor = cellTokens.selectionColor
				tokens.trailingItemForegroundColor = cellTokens.selectionColor
				accessoryType = .checkmark
			} else {
				leadingUIView?.tintColor = nil
				tokens.labelColor = cellTokens.labelColor
				tokens.sublabelColor = cellTokens.sublabelColor
				tokens.trailingItemForegroundColor = cellTokens.trailingItemForegroundColor
				accessoryType = .none
			}
		}
	}
	
	// Disable selection for cell
	@objc @Published public var isDisabled: Bool = false {
		didSet {
			if isDisabled {
				leadingUIView?.tintColor = cellTokens.disabledColor
				tokens.labelColor = cellTokens.disabledColor
				tokens.sublabelColor = cellTokens.disabledColor
				self.action = onTapAction
				onTapAction = {}
			} else {
				leadingUIView?.tintColor = nil
				tokens.labelColor = cellTokens.labelColor
				tokens.sublabelColor = cellTokens.sublabelColor

				// restore action
				if self.action != nil {
					self.onTapAction = self.action
				}
			}
		}
	}

	var cellTokens: MSFPopupMenuItemCellTokens = MSFPopupMenuItemCellTokens()

	private var action: (() -> Void)?
}

// MARK: - View

public struct PopupMenuItemCell: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var state: PopupMenuItemCellState
	@ObservedObject var tokens: MSFCellBaseTokens

	public init(state: PopupMenuItemCellState) {
		self.state = state
		self.tokens = state.tokens
    }

	public var body: some View {
		MSFListCellView(state: state)
			.designTokens(tokens,
						  from: theme,
						  with: windowProvider)
	}
}

// MARK: - View + UiKit

@objc open class MSFPopupMenuItemCell: NSObject, FluentUIWindowProvider {
    @objc public init(theme: FluentUIStyle? = nil) {
        super.init()

		menuItemCell = PopupMenuItemCell(state: PopupMenuItemCellState())
        hostingController = UIHostingController(rootView: AnyView(menuItemCell
                                                                    .windowProvider(self)
                                                                    .modifyIf(theme != nil, { personaView in
                                                                        personaView.customTheme(theme!)
                                                                    })))
        view.backgroundColor = UIColor.clear
    }

    @objc public convenience override init() {
        self.init(theme: nil)
    }

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc open var state: PopupMenuItemCellState {
        return menuItemCell.state
    }

    @objc var window: UIWindow? {
        return self.view.window
    }

    private var hostingController: UIHostingController<AnyView>!

    private var menuItemCell: PopupMenuItemCell!
}
