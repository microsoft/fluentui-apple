//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import OfficeUIFabric

// MARK: CollectionViewSectionHeader

class CollectionViewSectionHeader: UICollectionReusableView {
    static let height: CGFloat = 50
    static var identifier: String { return String(describing: self) }

    var title: String = "" {
        didSet {
            label.text = title
            setNeedsLayout()
        }
    }

    private let label: MSLabel = {
        let label = MSLabel(style: .footnote)
        label.textColor = MSColors.darkGray
        label.autoresizingMask = .flexibleWidth
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let horizontalOffset: CGFloat = 16
        let bottomOffset: CGFloat = 8
        let labelHeight = label.font.deviceLineHeight
        label.frame = CGRect(
            x: horizontalOffset + safeAreaInsetsIfAvailable.left,
            y: CollectionViewSectionHeader.height - labelHeight - bottomOffset,
            width: bounds.width - horizontalOffset - safeAreaInsetsIfAvailable.left,
            height: labelHeight
        )
    }
}
