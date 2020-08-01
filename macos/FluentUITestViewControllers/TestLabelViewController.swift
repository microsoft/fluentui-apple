//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import FluentUI


class TestLabelViewController: NSViewController {

	override func loadView() {


		let labels = TextStyle.allCases.map {textStyle -> NSTextField in
			return Label(withString: string(ForTextStyle: textStyle), forTextStyle: textStyle)
		}
		
		let buttons = TextStyle.allCases.map {textStyle -> Button in
			return Button(title: string(ForTextStyle: textStyle), textStyle: textStyle, style: .primaryFilled)
		}
		
		let links = TextStyle.allCases.map {textStyle -> Link in
			return Link(title: string(ForTextStyle: textStyle), textStyle: textStyle)
		}
	

		let gridView = NSGridView(frame: .zero)
		gridView.rowSpacing = gridViewRowSpacing
		gridView.columnSpacing = gridViewColumnSpacing
		gridView.setContentHuggingPriority(.defaultHigh, for: .vertical)

		gridView.addColumn(with: labels)
		gridView.addColumn(with: buttons)
		gridView.addColumn(with: links)

		let containerView = NSStackView()
		containerView.orientation = .vertical
		containerView.translatesAutoresizingMaskIntoConstraints = false
		containerView.edgeInsets = NSEdgeInsets(
			top: containerViewEdgeInsets,
			left: containerViewEdgeInsets,
			bottom: containerViewEdgeInsets,
			right: containerViewEdgeInsets
		)

		containerView.addView(gridView, in: .top)

		view = containerView
	}
	
	func string(ForTextStyle textStyle: TextStyle) -> String {
		switch textStyle {

		case .largeTitle:
			return "Large Title"
		case .title1:
			return "Title 1"
		case .title2:
			return "Title 2"
		case .title3:
			return "Title 3"
		case .headline:
			return "Headline"
		case .body:
			return "Body"
		case .callout:
			return "Callout"
		case .subheadline:
			return "Subheadline"
		case .footnote:
			return "Footnote"
		case .caption1:
			return "Caption 1"
		case .caption2:
			return "Caption 2"
		}
	}
}

// MARK: - Constants

fileprivate let gridViewRowSpacing: CGFloat = 20

fileprivate let gridViewColumnSpacing: CGFloat = 20

fileprivate let containerViewEdgeInsets: CGFloat = 20
