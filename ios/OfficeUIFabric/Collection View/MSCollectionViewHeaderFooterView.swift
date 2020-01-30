//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSCollectionViewHeaderFooterView

/**
 `MSCollectionViewHeaderFooterView` is a wrapper for `MSTableViewHeaderFooterView` retaining all of the functionality of `MSTableViewHeaderFooterView` for use in a collection view.

 Use `headerFooterView` to call the `MSTableViewHeaderFooterView` `setup` method to set up the view and to perform any further customization using `MSTableViewHeaderFooterView` APIs.
 */
open class MSCollectionViewHeaderFooterView: UICollectionReusableView {
    @objc public static var identifier: String { return String(describing: self) }

    @objc public let headerFooterView = MSTableViewHeaderFooterView()

    open override var intrinsicContentSize: CGSize { return headerFooterView.intrinsicContentSize }

    open override var layer: CALayer {
        let layer = super.layer
        // Fixes an issue where the header will appear above the scroll indicator
        layer.zPosition = 0
        return layer
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
        addSubview(headerFooterView)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        headerFooterView.frame = bounds
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return headerFooterView.sizeThatFits(size)
    }
}
