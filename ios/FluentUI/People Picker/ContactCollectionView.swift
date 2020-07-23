//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFContactCollectionView)
open class ContactCollectionView: UICollectionView {
    struct Constants {
        static let extraSmallContentContactHeight: CGFloat = 115.0
        static let smallContentContactHeight: CGFloat = 117.0
        static let mediumContentContactHeight: CGFloat = 118.0
        static let largeContentContactHeight: CGFloat = 121.0
        static let extraLargeContentContactHeight: CGFloat = 125.0
        static let extraExtraLargeContentContactHeight: CGFloat = 129.0
        static let extraExtraExtraLargeContentContactHeight: CGFloat = 135.0
    }

    @objc public var contactList: [PersonaData] = [] {
        didSet {
            if (oldValue.count == 0 && contactList.count > 0) || (oldValue.count > 0 && contactList.count == 0) {
                setupConstraints()
            }
        }
    }

    let layout: ContactCollectionViewLayout
    @objc public weak var contactCollectionDelegate: UICollectionViewDelegate?

    @objc public init() {
        layout = ContactCollectionViewLayout()
        layout.scrollDirection = .horizontal
        contactList = [PersonaData]()

        super.init(frame: .zero, collectionViewLayout: layout)

        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        backgroundColor = .green
        dataSource = self
//        delegate = self
        layout.delegate = self

        register(ContactCollectionViewCell.self, forCellWithReuseIdentifier: ContactCollectionViewCell.identifier)
        setupConstraints()
    }

    public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    var heightConstraint: NSLayoutConstraint?
    private func setupConstraints() {
        if heightConstraint == nil {
            heightConstraint = heightAnchor.constraint(equalToConstant: 0)
            heightConstraint!.isActive = true
            return
        }

        var constant: CGFloat = 0.0
        if contactList.count > 0 {
            let indexPath = IndexPath(item: 0, section: 0)
            // NOTE: Why doesn't calling this after setting the .scrollDirection make the collection no longer scrollable?
            constant = collectionView(self, layout: layout, sizeForItemAt: indexPath).height
//            constant = layout.collectionView(self, layout: layout, sizeForItemAt: indexPath).height
        }
        widthAnchor.constraint(equalToConstant: layout.collectionViewContentSize.width).isActive = true
        heightConstraint!.constant = constant
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
    // It doesn't seem like I need to implement any of the functions in UICollectionViewDelegate
    // Perhaps something to do with highlighting (even though I already have something similar in ContactView.swift) later on
}

extension ContactCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // TODO: Will need to change this when the number of Contacts line up perfectly to the screen
        return 16.0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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

        return CGSize(width: 70.0, height: itemHeight)
    }
}
