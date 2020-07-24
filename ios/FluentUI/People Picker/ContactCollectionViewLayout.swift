//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class ContactCollectionViewLayout: UICollectionViewFlowLayout {
    @objc weak var delegate: UICollectionViewDelegateFlowLayout?

    struct Constants {
        static let itemWidth: CGFloat = 70.0

        static let extraSmallContentContactHeight: CGFloat = 115.0
        static let smallContentContactHeight: CGFloat = 117.0
        static let mediumContentContactHeight: CGFloat = 118.0
        static let largeContentContactHeight: CGFloat = 121.0
        static let extraLargeContentContactHeight: CGFloat = 125.0
        static let extraExtraLargeContentContactHeight: CGFloat = 129.0
        static let extraExtraExtraLargeContentContactHeight: CGFloat = 135.0
    }

    override init() {
        super.init()
        delegate = self
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) not implemented")
    }

    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }

        if let minLineSpacing = delegate?.collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: 0) {
            minimumLineSpacing = minLineSpacing
        }

        let indexPath = IndexPath(item: 0, section: 0)
        let numItems = collectionView.numberOfItems(inSection: 0)
        let height = delegate?.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath).height
        let totalWidth = numItems > 0 ? CGFloat(numItems) * Constants.itemWidth + (CGFloat(numItems) - 1) * minimumLineSpacing : 0.0

        let size = CGSize(width: totalWidth, height: height!)
        print("totalWidth: \(totalWidth)")
        print("height: \(height!)")
        collectionView.contentSize = size

        return size
    }

    // Called periodically by the collection view when it needs to decide what should be on the visible screen
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()

        guard numSections == 1 else {
            return layoutAttributes
        }

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
        let frame = CGRect(x: CGFloat(indexPath.item) * Constants.itemWidth + CGFloat(indexPath.item) * minimumLineSpacing, y: 0, width: Constants.itemWidth, height: itemSize.height)
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

        // TODO: Figure out why we pass in newBounds here
        return super.shouldInvalidateLayout(forBoundsChange: newBounds)
    }

    private var numSections: Int = 0
    private var numberOfItems: Int = 0

    // 1) Called whenever the layout is invalidated
    // For a FlowLayout, invalidated when the collection view bounds changes (resized / rotated)
    // Want it to be a function of the collectionView width
    // 2) Need to cache UICollectionViewLayouAttribute's
    // 3) Needs to compute the collectionViewContentSize
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }

        numSections = 1

        let indexPath = IndexPath(item: 0, section: 0)
        if let size = delegate?.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) {
            itemSize = size
        }
    }
}

extension ContactCollectionViewLayout: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // TODO: Will need to change this when the number of Contacts line up perfectly to the screen
        return 16.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight: CGFloat

        switch UIApplication.shared.preferredContentSizeCategory {
        case .extraSmall:
            itemHeight = Constants.extraSmallContentContactHeight
        case .small:
            itemHeight = Constants.smallContentContactHeight
        case .medium:
            itemHeight = Constants.mediumContentContactHeight
        case .large:
            itemHeight = Constants.largeContentContactHeight
        case .extraLarge:
            itemHeight = Constants.extraLargeContentContactHeight
        case .extraExtraLarge:
            itemHeight = Constants.extraExtraLargeContentContactHeight
        case .extraExtraExtraLarge:
            itemHeight = Constants.extraExtraExtraLargeContentContactHeight
        default:
            itemHeight = Constants.extraExtraExtraLargeContentContactHeight
        }

        return CGSize(width: Constants.itemWidth, height: itemHeight)
    }
}
