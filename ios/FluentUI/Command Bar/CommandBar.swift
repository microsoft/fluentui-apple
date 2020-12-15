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

    public var buttonBackgroundStyle: CommandBarButton.BackgroundStyle = .default {
        didSet {
            buttonGroups.forEach { $0.buttonBackgroundStyle = buttonBackgroundStyle }
        }
    }

    // MARK: Private Properties

    private let barApperance: CommandBarAppearance
    private let buttonGroups: [CommandBarButtonGroup]

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
            left: barApperance.insets.left,
            bottom: 0,
            right: barApperance.insets.right
        )
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true

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
        stackView.spacing = barApperance.buttonSpacing

        if let height = barApperance.contentHeight {
            stackView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }

        return stackView
    }()

    private let containerMaskLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear, UIColor.white].map { $0.cgColor }
        layer.startPoint = .zero
        layer.endPoint = CGPoint(x: 1, y: 0)
        layer.locations = [0, 0]

        return layer
    }()

    // MARK: - Init

    public init(appearance: CommandBarAppearance, buttonGroups: [CommandBarButtonGroup]) {
        self.barApperance = appearance
        self.buttonGroups = buttonGroups

        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        configureHierarchy()
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
    }
}

// MARK: - Private methods

private extension CommandBar {
    struct Constants {
        static let fadeViewWidth: CGFloat = 24
        static let closeButtonRightInset: CGFloat = 4
    }

    func configureHierarchy() {
        // Button container layout constrants
        addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),

            containerView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: barApperance.insets.top),
            bottomAnchor.constraint(greaterThanOrEqualTo: containerView.bottomAnchor, constant: barApperance.insets.bottom),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
}
