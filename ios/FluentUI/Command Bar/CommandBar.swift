//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public class CommandBar: UIView {
    // Hierarchy:
    //
    // closeButton
    // containerView
    // |--layer.mask -> containerMaskLayer (fill containerView)
    // |--subviews
    // |  |--scrollView (fill containerView)
    // |  |  |--subviews
    // |  |  |  |--stackView
    // |  |  |  |  |--buttons (fill scrollView content)

    // MARK: Public Properties

    public weak var delegate: CommandBarDelegate?

    // MARK: Private Properties

    private let barAppearance: CommandBarAppearance
    private let itemGroups: [CommandBarItemGroup]
    private let leadingItem: CommandBarItem?
    private let trailingItem: CommandBarItem?

    private lazy var itemsToButtonsMap: [CommandBarItem: CommandBarButton] = {
        let allButtons = itemGroups.flatMap({ $0 }).map({ button(forItem: $0) }) +
            [leadingButton, trailingButton].compactMap({ $0 })

        return Dictionary(uniqueKeysWithValues:
                            allButtons
                            .map { ($0.item, $0) })
    }()

    // MARK: - Views and Layers

    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.mask = containerMaskLayer

        containerView.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: containerView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])

        return containerView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(
            top: 0,
            left: leadingButton == nil ? barAppearance.insets.left : barAppearance.buttonSpacing - Constants.horizontalButtonInset,
            bottom: 0,
            right: trailingButton == nil ? barAppearance.insets.right : barAppearance.buttonSpacing - Constants.horizontalButtonInset
        )
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.delegate = self

        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            scrollView.contentLayoutGuide.heightAnchor.constraint(equalTo: scrollView.heightAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])

        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: buttonGroups)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = barAppearance.buttonSpacing

        if let height = barAppearance.contentHeight {
            stackView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }

        return stackView
    }()

    private lazy var buttonGroups: [CommandBarButtonGroupView] = {
        itemGroups.map { items in
            CommandBarButtonGroupView(buttons: items.compactMap { item in
                guard let button = itemsToButtonsMap[item] else {
                    fatalError("Button is not initialized in commandsToButtons")
                }

                return button
            })
        }
    }()

    private lazy var leadingButton: CommandBarButton? = {
        guard let leftItem = leadingItem else {
            return nil
        }

        return button(forItem: leftItem, isFixed: true)
    }()

    private lazy var trailingButton: CommandBarButton? = {
        guard let rightItem = trailingItem else {
            return nil
        }

        return button(forItem: rightItem, isFixed: true)
    }()

    private let containerMaskLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear, UIColor.white, UIColor.white, UIColor.clear].map { $0.cgColor }
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.locations = [0, 0, 1]

        return layer
    }()

    // MARK: - Init

    public init(appearance: CommandBarAppearance, itemGroups: [CommandBarItemGroup], leadingItem: CommandBarItem? = nil, trailingItem: CommandBarItem? = nil) {
        self.barAppearance = appearance
        self.itemGroups = itemGroups
        self.leadingItem = leadingItem
        self.trailingItem = trailingItem

        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        configureHierarchy()
        updateButtonsState()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var intrinsicContentSize: CGSize {
        .zero
    }

    // MARK: Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()

        containerMaskLayer.frame = containerView.bounds
        updateContainerMask()
    }

    // MARK: - Public methods

    public func updateButtonsState() {
        for button in itemsToButtonsMap.values {
            button.updateState()
        }
    }

    public func updateButtonGroupsAppearance(_ appearance: CommandBarButtonAppearance) {
        for buttonGroup in buttonGroups {
            buttonGroup.updateAppearance(appearance)
        }
    }
}

// MARK: - Scroll view delegate

extension CommandBar: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateContainerMask()
    }
}

// MARK: - Private methods

private extension CommandBar {
    struct Constants {
        static let fadeViewWidth: CGFloat = 24
        static let horizontalButtonInset: CGFloat = 4
        static let fixedButtonApperance = CommandBarButtonAppearance(backgroundColor: .clear)
    }

    func configureHierarchy() {
        addSubview(containerView)

        // Left and right button layout constrants
        if let leftButton = leadingButton {
            addSubview(leftButton)
            NSLayoutConstraint.activate([
                leftButton.centerYAnchor.constraint(equalTo: centerYAnchor),

                leftButton.topAnchor.constraint(equalTo: containerView.topAnchor),
                leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: barAppearance.insets.left),
                containerView.bottomAnchor.constraint(equalTo: leftButton.bottomAnchor)
            ])
        }

        if let rightButton = trailingButton {
            addSubview(rightButton)

            NSLayoutConstraint.activate([
                rightButton.centerYAnchor.constraint(equalTo: centerYAnchor),

                rightButton.topAnchor.constraint(equalTo: containerView.topAnchor),
                containerView.bottomAnchor.constraint(equalTo: rightButton.bottomAnchor),
                trailingAnchor.constraint(equalTo: rightButton.trailingAnchor, constant: barAppearance.insets.right)
            ])
        }

        // Button container layout constrants
        let containerLeadingConstraint: NSLayoutConstraint = {
            if let leftButton = leadingButton {
                return containerView.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor, constant: Constants.horizontalButtonInset)
            } else {
                return containerView.leadingAnchor.constraint(equalTo: leadingAnchor)
            }
        }()

        let containerTrailingConstraint: NSLayoutConstraint = {
            if let rightButton = trailingButton {
                return rightButton.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Constants.horizontalButtonInset)
            } else {
                return trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            }
        }()

        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),

            containerView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: barAppearance.insets.top),
            bottomAnchor.constraint(greaterThanOrEqualTo: containerView.bottomAnchor, constant: barAppearance.insets.bottom),

            containerLeadingConstraint,
            containerTrailingConstraint
        ])

        stackView.layoutIfNeeded()
    }

    func button(forItem item: CommandBarItem, isFixed: Bool = false) -> CommandBarButton {
        let button = CommandBarButton(item: item, appearance: isFixed ? Constants.fixedButtonApperance : barAppearance.buttonAppearance)
        button.addTarget(self, action: #selector(handleCommandButtonTapped(_:)), for: .touchUpInside)

        return button
    }

    func updateContainerMask() {
        var locations: [CGFloat] = [0, 0, 1]

        if leadingButton != nil {
            let leadingOffset = max(0, scrollView.contentOffset.x)
            let percentage = min(1, leadingOffset / scrollView.contentInset.left)
            locations[1] = Constants.fadeViewWidth / containerView.frame.width * percentage
        }

        if trailingButton != nil {
            let trailingOffset = max(0, stackView.frame.width - scrollView.frame.width - scrollView.contentOffset.x)
            let percentage = min(1, trailingOffset / scrollView.contentInset.right)
            locations[2] = 1 - Constants.fadeViewWidth / containerView.frame.width * percentage
        }

        containerMaskLayer.locations = locations.map { NSNumber(value: Float($0)) }
    }

    @objc func handleCommandButtonTapped(_ sender: CommandBarButton) {
        let newSelected = !sender.item.isSelected

        guard let delegate = delegate else {
            sender.item.isSelected = newSelected
            sender.updateState()

            return
        }

        guard newSelected ? delegate.commandBar(self, shouldSelectItem: sender.item) : delegate.commandBar(self, shouldDeselectItem: sender.item) else {
            return
        }

        sender.item.isSelected = newSelected
        sender.updateState()

        if newSelected {
            delegate.commandBar(self, didSelectItem: sender.item)
        } else {
            delegate.commandBar(self, didDeselectItem: sender.item)
        }
    }
}
