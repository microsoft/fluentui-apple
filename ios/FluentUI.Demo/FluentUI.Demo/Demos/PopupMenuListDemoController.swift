//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class PopupMenuListDemoController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()

		var list: MSFList
		var listCell: MSFListCellState
		var listSection: MSFListSectionState = MSFListSectionState()

		var listData: [MSFListSectionState] = []
		listSection.title = "Canada"
		listSection.cells = []
		var popupMenuItems = [
			PopupMenuItem(imageName: "Montreal", generateSelectedImage: false, title: "Montréal", subtitle: "Québec"),
			PopupMenuItem(imageName: "Toronto", generateSelectedImage: false, title: "Toronto", subtitle: "Ontario"),
			PopupMenuItem(imageName: "Vancouver", generateSelectedImage: false, title: "Vancouver", subtitle: "British Columbia")
		]

		for item in popupMenuItems {
			listCell = PopupMenuItemCellState()
			let avatar = createAvatarView(size: .medium,
										  name: item.title,
										  image: item.image,
										style: .default)
			listCell.title = avatar.state.primaryText ?? ""
			listCell.subtitle = item.subtitle ?? ""
			listCell.leadingUIView = avatar.view
			listSection.cells.append(listCell)
		}
		listData.append(listSection)

		listSection = MSFListSectionState()
		listSection.title = "United States"
		listSection.cells = []
		popupMenuItems = [
			PopupMenuItem(imageName: "Las Vegas", generateSelectedImage: false, title: "Las Vegas", subtitle: "Nevada"),
			PopupMenuItem(imageName: "Phoenix", generateSelectedImage: false, title: "Phoenix", subtitle: "Arizona"),
			PopupMenuItem(imageName: "San Francisco", generateSelectedImage: false, title: "San Francisco", subtitle: "California"),
			PopupMenuItem(imageName: "Seattle", generateSelectedImage: false, title: "Seattle", subtitle: "Washington")
		]

		for item in popupMenuItems {
			listCell = PopupMenuItemCellState()
			let avatar = createAvatarView(size: .medium,
										  name: item.title,
										  image: item.image,
										style: .default)
			listCell.title = avatar.state.primaryText ?? ""
			listCell.subtitle = item.subtitle ?? ""
			listCell.leadingUIView = avatar.view
			listSection.cells.append(listCell)
		}
		listData.append(listSection)

		list = MSFList(sections: listData)

		let listView = list.view
		listView.translatesAutoresizingMaskIntoConstraints = false

		let demoControllerView: UIView = self.view
		demoControllerView.addSubview(listView)

		NSLayoutConstraint.activate([demoControllerView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: listView.topAnchor),
									 demoControllerView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: listView.bottomAnchor),
									 demoControllerView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: listView.leadingAnchor),
									 demoControllerView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: listView.trailingAnchor)])
	}

	private func createAvatarView(size: MSFAvatarSize, name: String? = nil, image: UIImage? = nil, style: MSFAvatarStyle) -> MSFAvatar {
		let avatarView = MSFAvatar(style: style,
										size: size)
		avatarView.state.primaryText = name
		avatarView.state.image = image

		return avatarView
	}
}
