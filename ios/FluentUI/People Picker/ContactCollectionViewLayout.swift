//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class ContactCollectionViewLayout: UICollectionViewFlowLayout {
    struct Constants {
        static let itemWidth: CGFloat = 70.0
        static let minLineSpacing: CGFloat = 14.0
        static let maxLineSpacing: CGFloat = 16.0
    }

    override init() {
        super.init()
        minimumLineSpacing = Constants.maxLineSpacing
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) not implemented")
    }

    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }

        minimumLineSpacing = minimumLineSpacingForSectionAt(section: 0)

        let indexPath = IndexPath(item: 0, section: 0)
        let numItems = collectionView.numberOfItems(inSection: 0)
        let height = sizeForItemAt(indexPath: indexPath).height
        let totalWidth = numItems > 0 ? CGFloat(numItems) * Constants.itemWidth + (CGFloat(numItems) - 1) * minimumLineSpacing : 0.0

        let size = CGSize(width: totalWidth, height: height)
        return size
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        var numberOfItems = 0

        if let collectionView = collectionView {
            numberOfItems = collectionView.numberOfItems(inSection: 0)
        }

        for itemIndex in 0..<numberOfItems {
            let indexPath = IndexPath(item: itemIndex, section: 0)
            if let attributes = layoutAttributesForItem(at: indexPath) {
                if attributes.frame.intersects(rect) {
                    layoutAttributes.append(attributes)
                }
            }
        }

        return layoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let frame = CGRect(x: CGFloat(indexPath.item) * Constants.itemWidth + CGFloat(indexPath.item) * minimumLineSpacing,
                           y: 0,
                           width: Constants.itemWidth,
                           height: itemSize.height)
        attributes.frame = frame

        if let collectionView = collectionView {
            attributes.frame = collectionView.flipRectForRTL(attributes.frame)
        }
        return attributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if let collectionView = collectionView, newBounds.size != collectionView.bounds.size {
            return true
        }

        return super.shouldInvalidateLayout(forBoundsChange: newBounds)
    }

    override func prepare() {
        let indexPath = IndexPath(item: 0, section: 0)
        itemSize = sizeForItemAt(indexPath: indexPath)
    }

    private func calculateMinimumLineSpacing() {
        guard let collectionView = collectionView else {
            return
        }

        let usableWidth = Int(collectionView.frame.width - collectionView.contentInset.left)

        if usableWidth % Int(Constants.itemWidth + minimumLineSpacing) == Int(Constants.itemWidth) {
            minimumLineSpacing = Constants.minLineSpacing
        } else {
            minimumLineSpacing = Constants.maxLineSpacing
        }
    }

    public func minimumLineSpacingForSectionAt(section: Int) -> CGFloat {
        calculateMinimumLineSpacing()
        return minimumLineSpacing
    }

    private func sizeForItemAt(indexPath: IndexPath) -> CGSize {
        let itemHeight = UIApplication.shared.preferredContentSizeCategory.contactHeight
        return CGSize(width: Constants.itemWidth, height: itemHeight)
    }
}
