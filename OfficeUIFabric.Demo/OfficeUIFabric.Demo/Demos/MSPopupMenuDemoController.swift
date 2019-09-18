//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import OfficeUIFabric
import UIKit

class MSPopupMenuDemoController: DemoController {
    private enum CalendarLayout {
        case agenda
        case day
        case threeDay
        case week
        case month
    }

    private var calendarLayout: CalendarLayout = .agenda
    private var cityIndexPath: IndexPath? = IndexPath(item: 2, section: 1)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show", style: .plain, target: self, action: #selector(topBarButtonTapped))

        toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Show with selection", style: .plain, target: self, action: #selector(bottomBarButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Show with header", style: .plain, target: self, action: #selector(bottomBarButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ]

        container.addArrangedSubview(createButton(title: "Show with sections", action: #selector(showTopMenuWithSectionsButtonTapped)))
        container.addArrangedSubview(createButton(title: "Show with scrollable items and no icons", action: #selector(showTopMenuWithScrollableItemsButtonTapped)))
        container.addArrangedSubview(UIView())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isToolbarHidden = false
    }

    private func createAccessoryView(text: String) -> UIView {
        let accessoryView = MSBadgeView(dataSource: MSBadgeViewDataSource(text: text, style: .default, size: .small))
        accessoryView.isUserInteractionEnabled = false
        accessoryView.sizeToFit()
        return accessoryView
    }

    @objc private func topBarButtonTapped(sender: UIBarButtonItem) {
        let controller = MSPopupMenuController(barButtonItem: sender, presentationDirection: .down)

        controller.addItems([
            MSPopupMenuItem(image: UIImage(named: "mail-unread-25x25"), title: "Unread"),
            MSPopupMenuItem(image: UIImage(named: "flag-25x25"), title: "Flagged", accessoryView: createAccessoryView(text: "New")),
            MSPopupMenuItem(image: UIImage(named: "attach-25x25"), accessoryImage: UIImage(named: "gleam"), title: "Attachments")
        ])

        let originalTitle = sender.title
        sender.title = "Shown"
        controller.onDismiss = {
            sender.title = originalTitle
        }

        present(controller, animated: true)
    }

    @objc private func bottomBarButtonTapped(sender: UIBarButtonItem) {
        var origin: CGFloat = -1
        if let toolbar = navigationController?.toolbar {
            origin = toolbar.convert(toolbar.bounds.origin, to: nil).y
        }

        let controller = MSPopupMenuController(barButtonItem: sender, presentationOrigin: origin, presentationDirection: .up)

        if sender.title == "Show with header" {
            controller.headerItem = MSPopupMenuItem(title: "Calendar layout", subtitle: "Some options might not be available")
        }
        controller.addItems([
            MSPopupMenuItem(image: UIImage(named: "agenda-25x25"), title: "Agenda", isSelected: calendarLayout == .agenda, onSelected: { self.calendarLayout = .agenda }),
            MSPopupMenuItem(image: UIImage(named: "day-view-25x25"), title: "Day", isSelected: calendarLayout == .day, onSelected: { self.calendarLayout = .day }),
            MSPopupMenuItem(image: UIImage(named: "week-view-25x25"), title: "3-Day", isEnabled: false, isSelected: calendarLayout == .threeDay, onSelected: { self.calendarLayout = .threeDay }),
            MSPopupMenuItem(title: "Week (no icon)", isSelected: calendarLayout == .week, onSelected: { self.calendarLayout = .week }),
            MSPopupMenuItem(image: UIImage(named: "month-view-25x25"), title: "Month", isSelected: calendarLayout == .month, onSelected: { self.calendarLayout = .month })
        ])

        present(controller, animated: true)
    }

    @objc private func showTopMenuWithSectionsButtonTapped(sender: UIButton) {
        let controller = MSPopupMenuController(sourceView: sender, sourceRect: sender.bounds, presentationDirection: .down)

        controller.addSections([
            MSPopupMenuSection(title: "Canada", items: [
                MSPopupMenuItem(imageName: "Montreal", generateSelectedImage: false, title: "Montréal", subtitle: "Québec"),
                MSPopupMenuItem(imageName: "Toronto", generateSelectedImage: false, title: "Toronto", subtitle: "Ontario"),
                MSPopupMenuItem(imageName: "Vancouver", generateSelectedImage: false, title: "Vancouver", subtitle: "British Columbia")
            ]),
            MSPopupMenuSection(title: "United States", items: [
                MSPopupMenuItem(imageName: "Las Vegas", generateSelectedImage: false, title: "Las Vegas", subtitle: "Nevada"),
                MSPopupMenuItem(imageName: "Phoenix", generateSelectedImage: false, title: "Phoenix", subtitle: "Arizona"),
                MSPopupMenuItem(imageName: "San Francisco", generateSelectedImage: false, title: "San Francisco", subtitle: "California"),
                MSPopupMenuItem(imageName: "Seattle", generateSelectedImage: false, title: "Seattle", subtitle: "Washington")
            ])
        ])

        controller.selectedItemIndexPath = cityIndexPath
        controller.onDismiss = { [unowned controller] in
            self.cityIndexPath = controller.selectedItemIndexPath
        }

        present(controller, animated: true)
    }

    @objc private func showTopMenuWithScrollableItemsButtonTapped(sender: UIButton) {
        let controller = MSPopupMenuController(sourceView: sender, sourceRect: sender.bounds, presentationDirection: .down)

        let items = samplePersonas.map { MSPopupMenuItem(title: !$0.name.isEmpty ? $0.name : $0.email) }
        controller.addItems(items)

        present(controller, animated: true)
    }
}
