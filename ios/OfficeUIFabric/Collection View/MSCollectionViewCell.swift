//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSCollectionViewCell

/**
 `MSCollectionViewCell` is a wrapper for `MSTableViewCell` retaining all of the functionality of `MSTableViewCell` for use in a collection view.

 Use `cellView` to call the `MSTableViewCell` `setup` method to set up the cell and to perform any further customization using `MSTableViewCell` APIs.
 */
open class MSCollectionViewCell: UICollectionViewCell {
    @objc public static var identifier: String { return String(describing: self) }

    @objc public private(set) lazy var cellView: MSTableViewCell = {
        let cell = TableViewCell()
        cell.collectionViewCell = self
        return cell
    }()

    open override var isSelected: Bool {
        didSet {
            if isSelected != oldValue {
                cellView.setSelected(isSelected, animated: true)
            }
        }
    }

    open override var intrinsicContentSize: CGSize { return cellView.intrinsicContentSize }

    private var superCollectionView: UICollectionView? {
        return findSuperview(of: UICollectionView.self) as? UICollectionView
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    open func initialize() {
        contentView.addSubview(cellView)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        cellView.frame = contentView.bounds
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return cellView.sizeThatFits(size)
    }

    open override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        attributes.size.width = layoutAttributes.size.width
        return attributes
    }

    open func selectionDidChange() {
        guard let collectionView = superCollectionView, let indexPath = collectionView.indexPath(for: self) else {
            return
        }

        if cellView.isSelected {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
        } else {
            collectionView.deselectItem(at: indexPath, animated: true)
            collectionView.delegate?.collectionView?(collectionView, didDeselectItemAt: indexPath)
        }
    }

    private class TableViewCell: MSTableViewCell {
        weak var collectionViewCell: MSCollectionViewCell?

        override func selectionDidChange() {
            collectionViewCell?.selectionDidChange()
            super.selectionDidChange()
        }
    }
}
