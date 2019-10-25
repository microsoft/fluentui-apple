//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import OfficeUIFabric
import ObjectiveC

// MARK: MSCollectionViewCellShimmerDemoController

class MSCollectionViewCellShimmerDemoController: MSCollectionViewCellDemoController {
    let shimmerSynchronizer = MSAnimationSynchronizer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // disable selection on the shimmer view
        navigationItem.rightBarButtonItem = nil
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        let item = section.item

        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! MSCollectionViewCell

        // fill with spaces representing the text that would go in each cell
        // double the character count because spaces take up much less horizontal space than
        // non-space characters in most fonts
        cell.cellView.setup(
            title: String(repeating: " ", count: item.text1.count * 2),
            subtitle: String(repeating: " ", count: item.text2.count * 2),
            footer: String(repeating: " ", count: item.text3.count * 2),
            customView: UIView()
        )

        cell.shimmer(synchronizer: shimmerSynchronizer)

        return cell
    }
}

// MARK: MSCollectionViewCell

extension MSCollectionViewCell {
    /// associated object key for shimmer view
    private static var shimmerViewKey: UInt8 = 0

    var shimmerView: MSShimmerView? {
        get {
            return objc_getAssociatedObject(self, &MSCollectionViewCell.shimmerViewKey) as? MSShimmerView
        }
        set {
            objc_setAssociatedObject(self, &MSCollectionViewCell.shimmerViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }

    /// Start or reset the shimmer
    func shimmer(synchronizer: MSAnimationSynchronizerProtocol) {
        // because the cells have different layouts in this example, remove and re-add the shimmers
        shimmerView?.removeFromSuperview()

        let shimmerView = MSShimmerView(containerView: cellView.contentView, animationSynchronizer: synchronizer)
        cellView.contentView.addSubview(shimmerView)
        shimmerView.fitIntoSuperview()
        self.shimmerView = shimmerView
    }
}
