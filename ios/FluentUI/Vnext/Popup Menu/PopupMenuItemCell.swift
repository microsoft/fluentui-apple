//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

// MARK: - State

public class PopupMenuItemCellState: MSFListCellState {

	@objc @Published public var isSelected: Bool = false {
		didSet {
			if isSelected {
				leadingUIView?.tintColor = cellTokens.selectionColor
			} else {
				leadingUIView?.tintColor = nil
			}
		}
	}
	@objc @Published public var isDisabled: Bool = false {
		didSet {
			if isDisabled {
				leadingUIView?.tintColor = cellTokens.disabledColor
			} else {
				leadingUIView?.tintColor = nil
			}
		}
	}

	var cellTokens: MSFPopupMenuItemCellTokens = MSFPopupMenuItemCellTokens()
}

// MARK: - View

public struct PopupMenuItemCell: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var state: PopupMenuItemCellState

	public init(state: PopupMenuItemCellState) {
		self.state = state
    }

    public var body: some View {
        MSFListCellView(state: state)
			.designTokens(state.tokens,
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

#if DEBUG
struct ContentView_Previews: PreviewProvider {

	static var cellState: PopupMenuItemCellState {
		let cell = PopupMenuItemCellState()
		cell.title = "Open"
		cell.subtitle = "Open document"
		let addAccountImageView = UIImageView(image: UIImage(systemName: "arrow.up.message.fill"))
		cell.leadingUIView = addAccountImageView
		cell.isSelected = true
		return cell
	}

	static var previews: some View {
		List {
			PopupMenuItemCell(state: cellState)
		}
	}
}
#endif
