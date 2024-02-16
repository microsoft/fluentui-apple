//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class PopupMenuItemCell: TableViewCell, PopupMenuItemTemplateCell {

    var customSeparatorColor: UIColor? {
        didSet {
            bottomSeparator.backgroundColor = customSeparatorColor
        }
    }

    private struct Constants {
        static let labelVerticalMarginForOneLine: CGFloat = 15
        static let accessoryImageViewOffset: CGFloat = 5

        static let imageViewSize: MSFTableViewCellCustomViewSize = .small
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

        let imageViewSize: MSFTableViewCellCustomViewSize = item.image != nil || preserveSpaceForImage ? Constants.imageViewSize : .zero
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

    override var customViewSize: MSFTableViewCellCustomViewSize {
        get { return customView != nil || preservesSpaceForImage ? Constants.imageViewSize : .zero }
        set { }
    }

    override var isUserInteractionEnabled: Bool {
        get { return !isHeader && super.isUserInteractionEnabled }
        set { super.isUserInteractionEnabled = newValue }
    }

    override var tokenSet: TableViewCellTokenSet {
        get {
            guard let item = item else {
                return super.tokenSet
            }
            return item.tokenSet
        }
        set {
            assertionFailure("PopupMenuItemCell tokens must be set through PopupMenuItem.tokenSet")
        }
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
        return imageView
    }()

    override func initialize() {
        super.initialize()
        tokenSet.customViewSize = { self.customViewSize }

        selectionStyle = .none

        contentView.addSubview(accessoryImageView)

        isAccessibilityElement = true
    }

    override func updateAppearance() {
        super.updateAppearance()
        backgroundStyleType = .custom
        updateViews()
    }

    func setup(item: PopupMenuTemplateItem) {
        guard let item = item as? PopupMenuItem else {
            assertionFailure("Invalid item type for cell.")
            return
        }

        item.tokenSet.customViewSize = { self.customViewSize }
        self.item = item

        _imageView.image = item.image
        _imageView.highlightedImage = item.selectedImage
        accessoryImageView.image = item.accessoryImage
        accessoryImageView.isHidden = _imageView.image == nil || accessoryImageView.image == nil

        setup(title: item.title, subtitle: item.subtitle ?? "", customView: _imageView.image != nil ? _imageView : nil, customAccessoryView: item.accessoryView)
        isEnabled = item.isEnabled

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

        updateColors()

        _imageView.isHighlighted = isSelected
    }

    private func updateColors() {
        guard let item = item else {
            _accessoryType = .none
            return
        }
        let selectedColor = Compatibility.isDeviceIdiomVision() ? .white : item.tokenSet[.brandTextColor].uiColor
        let imageColor: UIColor
        let titleColor: UIColor
        let subtitleColor: UIColor
        var accessoryType: TableViewCellAccessoryType = .none
        if isSelected {
            imageColor = item.imageSelectedColor ?? selectedColor
            titleColor = item.titleSelectedColor ?? selectedColor
            subtitleColor = item.subtitleSelectedColor ?? selectedColor
            if item.isAccessoryCheckmarkVisible {
                accessoryType = .checkmark
            }
        } else {
            imageColor = item.imageColor
            titleColor = item.titleColor
            subtitleColor = item.subtitleColor
        }

        _imageView.tintColor = imageColor
        titleLabel.textColor = titleColor
        subtitleLabel.textColor = subtitleColor
        backgroundColor = item.backgroundColor
        _accessoryType = accessoryType
        if let accessoryTypeView = accessoryTypeView {
            accessoryTypeView.customTintColor = item.accessoryCheckmarkColor ?? selectedColor
        }
    }
}
