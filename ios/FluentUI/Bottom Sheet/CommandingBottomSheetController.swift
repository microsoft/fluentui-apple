//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public class CommandingBottomSheetController: UIViewController {

    public var heroItems: [CommandingItem] = [CommandingItem]() {
        didSet {
            if heroItems.count > 5 {
                assertionFailure("At most 5 hero commands are supported. Only the first 5 items will be used.")
                heroItems = Array(heroItems.prefix(5))
            }

            heroCommandStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
            for item in heroItems {
                let tabItem = TabBarItem(title: item.title, image: item.image, selectedImage: item.selectedImage)
                let itemView = TabBarItemView(item: tabItem, showsTitle: true)
                itemView.alwaysShowTitleBelowImage = true

                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHeroCommandTap(_:)))
                itemView.addGestureRecognizer(tapGesture)

                heroCommandStack.addArrangedSubview(itemView)

                NSLayoutConstraint.activate([
                    itemView.widthAnchor.constraint(equalToConstant: 48),
                    itemView.heightAnchor.constraint(equalToConstant: 48)
                ])
            }
        }
    }

    public var commandSections: [CommandingSection] = []

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
        return stackView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.isAccessibilityElement = true
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

    private func setupBottomBarLayout() {
        let bottomBarView = BottomBarView()
        bottomBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBarView)
        bottomBarView.contentView.addSubview(heroCommandStack)
        heroCommandStack.distribution = .fill
        heroCommandStack.spacing = 29

        self.bottomBarView = bottomBarView

        NSLayoutConstraint.activate([
            bottomBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -31),
            heroCommandStack.leadingAnchor.constraint(equalTo: bottomBarView.leadingAnchor, constant: 23),
            heroCommandStack.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor, constant: -23),
            heroCommandStack.topAnchor.constraint(equalTo: bottomBarView.topAnchor, constant: 16),
            heroCommandStack.bottomAnchor.constraint(equalTo: bottomBarView.bottomAnchor, constant: -16)
        ])
    }

    private func setupBottomSheetLayout() {
        let commandStackContainer = UIView()
        heroCommandStack.distribution = .equalSpacing
        heroCommandStack.spacing = 4
        commandStackContainer.addSubview(heroCommandStack)

        let sheetController = BottomSheetController(contentView: BottomSheetSplitContentView(headerView: commandStackContainer, contentView: tableView))

        addChild(sheetController)
        view.addSubview(sheetController.view)
        sheetController.didMove(toParent: self)
        bottomSheetController = sheetController

        NSLayoutConstraint.activate([
            sheetController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sheetController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheetController.view.topAnchor.constraint(equalTo: view.topAnchor),
            heroCommandStack.leadingAnchor.constraint(equalTo: commandStackContainer.leadingAnchor, constant: 11),
            heroCommandStack.trailingAnchor.constraint(equalTo: commandStackContainer.trailingAnchor, constant: -11),
            heroCommandStack.topAnchor.constraint(equalTo: commandStackContainer.topAnchor),
            heroCommandStack.bottomAnchor.constraint(equalTo: commandStackContainer.bottomAnchor, constant: -16)
        ])
    }

    private var bottomBarView: BottomBarView?

    private var bottomSheetController: BottomSheetController?

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
}

extension CommandingBottomSheetController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return commandSections.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(section < commandSections.count)

        return commandSections[section].items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
            return UITableViewCell()
        }

        let section = commandSections[indexPath.section]
        let item = section.items[indexPath.row]
        let iconView = UIImageView(image: item.image)
        iconView.tintColor = Colors.textSecondary
        cell.setup(title: item.title, subtitle: "", footer: "", customView: iconView, customAccessoryView: nil, accessoryType: .none)
        cell.bottomSeparatorType = .none

        return cell
    }
}

extension CommandingBottomSheetController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeaderFooterView.identifier) as? TableViewHeaderFooterView else {
            return nil
        }
        let section = commandSections[section]

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
