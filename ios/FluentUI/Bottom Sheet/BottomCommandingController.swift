//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public class BottomCommandingController: UIViewController {

    public var heroItems: [CommandingItem] = [CommandingItem]() {
        didSet {
            if heroItems.count > 5 {
                assertionFailure("At most 5 hero commands are supported. Only the first 5 items will be used.")
                heroItems = Array(heroItems.prefix(5))
            }
            heroButtonWidthConstraints.removeAll()
            heroCommandStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
            for item in heroItems {
                let tabItem = TabBarItem(title: item.title, image: item.image, selectedImage: item.selectedImage)
                let itemView = TabBarItemView(item: tabItem, showsTitle: true)
                itemView.alwaysShowTitleBelowImage = true

                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHeroCommandTap(_:)))
                itemView.addGestureRecognizer(tapGesture)

                heroCommandStack.addArrangedSubview(itemView)

                NSLayoutConstraint.activate([
                    itemView.heightAnchor.constraint(equalToConstant: 48)
                ])
                heroButtonWidthConstraints.append(itemView.widthAnchor.constraint(equalToConstant: 96))

                item.handlePropertyChange = handleItemPropertyChange(item:property:)
            }

        }
    }

    public var listCommandSections: [CommandingSection] = []

    public override func loadView() {
        view = BottomSheetPassthroughView()
        view.translatesAutoresizingMaskIntoConstraints = false

        if traitCollection.horizontalSizeClass == .regular {
            setupBottomBarLayout()
        } else if traitCollection.horizontalSizeClass == .compact {
            setupBottomSheetLayout()
        }
    }

    private lazy var heroCommandStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private var heroButtonWidthConstraints: [NSLayoutConstraint] = []

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.isAccessibilityElement = true
        tableView.sectionFooterHeight = 0
        tableView.backgroundColor = Colors.Table.background
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(TableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: TableViewHeaderFooterView.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    @objc private func handleHeroCommandTap(_ sender: UITapGestureRecognizer) {
        guard let tabBarItemView = sender.view as? TabBarItemView else {
            return
        }

        tabBarItemView.isSelected.toggle()
    }

    @objc private func handleMoreButtonTap(_ sender: UITapGestureRecognizer) {
        let popoverContentVC = UIViewController()
        popoverContentVC.view.addSubview(tableView)
        popoverContentVC.modalPresentationStyle = .popover
        popoverContentVC.popoverPresentationController?.sourceView = sender.view

        NSLayoutConstraint.activate([
            popoverContentVC.view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            popoverContentVC.view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            popoverContentVC.view.topAnchor.constraint(equalTo: tableView.topAnchor),
            popoverContentVC.view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])

        present(popoverContentVC, animated: true)
    }

    private func setupBottomBarLayout() {
        NSLayoutConstraint.activate(heroButtonWidthConstraints)

        let bottomBarView = BottomBarView()
        bottomBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBarView)

        let commandContainer = UIStackView()
        commandContainer.axis = .horizontal
        commandContainer.translatesAutoresizingMaskIntoConstraints = false
        commandContainer.addArrangedSubview(heroCommandStack)

        let moreButtonItem = TabBarItem(title: "More", image: UIImage.staticImageNamed("more-24x24")!)
        let moreButtonView = TabBarItemView(item: moreButtonItem, showsTitle: true)
        moreButtonView.alwaysShowTitleBelowImage = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMoreButtonTap(_:)))
        moreButtonView.addGestureRecognizer(tapGesture)

        commandContainer.addArrangedSubview(moreButtonView)

        bottomBarView.contentView.addSubview(commandContainer)
        self.bottomBarView = bottomBarView

        NSLayoutConstraint.activate([
            bottomBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -31),
            commandContainer.leadingAnchor.constraint(equalTo: bottomBarView.leadingAnchor, constant: 8),
            commandContainer.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor, constant: -8),
            commandContainer.topAnchor.constraint(equalTo: bottomBarView.topAnchor, constant: 16),
            commandContainer.bottomAnchor.constraint(equalTo: bottomBarView.bottomAnchor, constant: -16),
            moreButtonView.widthAnchor.constraint(equalToConstant: 96),
            moreButtonView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func setupBottomSheetLayout() {
        NSLayoutConstraint.deactivate(heroButtonWidthConstraints)
        heroCommandStack.distribution = .fillEqually

        let commandStackContainer = UIView()
        commandStackContainer.addSubview(heroCommandStack)

        let sheetController = BottomSheetController(contentView: BottomSheetSplitContentView(headerView: commandStackContainer, contentView: tableView))
        sheetController.hostedScrollView = tableView

        NSLayoutConstraint.activate([
            heroCommandStack.leadingAnchor.constraint(equalTo: commandStackContainer.leadingAnchor, constant: 8),
            heroCommandStack.trailingAnchor.constraint(equalTo: commandStackContainer.trailingAnchor, constant: -8),
            heroCommandStack.topAnchor.constraint(equalTo: commandStackContainer.topAnchor),
            heroCommandStack.bottomAnchor.constraint(equalTo: commandStackContainer.bottomAnchor, constant: -16)
        ])

        sheetController.collapsedContentHeight = commandStackContainer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

        addChild(sheetController)
        view.addSubview(sheetController.view)
        sheetController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            sheetController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sheetController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheetController.view.topAnchor.constraint(equalTo: view.topAnchor)

        ])

        bottomSheetController = sheetController
    }

    private func handleItemPropertyChange(item: CommandingItem, property: CommandingItem.MutableProperty) {
        guard let view = itemToViewMap[item] else {
            return
        }

        switch property {
        case .isEnabled:
            let newValue = item.isEnabled

            switch view {
            case let tabBarItemView as TabBarItemView:
                tabBarItemView.isEnabled = newValue
            case let cell as TableViewCell:
                cell.isEnabled = newValue
            default:
                break
            }
        case .isOn:
            let newValue = item.isOn

            switch view {
            case let tabBarItemView as TabBarItemView:
                tabBarItemView.isSelected = newValue
            case let booleanCell as BooleanCell:
                booleanCell.isOn = newValue
            default:
                break
            }
        }
    }

    private var itemToViewMap: [CommandingItem: UIView] = [:]

    private var bottomBarView: BottomBarView?

    private var bottomSheetController: BottomSheetController?

    private lazy var heroStackSpacers: [UIView] = [UIView(), UIView()]

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass {
            if let previousTraits = previousTraitCollection {
                if previousTraits.horizontalSizeClass == .compact {
                    bottomSheetController?.willMove(toParent: nil)
                    bottomSheetController?.removeFromParent()
                    bottomSheetController?.view.removeFromSuperview()
                    bottomSheetController = nil
                } else if previousTraits.horizontalSizeClass == .regular {
                    bottomBarView?.removeFromSuperview()
                    bottomBarView = nil
                }
            }

            switch traitCollection.horizontalSizeClass {
            case .compact:
                setupBottomSheetLayout()
            case .regular:
                setupBottomBarLayout()
            default:
                break
            }
        }
    }
//
//    private enum ItemLocation {
//        case hero
//        case grid
//        case list
//    }
}
//
//extension BottomCommandingController: CommandingItemDelegate {
//    func commandingItem(_ item: CommandingItem, didChangeEnabledFrom oldValue: Bool) {
//        if oldValue != item.isEnabled {
//            guard let view = itemToViewMap[item] else {
//                return
//            }
//
//            switch view {
//            case let tabBarItemView as TabBarItemView:
//                tabBarItemView.isEnabled = item.isEnabled
//            case let cell as TableViewCell:
//                cell.isEnabled = item.isEnabled
//            default:
//                break
//            }
//        }
//    }
//
//    func commandingItem(_ item: CommandingItem, didChangeOnFrom oldValue: Bool) {
//        if oldValue != item.isOn {
//            guard let view = itemToViewMap[item] else {
//                return
//            }
//
//            switch view {
//            case let tabBarItemView as TabBarItemView:
//                tabBarItemView.isSelected = item.isOn
//            case let cell as TableViewCell:
////                cell.isEnabled = item.isEnabled
//            default:
//                break
//            }
//        }
//    }
//}

extension BottomCommandingController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return listCommandSections.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(section < listCommandSections.count)

        return listCommandSections[section].items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
            return UITableViewCell()
        }

        let section = listCommandSections[indexPath.section]
        let item = section.items[indexPath.row]
        let iconView = UIImageView(image: item.image)
        iconView.tintColor = Colors.textSecondary
        cell.setup(title: item.title, subtitle: "", footer: "", customView: iconView, customAccessoryView: nil, accessoryType: .none)
        cell.bottomSeparatorType = .none
        cell.isEnabled = item.isEnabled

        return cell
    }
}

extension BottomCommandingController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeaderFooterView.identifier) as? TableViewHeaderFooterView else {
            return nil
        }
        let section = listCommandSections[section]

        if let sectionTitle = section.title {
            header.setup(style: .header, title: sectionTitle)
        } else {
            return nil
        }

        return header
    }
}

private class BottomSheetSplitContentView: UIView {
    public init(headerView: UIView, contentView: UIView) {
        self.headerView = headerView
        self.contentView = contentView

        super.init(frame: .zero)

        headerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        let separator = Separator()
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerView)
        addSubview(contentView)
        addSubview(separator)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.topAnchor.constraint(equalTo: contentView.topAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    private let headerView: UIView
    private let contentView: UIView
}
