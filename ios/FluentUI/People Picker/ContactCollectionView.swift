//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFContactCollectionView)
open class ContactCollectionView: UICollectionView {
    struct Constants {
        static let sideInset: CGFloat = 16.0
        static let extraSmallContentContactHeight: CGFloat = 115.0
        static let smallContentContactHeight: CGFloat = 117.0
        static let mediumContentContactHeight: CGFloat = 118.0
        static let largeContentContactHeight: CGFloat = 121.0
        static let extraLargeContentContactHeight: CGFloat = 125.0
        static let extraExtraLargeContentContactHeight: CGFloat = 129.0
        static let extraExtraExtraLargeContentContactHeight: CGFloat = 135.0
    }

    let layout: ContactCollectionViewLayout
    @objc public weak var contactCollectionDelegate: UICollectionViewDelegate?

    @objc public var contactList: [PersonaData] = [] {
        didSet {
            if (oldValue.count == 0 && contactList.count > 0) || (oldValue.count > 0 && contactList.count == 0) {
                setupConstraints()
            }
        }
    }

    @objc public init() {
        layout = ContactCollectionViewLayout()
        layout.scrollDirection = .horizontal
        contactList = [PersonaData]()

        super.init(frame: .zero, collectionViewLayout: layout)
        configureCollectionView()

        register(ContactCollectionViewCell.self, forCellWithReuseIdentifier: ContactCollectionViewCell.identifier)
        setupConstraints()
    }

    public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    var heightConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    private func setupConstraints() {
        if heightConstraint == nil {
            heightConstraint = heightAnchor.constraint(equalToConstant: 0.0)
            heightConstraint!.isActive = true
            return
        }

        var constant: CGFloat = 0.0
        if contactList.count > 0 {
            let indexPath = IndexPath(item: 0, section: 0)
            // NOTE: Why doesn't calling this after setting the .scrollDirection make the collection no longer scrollable?
            constant = layout.collectionView(self, layout: layout, sizeForItemAt: indexPath).height
        }

        print("collectionView.contentSize: \(contentSize)")
        heightConstraint!.constant = constant
    }

    private func configureCollectionView() {
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
//        backgroundColor = .green
        backgroundColor = Colors.surfacePrimary
        dataSource = self
        delegate = self
        contentInset = UIEdgeInsets(top: 0, left: Constants.sideInset, bottom: 0, right: 0)
    }

    // If the Contact is not fully visible in the scroll frame, scrolls the view by an offset large enough so that the entire Contact and the next Contact are fully visible.
    private func scrollContactToVisible(at indexPath: IndexPath) {
        guard let cell = cellForItem(at: indexPath) else {
            return
        }

        let cellWidth = cell.frame.width
        let cellFrame = cell.contentView.convert(cell.bounds, to: self)
        let cellLeftPosition = cellFrame.origin.x
        let cellRightPosition = cellLeftPosition + cellWidth
        let viewLeadingPosition = bounds.origin.x
        let viewTrailingPosition = viewLeadingPosition + frame.size.width

        let extraScrollWidth = cellWidth + layout.collectionView(self, layout: layout, minimumLineSpacingForSectionAt: 0)
        var offSet = contentOffset.x
        if cellLeftPosition < viewLeadingPosition {
            offSet = cellLeftPosition - extraScrollWidth
            offSet = max(offSet, -Constants.sideInset)
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

extension ContactCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contactList.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactCollectionViewCell.identifier, for: indexPath) as! ContactCollectionViewCell
        cell.setup(contact: contactList[indexPath.item])
        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)

        return cell
    }
}

extension ContactCollectionView: UICollectionViewDelegate {
    // Perhaps something to do with highlighting (even though I already have something similar in ContactView.swift) later on
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("item \(indexPath.item) at section \(indexPath.section) selected in collection view")
        scrollContactToVisible(at: indexPath)
    }
}
