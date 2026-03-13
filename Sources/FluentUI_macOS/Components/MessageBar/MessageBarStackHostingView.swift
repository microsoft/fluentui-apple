//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import Combine
import SwiftUI

/// Objective-C-accessible holder for the data needed to configure a message bar row.
@objc(MSFMessageBarConfiguration)
public class MessageBarConfigurationObject: NSObject {
	@objc public var title: String = ""
	@objc public var message: String = ""
	@objc public var actionTitles: [String] = []
	@objc public var hasCloseButton: Bool = true
	@objc public var onClose: (() -> Void)?
	@objc public var onAction: ((Int) -> Void)?
}

/// AppKit wrapper that manages a vertical stack of `MessageBar` instances .
@objc(MSFMessageBarStack)
public final class MessageBarStackHostingView: ControlHostingView {

	@objc public init() {
		viewModel = MessageBarStackViewModel()
		super.init(AnyView(EmptyView()))
		hostingView.rootView = AnyView(MessageBarStack(viewModel: viewModel))
		wantsLayer = true
		clipsToBounds = true
	}

	@objc public override var intrinsicContentSize: CGSize {
		// Do not declare an intrinsic content size, or we will not be able to shrink
		// the parent view smaller than the untruncated message bar.
		return .zero
	}

	@MainActor required dynamic init?(coder aDecoder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}

	@MainActor required init(rootView: AnyView) {
		preconditionFailure("init(rootView:) has not been implemented")
	}

	public override func viewDidMoveToSuperview() {
		super.viewDidMoveToSuperview()
		if heightConstraint == nil, superview != nil {
			let constraint = heightAnchor.constraint(equalToConstant: 0)
			constraint.isActive = true
			heightConstraint = constraint
		}
	}

	@objc public func updateLayout() {
		let newHeight = viewModel.targetContentHeight
		heightConstraint?.constant = newHeight
		layoutSubtreeIfNeeded()
	}

	/// Registers a bar. The bar starts hidden; call `showBar(barID:)` to reveal it.
	@objc public func addBar(barID: Int, configuration: MessageBarConfigurationObject) {
		let actionButtonConfiguration: MessageBarConfiguration.ActionButtonConfiguration?
		if configuration.actionTitles.isEmpty {
			actionButtonConfiguration = nil
		} else {
			let callback: (UInt8) -> Void = { [weak configuration] index in
				configuration?.onAction?(Int(index))
			}
			switch configuration.actionTitles.count {
			case 1:
				actionButtonConfiguration = .init(actionButton1Title: configuration.actionTitles[0], callback: callback)
			case 2:
				actionButtonConfiguration = .init(actionButton1Title: configuration.actionTitles[0],
				                                  actionButton2Title: configuration.actionTitles[1],
				                                  callback: callback)
			default:
				actionButtonConfiguration = .init(actionButton1Title: configuration.actionTitles[0],
				                                  actionButton2Title: configuration.actionTitles[1],
				                                  actionButton3Title: configuration.actionTitles[2],
				                                  callback: callback)
			}
		}
		let msgBarConfig = MessageBarConfiguration(
			title: configuration.title,
			message: configuration.message,
			actionButtonConfiguration: actionButtonConfiguration,
			hasCloseButton: configuration.hasCloseButton,
			onCloseCallback: configuration.onClose ?? {}
		)
		viewModel.bars.append(MessageBarStackViewModel.BarItem(id: barID, configuration: msgBarConfig))
	}

	@objc public func showBar(barID: Int) {
		if let index = viewModel.bars.firstIndex(where: { $0.id == barID }) {
			viewModel.bars[index].isVisible = true
		}
	}

	@objc public func hideBar(barID: Int) {
		if let index = viewModel.bars.firstIndex(where: { $0.id == barID }) {
			viewModel.bars[index].isVisible = false
		}
	}

	/// Removes the bar from the stack.
	@objc public func removeBar(barID: Int) {
		viewModel.bars.removeAll { $0.id == barID }
	}

	private var heightConstraint: NSLayoutConstraint?
	private let viewModel: MessageBarStackViewModel
}
