//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class TabBarItemView: UIView {
    private struct Constants {
        static let spacingVertical: CGFloat = 3.0
        static let spacingHorizontal: CGFloat = 8.0
        static let portraitImageSize: CGFloat = 28.0
        static let landscapeImageSize: CGFloat = 24.0
    }

    let item: TabBarItem
    var isSelected: Bool = false {
        didSet {
            titleLabel.isHighlighted = isSelected
            imageView.isHighlighted = isSelected
            updateColors()
            accessibilityTraits = isSelected ? .selected : .none
        }
    }

    private let container: UIStackView = {
        let container = UIStackView()
        container.alignment = .center
        container.distribution = .fill
        return container
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = unselectedColor
        return imageView
    }()

    private let titleLabel: Label = {
        let titleLabel = Label()
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textAlignment = .center
        titleLabel.textColor = unselectedColor
        return titleLabel
    }()

    private var imageHeightConstraint: NSLayoutConstraint?
    private var imageWidthConstraint: NSLayoutConstraint?

    private var isInPortraitMode: Bool {
        return traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular
    }

    init(item: TabBarItem, showsTitle: Bool) {
        self.item = item
        super.init(frame: .zero)

        container.addArrangedSubview(imageView)

        titleLabel.isHidden = !showsTitle
        if showsTitle {
            titleLabel.text = item.title
            container.addArrangedSubview(titleLabel)
        }

        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)

        isAccessibilityElement = true
        accessibilityLabel = item.title

        if #available(iOS 13, *) {
            self.largeContentImage = item.largeContentImage ?? item.image
            largeContentTitle = accessibilityLabel
            showsLargeContentViewer = true
            scalesLargeContentImage = true
        }

        imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: Constants.portraitImageSize)
        imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: Constants.portraitImageSize)

        NSLayoutConstraint.activate([imageHeightConstraint!,
                                     imageWidthConstraint!,
                                     container.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     container.centerYAnchor.constraint(equalTo: centerYAnchor)])

        updateLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass || previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass {
            updateLayout()
        }
    }

    override func didMoveToWindow() {
        updateColors()
    }

    private func updateColors() {
        if let window = window {
            let primaryColor = Colors.primary(for: window)
            titleLabel.highlightedTextColor = primaryColor
            imageView.tintColor = isSelected ? primaryColor : unselectedColor
        }
    }

    func updateLayout() {
        if isInPortraitMode {
            container.axis = .vertical
            container.spacing = Constants.spacingVertical
            imageHeightConstraint?.constant = Constants.portraitImageSize
            imageWidthConstraint?.constant = Constants.portraitImageSize
            titleLabel.style = .button3
        } else {
            container.axis = .horizontal
            container.spacing = Constants.spacingHorizontal
            imageHeightConstraint?.constant = Constants.landscapeImageSize
            imageWidthConstraint?.constant = Constants.landscapeImageSize
            titleLabel.style = .footnoteUnscaled
        }
        imageView.image = item.unselectedImage(isInPortraitMode: isInPortraitMode)
        imageView.highlightedImage = item.selectedImage(isInPortraitMode: isInPortraitMode)
    }
}

private let unselectedColor = Colors.foreground2c
