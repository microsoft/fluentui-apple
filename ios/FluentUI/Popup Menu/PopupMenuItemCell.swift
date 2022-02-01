//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class PopupMenuItemCell: TableViewCell, PopupMenuItemTemplateCell {

    var customSeparatorColor: UIColor? {
        didSet {
            bottomSeparator.state.overrideTokens = CustomDividerTokens(customSeparatorColor)
        }
    }

    class CustomDividerTokens: DividerTokens {
        var separatorColor: UIColor?
        override var color: DynamicColor {
            return separatorColor?.dynamicColor ?? super.color
        }

        init(_ separatorColor: UIColor?) {
            self.separatorColor = separatorColor
            super.init()
        }
    }

    private struct Constants {
        static let labelVerticalMarginForOneLine: CGFloat = 15
        static let accessoryImageViewOffset: CGFloat = 5

        static let imageViewSize: CustomViewSize = .small
        static let accessoryImageViewSize: CGFloat = 8

        static let defaultAlpha: CGFloat = 1.0
        static let highlightedAlpha: CGFloat = 0.4

        static let animationDuration: TimeInterval = 0.15
    }

    override class var labelVerticalMarginForOneAndThreeLines: CGFloat { return Constants.labelVerticalMarginForOneLine }

    static func preferredWidth(for item: PopupMenuTemplateItem, preservingSpaceForImage preserveSpaceForImage: Bool) -> CGFloat {
        guard let item = item as? PopupMenuItem else {
            assertionFailure("Invalid item type for cell.")
            return 0
        }

        let imageViewSize: CustomViewSize = item.image != nil || preserveSpaceForImage ? Constants.imageViewSize : .zero
        return preferredWidth(title: item.title, subtitle: item.subtitle ?? "", customViewSize: imageViewSize, customAccessoryView: item.accessoryView, accessoryType: .checkmark)
    }

    static func preferredHeight(for item: PopupMenuTemplateItem) -> CGFloat {
        guard let item = item as? PopupMenuItem else {
            assertionFailure("Invalid item type for cell.")
            return 0
        }

        return height(title: item.title, subtitle: item.subtitle ?? "", customViewSize: Constants.imageViewSize, customAccessoryView: item.accessoryView, accessoryType: .checkmark)
    }

    var isHeader: Bool = false {
        didSet {
            bottomSeparatorType = isHeader ? .full : .inset
            updateAccessibilityTraits()
        }
    }
    var preservesSpaceForImage: Bool = false

    override var customViewSize: CustomViewSize {
        get { return customView != nil || preservesSpaceForImage ? Constants.imageViewSize : .zero }
        set { }
    }

    override var isUserInteractionEnabled: Bool {
        get { return !isHeader && super.isUserInteractionEnabled }
        set { super.isUserInteractionEnabled = newValue }
    }

    private var item: PopupMenuItem?

    // Cannot use imageView since it exists in superclass
    private let _imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let accessoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Colors.Table.Cell.image
        return imageView
    }()

    override func initialize() {
        super.initialize()

        selectionStyle = .none

        contentView.addSubview(accessoryImageView)

        isAccessibilityElement = true
    }

    func setup(item: PopupMenuTemplateItem) {
        guard let item = item as? PopupMenuItem else {
            assertionFailure("Invalid item type for cell.")
            return
        }

        self.item = item

        _imageView.image = item.image
        _imageView.highlightedImage = item.selectedImage
        accessoryImageView.image = item.accessoryImage
        accessoryImageView.isHidden = _imageView.image == nil || accessoryImageView.image == nil

        setup(title: item.title, subtitle: item.subtitle ?? "", customView: _imageView.image != nil ? _imageView : nil, customAccessoryView: item.accessoryView)
        isEnabled = item.isEnabled
        titleNumberOfLines = 0

        updateViews()
        updateAccessibilityTraits()
    }

    override func layoutContentSubviews() {
        super.layoutContentSubviews()

        if !accessoryImageView.isHidden {
            accessoryImageView.frame = CGRect(
                x: _imageView.frame.maxX - Constants.accessoryImageViewOffset,
                y: _imageView.frame.minY + Constants.accessoryImageViewOffset - Constants.accessoryImageViewSize,
                width: Constants.accessoryImageViewSize,
                height: Constants.accessoryImageViewSize
            )
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let oldValue = isHighlighted
        super.setHighlighted(highlighted, animated: animated)
        if isHighlighted == oldValue {
            return
        }

        // Override default background color change
        backgroundColor = item?.backgroundColor ?? .clear

        if animated {
            UIView.animate(withDuration: Constants.animationDuration) {
                self.updateViews()
            }
        } else {
            updateViews()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        let oldValue = isSelected
        super.setSelected(selected, animated: animated)
        if isSelected == oldValue {
            return
        }

        // Override default background color change
        backgroundColor = item?.backgroundColor ?? .clear

        if animated {
            UIView.animate(withDuration: Constants.animationDuration) {
                self.updateViews()
            }
        } else {
            updateViews()
        }
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        updateSelectionColors()
    }

    private func updateAccessibilityTraits() {
        if isHeader {
            accessibilityTraits.remove(.button)
            accessibilityTraits.insert(.header)
        } else {
            accessibilityTraits.insert(.button)
            accessibilityTraits.remove(.header)
        }
    }

    private func updateViews() {
        // Highlight
        let alpha = isHighlighted ? Constants.highlightedAlpha : Constants.defaultAlpha
        _imageView.alpha = alpha
        accessoryImageView.alpha = alpha
        titleLabel.alpha = alpha
        subtitleLabel.alpha = alpha
        customAccessoryView?.alpha = alpha

        updateSelectionColors()

        _imageView.isHighlighted = isSelected
    }

    private func updateSelectionColors() {
        if let window = window {
            if let item = item {
                _imageView.tintColor = isSelected
                    ? item.imageSelectedColor ?? Colors.primary(for: window)
                    : item.imageColor
                titleLabel.textColor = isSelected
                    ? item.titleSelectedColor ?? Colors.primary(for: window)
                    : item.titleColor
                subtitleLabel.textColor = isSelected
                    ? item.subtitleSelectedColor ?? Colors.primary(for: window)
                    : item.subtitleColor
                backgroundColor = item.backgroundColor
            }

            if isSelected && item?.isAccessoryCheckmarkVisible == true {
                _accessoryType = .checkmark
                accessoryTypeView?.customTintColor = item?.accessoryCheckmarkColor ?? Colors.primary(for: window)
            } else {
                _accessoryType = .none
            }
        }
    }
}
