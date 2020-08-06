//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFContactCollectionView)
open class ContactCollectionView: UICollectionView {
    @objc public init() {
        layout = ContactCollectionViewLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        configureCollectionView()
        setupHeightConstraint()
        register(ContactCollectionViewCell.self, forCellWithReuseIdentifier: ContactCollectionViewCell.identifier)
        NotificationCenter.default.addObserver(self, selector: #selector(setupHeightConstraint), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }

    @objc public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    // The array of PersonaData which is used to create each ContactView. The height constraint of the ContactCollectionView is updated when the count increases from 0 or decreases to 0.
    @objc public var contactList: [PersonaData] = [] {
        didSet {
            if (oldValue.count == 0 && contactList.count > 0) || (oldValue.count > 0 && contactList.count == 0) {
                setupHeightConstraint()
            }
        }
    }

    struct Constants {
        static let leadingInset: CGFloat = 16.0
        static let extraSmallContentContactHeight: CGFloat = 115.0
        static let smallContentContactHeight: CGFloat = 117.0
        static let mediumContentContactHeight: CGFloat = 118.0
        static let largeContentContactHeight: CGFloat = 121.0
        static let extraLargeContentContactHeight: CGFloat = 125.0
        static let extraExtraLargeContentContactHeight: CGFloat = 129.0
        static let extraExtraExtraLargeContentContactHeight: CGFloat = 135.0
    }

    let layout: ContactCollectionViewLayout
    var widthConstraint: NSLayoutConstraint?
    lazy var heightConstraint: NSLayoutConstraint = {
        let heightConstraint = heightAnchor.constraint(equalToConstant: 0.0)
        heightConstraint.isActive = true
        return heightConstraint
    }()

    private func configureCollectionView() {
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        backgroundColor = Colors.surfacePrimary
        dataSource = self
        delegate = self
        contentInset = UIEdgeInsets(top: 0, left: Constants.leadingInset, bottom: 0, right: 0)

        if #available(iOS 13, *) {
            addInteraction(UILargeContentViewerInteraction())
        }
    }

    @objc private func setupHeightConstraint() {
        let height = (contactList.count > 0) ? UIApplication.shared.preferredContentSizeCategory.contactHeight : 0
        heightConstraint.constant = height
    }
}

extension ContactCollectionView: UICollectionViewDataSource {
    @objc public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contactList.count
    }

    @objc public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactCollectionViewCell.identifier, for: indexPath) as! ContactCollectionViewCell
        cell.setup(contact: contactList[indexPath.item])

        return cell
    }
}

extension ContactCollectionView: UICollectionViewDelegate {
    // If the Contact is not fully visible in the scroll frame, scrolls the view by an offset large enough
    // so that the tapped Contact is fully visible.
    @objc public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = cellForItem(at: indexPath) else {
            return
        }

        let cellWidth = cell.frame.width
        let cellFrame = cell.contentView.convert(cell.bounds, to: self)
        let cellLeftPosition = cellFrame.origin.x
        let cellRightPosition = cellLeftPosition + cellWidth
        let viewLeadingPosition = bounds.origin.x
        let viewTrailingPosition = viewLeadingPosition + frame.size.width

        let extraScrollWidth = layout.collectionView(self, layout: layout, minimumLineSpacingForSectionAt: 0)
        var offSet = contentOffset.x
        if cellLeftPosition < viewLeadingPosition {
            offSet = cellLeftPosition - extraScrollWidth
            offSet = max(offSet, -Constants.leadingInset)
        } else if cellRightPosition > viewTrailingPosition {
            let maxOffsetX = contentSize.width - frame.size.width + extraScrollWidth
            offSet = cellRightPosition - frame.size.width + extraScrollWidth
            offSet = min(offSet, maxOffsetX)
        }

        if offSet != contentOffset.x {
            setContentOffset(CGPoint(x: offSet, y: contentOffset.y), animated: true)
        }
    }
}

extension UIContentSizeCategory {
    var contactHeight: CGFloat {
        switch self {
        case .extraSmall:
            return ContactCollectionView.Constants.extraSmallContentContactHeight
        case .small:
            return ContactCollectionView.Constants.smallContentContactHeight
        case .medium:
            return ContactCollectionView.Constants.mediumContentContactHeight
        case .large:
            return ContactCollectionView.Constants.largeContentContactHeight
        case .extraLarge:
            return ContactCollectionView.Constants.extraLargeContentContactHeight
        case .extraExtraLarge:
            return ContactCollectionView.Constants.extraExtraLargeContentContactHeight
        case .extraExtraExtraLarge:
            return ContactCollectionView.Constants.extraExtraExtraLargeContentContactHeight
        default:
            return ContactCollectionView.Constants.extraExtraExtraLargeContentContactHeight
        }
    }
}
