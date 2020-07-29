//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class TabBarItemView: UIView {
    let item: TabBarItem

    var isSelected: Bool = false {
        didSet {
            titleLabel.isHighlighted = isSelected
            imageView.isHighlighted = isSelected
            updateColors()
            accessibilityTraits = isSelected ? .selected : .none
        }
    }

    var badgeNumber: Int = 0 {
        didSet {
            updateLayout()
        }
    }

    private struct Constants {
        static let unselectedColor: UIColor = Colors.textSecondary
        static let spacingVertical: CGFloat = 3
        static let spacingHorizontal: CGFloat = 8
        static let portraitImageSize: CGFloat = 28
        static let portraitImageWithLabelSize: CGFloat = 24
        static let landscapeImageSize: CGFloat = 24
        static let badgeVerticalOffset: CGFloat = -6
        static let badgeHorizontalOffset: CGFloat = 4
        static let badgeHeight: CGFloat = 16
        static let badgeMinWidth: CGFloat = 16
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
        imageView.tintColor = Constants.unselectedColor
        return imageView
    }()

    private let titleLabel: Label = {
        let titleLabel = Label()
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textAlignment = .center
        titleLabel.textColor = Constants.unselectedColor
        return titleLabel
    }()

    private let badgeView: UIView = {
        let badgeView = UIView(frame: .zero)
        badgeView.backgroundColor = Colors.Palette.dangerPrimary.color

        return badgeView
    }()

    private var imageHeightConstraint: NSLayoutConstraint?
    private var imageWidthConstraint: NSLayoutConstraint?
    private let canResizeImage: Bool

    private var isInPortraitMode: Bool {
        return traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular
    }

    init(item: TabBarItem, showsTitle: Bool, canResizeImage: Bool = true) {
        self.canResizeImage = canResizeImage
        self.item = item
        super.init(frame: .zero)

        imageView.addSubview(badgeView)
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
        super.didMoveToWindow()
        updateColors()
    }

    private func updateColors() {
        if let window = window {
            let primaryColor = Colors.primary(for: window)
            titleLabel.highlightedTextColor = primaryColor
            imageView.tintColor = isSelected ? primaryColor : Constants.unselectedColor
        }
    }

    private func updateLayout() {
        imageView.image = item.unselectedImage(isInPortraitMode: isInPortraitMode, labelIsHidden: titleLabel.isHidden)
        imageView.highlightedImage = item.selectedImage(isInPortraitMode: isInPortraitMode, labelIsHidden: titleLabel.isHidden)

        if !canResizeImage {
            var imageSize = CGSize.zero
            if let image = imageView.image {
                imageSize = image.size
            }

            imageHeightConstraint?.constant = imageSize.height
            imageWidthConstraint?.constant = imageSize.width
        }

        if isInPortraitMode {
            container.axis = .vertical
            container.spacing = Constants.spacingVertical
            titleLabel.style = .button3

            if canResizeImage {
                imageHeightConstraint?.constant = titleLabel.isHidden ? Constants.portraitImageSize : Constants.portraitImageWithLabelSize
                imageWidthConstraint?.constant = titleLabel.isHidden ? Constants.portraitImageSize : Constants.portraitImageWithLabelSize
            }
        } else {
            container.axis = .horizontal
            container.spacing = Constants.spacingHorizontal
            titleLabel.style = .footnoteUnscaled

            if canResizeImage {
                imageHeightConstraint?.constant = Constants.landscapeImageSize
                imageWidthConstraint?.constant = Constants.landscapeImageSize
            }
        }

        if badgeNumber > 0 {
            badgeView.isHidden = false

            let imageViewWidth = imageWidthConstraint?.constant ?? 0 // TODO_
            let badgeWidth = Constants.badgeMinWidth

            badgeView.frame = CGRect(x: imageViewWidth - badgeWidth + Constants.badgeHorizontalOffset,
                                     y: Constants.badgeVerticalOffset,
                                     width: badgeWidth,
                                     height: Constants.badgeHeight)

            badgeView.layer.cornerRadius = badgeView.bounds.width / 3
        } else {
            badgeView.isHidden = true
        }
    }
}
