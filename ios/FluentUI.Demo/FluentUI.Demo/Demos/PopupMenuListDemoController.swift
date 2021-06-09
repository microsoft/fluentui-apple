//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class PopupMenuListDemoController: DemoController {

	private var cells: [MSFPopupMenuItemCell] = []

	override func viewDidLoad() {
		super.viewDidLoad()

		let popupMenuItems = [
			PopupMenuItem(imageName: "Montreal", generateSelectedImage: false, title: "Montréal", subtitle: "Québec"),
			PopupMenuItem(imageName: "Toronto", generateSelectedImage: false, title: "Toronto", subtitle: "Ontario"),
			PopupMenuItem(imageName: "Vancouver", generateSelectedImage: false, title: "Vancouver", subtitle: "British Columbia")
		]

		for index in 0..<popupMenuItems.count {

			let itemCell = MSFPopupMenuItemCell()
			let itemState = itemCell.state
			itemState.title = popupMenuItems[index].title
			itemState.subtitle = popupMenuItems[index].subtitle ?? ""
			let addAccountImageView = UIImageView(image: popupMenuItems[index].image)
			itemState.leadingUIView = addAccountImageView
			cells.append(itemCell)
			addRow(items: [itemCell.view])

			NSLayoutConstraint.activate([itemCell.view.safeAreaLayoutGuide.widthAnchor.constraint(equalTo: container.widthAnchor)])
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		// set selection
		cells[0].state.isSelected = true
		// disable selection
		cells[1].state.isDisabled = true
	}
}
