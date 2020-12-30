//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class PopupMenuDemoController: DemoController {
    private enum CalendarLayout {
        case agenda
        case day
        case threeDay
        case week
        case month
    }

    override var allowsContentToScroll: Bool { return false }

    private var calendarLayout: CalendarLayout = .agenda
    private var cityIndexPath: IndexPath? = IndexPath(item: 2, section: 1)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show", style: .plain, target: self, action: #selector(topBarButtonTapped))

        toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Selection", style: .plain, target: self, action: #selector(bottomBarButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "1-line description", style: .plain, target: self, action: #selector(bottomBarButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "2-line header", style: .plain, target: self, action: #selector(bottomBarButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ]

        container.addArrangedSubview(createButton(title: "Show with sections", action: { [weak self] sender in
            guard let strongSelf = self else {
                return
            }

            let buttonView = sender.view
            let controller = PopupMenuController(sourceView: buttonView, sourceRect: buttonView.bounds, presentationDirection: .down)

            controller.addSections([
                PopupMenuSection(title: "Canada", items: [
                    PopupMenuItem(imageName: "Montreal", generateSelectedImage: false, title: "Montréal", subtitle: "Québec"),
                    PopupMenuItem(imageName: "Toronto", generateSelectedImage: false, title: "Toronto", subtitle: "Ontario"),
                    PopupMenuItem(imageName: "Vancouver", generateSelectedImage: false, title: "Vancouver", subtitle: "British Columbia")
                ]),
                PopupMenuSection(title: "United States", items: [
                    PopupMenuItem(imageName: "Las Vegas", generateSelectedImage: false, title: "Las Vegas", subtitle: "Nevada"),
                    PopupMenuItem(imageName: "Phoenix", generateSelectedImage: false, title: "Phoenix", subtitle: "Arizona"),
                    PopupMenuItem(imageName: "San Francisco", generateSelectedImage: false, title: "San Francisco", subtitle: "California"),
                    PopupMenuItem(imageName: "Seattle", generateSelectedImage: false, title: "Seattle", subtitle: "Washington")
                ])
            ])

            controller.selectedItemIndexPath = strongSelf.cityIndexPath
            controller.onDismiss = { [unowned controller] in
                strongSelf.cityIndexPath = controller.selectedItemIndexPath
            }

            strongSelf.present(controller, animated: true)
        }).view)

        container.addArrangedSubview(createButton(title: "Show with scrollable items and no icons", action: { [weak self] sender in
            guard let strongSelf = self else {
                return
            }

            let buttonView = sender.view
            let controller = PopupMenuController(sourceView: buttonView, sourceRect: buttonView.bounds, presentationDirection: .down)

            let items = samplePersonas.map { PopupMenuItem(title: !$0.name.isEmpty ? $0.name : $0.email) }
            controller.addItems(items)

            strongSelf.present(controller, animated: true)
        }).view)

        container.addArrangedSubview(createButton(title: "Show items with custom colors", action: { [weak self] sender in
            guard let strongSelf = self else {
                return
            }

            let buttonView = sender.view
            let controller = PopupMenuController(sourceView: buttonView, sourceRect: buttonView.bounds, presentationDirection: .down)

            let items = [
                PopupMenuItem(image: UIImage(named: "agenda-24x24"), title: "Agenda", isSelected: strongSelf.calendarLayout == .agenda, onSelected: { strongSelf.calendarLayout = .agenda }),
                PopupMenuItem(image: UIImage(named: "day-view-24x24"), title: "Day", isSelected: strongSelf.calendarLayout == .day, onSelected: { strongSelf.calendarLayout = .day }),
                PopupMenuItem(image: UIImage(named: "3-day-view-24x24"), title: "3-Day", isEnabled: false, isSelected: strongSelf.calendarLayout == .threeDay, onSelected: { strongSelf.calendarLayout = .threeDay })
            ]

            let menuBackgroundColor: UIColor = .darkGray

            for item in items {
                item.titleColor = .white
                item.titleSelectedColor = .white
                item.imageSelectedColor = .white
                item.accessoryCheckmarkColor = .white
                item.backgroundColor = menuBackgroundColor
            }

            controller.addItems(items)

            controller.backgroundColor = menuBackgroundColor
            controller.resizingHandleViewBackgroundColor = menuBackgroundColor
            controller.separatorColor = .lightGray

            strongSelf.present(controller, animated: true)
        }).view)

        container.addArrangedSubview(createButton(title: "Show items without dismissal after being tapped", action: { [weak self] sender in
            guard let strongSelf = self else {
                return
            }

            let buttonView = sender.view
            let controller = PopupMenuController(sourceView: buttonView, sourceRect: buttonView.bounds, presentationDirection: .down)

            let items = [
                PopupMenuItem(image: UIImage(named: "agenda-24x24"), title: "Agenda", isSelected: strongSelf.calendarLayout == .agenda, executes: .onSelectionWithoutDismissal, onSelected: { strongSelf.calendarLayout = .agenda }),
                PopupMenuItem(image: UIImage(named: "day-view-24x24"), title: "Day", isSelected: strongSelf.calendarLayout == .day, executes: .onSelectionWithoutDismissal, onSelected: { strongSelf.calendarLayout = .day }),
                PopupMenuItem(image: UIImage(named: "3-day-view-24x24"), title: "3-Day", isEnabled: false, isSelected: strongSelf.calendarLayout == .threeDay, executes: .onSelectionWithoutDismissal, onSelected: { strongSelf.calendarLayout = .threeDay })
            ]

            let menuBackgroundColor: UIColor = .darkGray

            for item in items {
                item.titleColor = .white
                item.titleSelectedColor = .white
                item.imageSelectedColor = .white
                item.accessoryCheckmarkColor = .white
                item.backgroundColor = menuBackgroundColor
            }

            controller.addItems(items)

            controller.backgroundColor = menuBackgroundColor
            controller.resizingHandleViewBackgroundColor = menuBackgroundColor
            controller.separatorColor = .lightGray

            strongSelf.present(controller, animated: true)
        }).view)

        container.addArrangedSubview(UIView())
        addTitle(text: "Show with...")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isToolbarHidden = false
    }

    private func createAccessoryView(text: String) -> UIView {
        let accessoryView = BadgeView(dataSource: BadgeViewDataSource(text: text, style: .default, size: .small))
        accessoryView.isUserInteractionEnabled = false
        accessoryView.sizeToFit()
        return accessoryView
    }

    @objc private func topBarButtonTapped(sender: UIBarButtonItem) {
        let controller = PopupMenuController(barButtonItem: sender, presentationDirection: .down)

        controller.addItems([
            PopupMenuItem(image: UIImage(named: "mail-unread-24x24"), title: "Unread"),
            PopupMenuItem(image: UIImage(named: "flag-24x24"), title: "Flagged", accessoryView: createAccessoryView(text: "New")),
            PopupMenuItem(image: UIImage(named: "attach-24x24"), accessoryImage: UIImage(named: "gleam"), title: "Attachments", isAccessoryCheckmarkVisible: false)
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

        let controller = PopupMenuController(barButtonItem: sender, presentationOrigin: origin, presentationDirection: .up)

        if sender.title == "1-line description" {
            controller.headerItem = PopupMenuItem(title: "Pick a calendar layout")
        }
        if sender.title == "2-line header" {
            controller.headerItem = PopupMenuItem(title: "Calendar layout", subtitle: "Some options might not be available")
        }
        controller.addItems([
            PopupMenuItem(image: UIImage(named: "agenda-24x24"), title: "Agenda", isSelected: calendarLayout == .agenda, onSelected: { self.calendarLayout = .agenda }),
            PopupMenuItem(image: UIImage(named: "day-view-24x24"), title: "Day", isSelected: calendarLayout == .day, onSelected: { self.calendarLayout = .day }),
            PopupMenuItem(image: UIImage(named: "3-day-view-24x24"), title: "3-Day", isEnabled: false, isSelected: calendarLayout == .threeDay, onSelected: { self.calendarLayout = .threeDay }),
            PopupMenuItem(title: "Week (no icon)", isSelected: calendarLayout == .week, onSelected: { self.calendarLayout = .week }),
            PopupMenuItem(image: UIImage(named: "month-view-24x24"), title: "Month", isSelected: calendarLayout == .month, onSelected: { self.calendarLayout = .month })
        ])

        present(controller, animated: true)
    }
}
