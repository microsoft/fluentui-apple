//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import Foundation

// MARK: MSCalendarViewLayoutDelegate

protocol MSCalendarViewLayoutDelegate: class {
    func calendarViewLayout(_ calendarViewLayout: MSCalendarViewLayout, shouldShowMonthBannerForSectionIndex sectionIndex: Int) -> Bool
}

// MARK: - MSCalendarViewLayout

class MSCalendarViewLayout: UICollectionViewLayout {
    private struct Constants {
        static let itemHeight: CGFloat = 48.0
    }

    private enum LayoutZIndex: Int {
        case item = 1
        case monthBanner = 2
        // Higher Z indexes appear on top
    }

    static let preferredItemHeight = Constants.itemHeight

    weak var delegate: MSCalendarViewLayoutDelegate?

    private var numberOfSections: Int = 0
    private var itemSize = CGSize.zero

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else {
            return
        }

        numberOfSections = collectionView.dataSource?.numberOfSections?(in: collectionView) ?? 0

        let itemWidth = UIScreen.main.roundToDevicePixels(collectionView.bounds.size.width / 7.0)
        let itemHeight = Constants.itemHeight
        itemSize = CGSize(width: itemWidth, height: itemHeight)
    }

    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: CGFloat(numberOfSections) * itemSize.height)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()

        guard numberOfSections != 0 else {
            return layoutAttributes
        }

        // Calculate visible index path ranges (inclusive)
        var sectionStartIndex = Int(floor(rect.origin.y / itemSize.height))
        sectionStartIndex = min(max(sectionStartIndex, 0), numberOfSections - 1)

        var sectionEndIndex = Int(ceil(rect.maxY / itemSize.height) - 1)
        sectionEndIndex = min(max(sectionEndIndex, 0), numberOfSections - 1)

        // Calculate layout attributes for items in index path range
        for sectionIndex in sectionStartIndex...sectionEndIndex {
            for itemIndex in 0...6 {
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)

                if let attributes = layoutAttributesForItem(at: indexPath) {
                    layoutAttributes.append(attributes)
                }
            }
        }

        // Calculate layout attributes for month banners in section index range
        for sectionIndex in sectionStartIndex...sectionEndIndex {
            if delegate?.calendarViewLayout(self, shouldShowMonthBannerForSectionIndex: sectionIndex) == true {
                let indexPath = IndexPath(item: 0, section: sectionIndex)

                if let attributes = layoutAttributesForSupplementaryView(ofKind: MSCalendarViewMonthBannerView.supplementaryElementKind, at: indexPath) {
                    layoutAttributes.append(attributes)
                }
            }
        }

        return layoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = CGRect(x: CGFloat(indexPath.item) * itemSize.width, y: CGFloat(indexPath.section) * itemSize.height, width: itemSize.width, height: itemSize.height)
        attributes.zIndex = LayoutZIndex.item.rawValue
        return attributes
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == MSCalendarViewMonthBannerView.supplementaryElementKind {
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
            attributes.frame = CGRect(x: 0.0, y: CGFloat(indexPath.section) * itemSize.height, width: 7.0 * itemSize.width, height: itemSize.height)
            attributes.zIndex = LayoutZIndex.monthBanner.rawValue
            return attributes
        } else {
            return nil
        }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if let collectionView = collectionView, newBounds.size != collectionView.bounds.size {
            // Trigger invalidation to reposition everything
            return true
        }
        return super.shouldInvalidateLayout(forBoundsChange: newBounds)
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        func roundDownToInterval(_ value: CGFloat, _ interval: CGFloat) -> CGFloat {
            return floor(value / interval) * interval
        }

        func roundUpToInterval(_ value: CGFloat, _ interval: CGFloat) -> CGFloat {
            return ceil(value / interval) * interval
        }

        func roundToInterval(_ value: CGFloat, _ interval: CGFloat) -> CGFloat {
            if (value.truncatingRemainder(dividingBy: interval)) < (interval / 2.0) {
                return roundDownToInterval(value, interval)
            } else {
                return roundUpToInterval(value, interval)
            }
        }

        var targetContentOffset = proposedContentOffset

        if velocity.y < 0.0 {
            // Snap up to previous section
            targetContentOffset.y = roundDownToInterval(targetContentOffset.y, itemSize.height)
        } else if velocity.x == 0.0 {
            // Snap rounded to nearest section
            targetContentOffset.y = roundToInterval(targetContentOffset.y, itemSize.height)
        } else {
            // Snap down to next section
            targetContentOffset.y = roundUpToInterval(targetContentOffset.y, itemSize.height)
        }

        return targetContentOffset
    }
}
