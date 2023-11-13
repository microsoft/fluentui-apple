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

    private let navButtonTitleSwitch = BrandedSwitch()
    private let navButtonSubtitleSwitch = BrandedSwitch()
    private let switchTextWidth: CGFloat = 150

    private var calendarLayout: CalendarLayout = .agenda
    private var cityIndexPath: IndexPath? = IndexPath(item: 2, section: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        readmeString = "A popup menu is a small, temporary window that appears on demand to give non-essential, contextual information.\n\nPopup menus can have structured content and interactive components but limit the functionality that you include in them. Generally, they work best in wider views. If you need to show contextual info in a compact view, try a sheet instead."

        let showButton = UIBarButtonItem(title: "Show", style: .plain, target: self, action: #selector(topBarButtonTapped))
        navigationItem.rightBarButtonItems?.append(showButton)

        toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Selection", style: .plain, target: self, action: #selector(bottomBarButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "1-line description", style: .plain, target: self, action: #selector(bottomBarButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "2-line header", style: .plain, target: self, action: #selector(bottomBarButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ]

        container.addArrangedSubview(createButton(title: "Show with sections", action: #selector(showTopMenuWithSectionsButtonTapped)))
        container.addArrangedSubview(createButton(title: "Show with scrollable items and no icons", action: #selector(showTopMenuWithScrollableItemsButtonTapped)))
        container.addArrangedSubview(createButton(title: "Show items with custom colors", action: #selector(showCustomColorsButtonTapped)))
        container.addArrangedSubview(createButton(title: "Show items without dismissal after being tapped", action: #selector(showNoDismissalItemsButtonTapped)))
        container.addArrangedSubview(UIView())
        container.addArrangedSubview(createButton(title: "Objective-C Demo", action: #selector(showObjCDemo)))
        addTitle(text: "Navigation Button Settings")
        addRow(text: "Show Title", items: [navButtonTitleSwitch], textWidth: switchTextWidth)
        navButtonTitleSwitch.addTarget(self, action: #selector(handleOnSwitchChanged), for: .valueChanged)
        addRow(text: "Show Subtitle", items: [navButtonSubtitleSwitch], textWidth: switchTextWidth)
        navButtonSubtitleSwitch.isEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isToolbarHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = true
    }

    private func createAccessoryView(text: String) -> UIView {
        let accessoryView = BadgeView(dataSource: BadgeViewDataSource(text: text, style: .default, sizeCategory: .small))
        accessoryView.isUserInteractionEnabled = false
        accessoryView.sizeToFit()
        return accessoryView
    }

    @objc private func handleOnSwitchChanged() {
        navButtonSubtitleSwitch.isEnabled = navButtonTitleSwitch.isOn
        if navButtonSubtitleSwitch.isOn && !navButtonSubtitleSwitch.isEnabled {
            navButtonSubtitleSwitch.isOn = false
        }
    }

    @objc private func topBarButtonTapped(sender: UIBarButtonItem) {
        let controller = PopupMenuController(barButtonItem: sender, presentationDirection: .down)

        if navButtonTitleSwitch.isOn {
            controller.headerItem = PopupMenuItem(title: "Header Title", subtitle: navButtonSubtitleSwitch.isOn ? "Header Subtitle" : nil)
        }

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

    @objc private func showTopMenuWithSectionsButtonTapped(sender: UIButton) {
        let controller = PopupMenuController(sourceView: sender, sourceRect: sender.bounds, presentationDirection: .down)
        let overrideTokens = perControlOverrideEnabled ? perControlOverridePopupMenuTokens : nil
        controller.popupTokenSet.replaceAllOverrides(with: overrideTokens)

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

        controller.selectedItemIndexPath = cityIndexPath
        controller.onDismiss = { [unowned controller] in
            self.cityIndexPath = controller.selectedItemIndexPath
        }

        present(controller, animated: true)
    }

    @objc private func showTopMenuWithScrollableItemsButtonTapped(sender: UIButton) {
        let controller = PopupMenuController(sourceView: sender, sourceRect: sender.bounds, presentationDirection: .down)
        let overrideTokens = perControlOverrideEnabled ? perControlOverridePopupMenuTokens : nil
        controller.popupTokenSet.replaceAllOverrides(with: overrideTokens)

        let items = samplePersonas.map { PopupMenuItem(title: !$0.name.isEmpty ? $0.name : $0.email) }
        controller.addItems(items)

        present(controller, animated: true)
    }

    @objc private func showCustomColorsButtonTapped(sender: UIButton) {
        let controller = PopupMenuController(sourceView: sender, sourceRect: sender.bounds, presentationDirection: .down)
        let overrideTokens = perControlOverrideEnabled ? perControlOverridePopupMenuTokens : nil
        controller.popupTokenSet.replaceAllOverrides(with: overrideTokens)

        let items = [
            PopupMenuItem(image: UIImage(named: "agenda-24x24"), title: "Agenda", isSelected: calendarLayout == .agenda, onSelected: { self.calendarLayout = .agenda }),
            PopupMenuItem(image: UIImage(named: "day-view-24x24"), title: "Day", isSelected: calendarLayout == .day, onSelected: { self.calendarLayout = .day }),
            PopupMenuItem(image: UIImage(named: "3-day-view-24x24"), title: "3-Day", isEnabled: false, isSelected: calendarLayout == .threeDay, onSelected: { self.calendarLayout = .threeDay })
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
        controller.separatorColor = .lightGray

        present(controller, animated: true)
    }

    @objc private func showNoDismissalItemsButtonTapped(sender: UIButton) {
        let controller = PopupMenuController(sourceView: sender, sourceRect: sender.bounds, presentationDirection: .down)
        let overrideTokens = perControlOverrideEnabled ? perControlOverridePopupMenuTokens : nil
        controller.popupTokenSet.replaceAllOverrides(with: overrideTokens)

        let items = [
            PopupMenuItem(image: UIImage(named: "agenda-24x24"), title: "Agenda", isSelected: calendarLayout == .agenda, executes: .onSelectionWithoutDismissal, onSelected: { self.calendarLayout = .agenda }),
            PopupMenuItem(image: UIImage(named: "day-view-24x24"), title: "Day", isSelected: calendarLayout == .day, executes: .onSelectionWithoutDismissal, onSelected: { self.calendarLayout = .day }),
            PopupMenuItem(image: UIImage(named: "3-day-view-24x24"), title: "3-Day", isEnabled: false, isSelected: calendarLayout == .threeDay, executes: .onSelectionWithoutDismissal, onSelected: { self.calendarLayout = .threeDay })
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
        controller.separatorColor = .lightGray

        present(controller, animated: true)
    }

    @objc private func showObjCDemo(sender: UIButton) {
        navigationController?.pushViewController(PopupMenuObjCDemoController(), animated: true)
    }

    private var perControlOverrideEnabled: Bool = false
}

extension PopupMenuDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }

        fluentTheme.register(tokenSetType: PopupMenuTokenSet.self, tokenSet: isOverrideEnabled ? themeWideOverridePopupMenuTokens : nil)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        perControlOverrideEnabled = isOverrideEnabled
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: PopupMenuTokenSet.self)?.isEmpty == false
    }

    // MARK: - Custom tokens

    private var themeWideOverridePopupMenuTokens: [PopupMenuTokenSet.Tokens: ControlTokenValue] {
        return [
            .drawerContentBackgroundColor: .uiColor { UIColor(light: GlobalTokens.sharedColor(.plum, .shade30),
                                                              dark: GlobalTokens.sharedColor(.plum, .tint60))
            }
        ]
    }

    private var perControlOverridePopupMenuTokens: [PopupMenuTokenSet.Tokens: ControlTokenValue] {
        return [
            .drawerContentBackgroundColor: .uiColor { UIColor(light: GlobalTokens.sharedColor(.forest, .shade40),
                                                              dark: GlobalTokens.sharedColor(.forest, .tint60))
            },
            .resizingHandleMarkColor: .uiColor {
                .red
            },
            .resizingHandleBackgroundColor: .uiColor {
                .blue
            }
        ]
    }
}
