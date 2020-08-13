//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: ContactCollectionViewDelegate

public typealias MSContactCollectionViewDelegate = ContactCollectionViewDelegate
@objc public protocol ContactCollectionViewDelegate: AnyObject {
    @objc optional func didTapOnContactViewAtIndex(index: Int, personaData: PersonaData)
}

// MARK: ContactCollectionView

@objc(MSFContactCollectionView)
open class ContactCollectionView: UICollectionView {

    /// Initializes the collection view by setting the layout, constraints, and cell to be used.
    ///
    /// - Parameters:
    ///   - personaData: Array of PersonaData used to create each individual ContactView
    @objc public init(personaData: [PersonaData] = []) {
        layout = ContactCollectionViewLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)

        if personaData.count > 0 {
            contactList = personaData
        }

        heightConstraint.isActive = true
        configureCollectionView()
        setupHeightConstraint()
        register(ContactCollectionViewCell.self, forCellWithReuseIdentifier: ContactCollectionViewCell.identifier)
        NotificationCenter.default.addObserver(self, selector: #selector(setupHeightConstraint), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }

    @objc public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// The array of PersonaData which is used to create each ContactView.
    /// The height constraint of the ContactCollectionView is updated when the count increases from 0 or decreases to 0.
    @objc public var contactList: [PersonaData] = [] {
        didSet {
            if (oldValue.count == 0 && contactList.count > 0) || (oldValue.count > 0 && contactList.count == 0) {
                setupHeightConstraint()
            }
        }
    }

    open weak var contactCollectionViewDelegate: ContactCollectionViewDelegate?

    private func configureCollectionView() {
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        backgroundColor = Colors.surfacePrimary
        dataSource = self
        contentInset = UIEdgeInsets(top: 0, left: Constants.leadingInset, bottom: 0, right: 0)
    }

    @objc private func setupHeightConstraint() {
        let height = (contactList.count > 0) ? UIApplication.shared.preferredContentSizeCategory.contactHeight : 0
        heightConstraint.constant = height
    }

    /// If the Contact is not fully visible in the scroll frame, scrolls the view by an offset large enough
    /// so that the tapped Contact is fully visible as well as 20px of the next Contact.
    private func scrollToContact(at indexPath: IndexPath) {
        guard let cell = cellForItem(at: indexPath) else {
            return
        }

        let cellWidth = cell.frame.width
        let cellFrame = cell.contentView.convert(cell.bounds, to: self)
        let cellLeftPosition = cellFrame.origin.x
        let cellRightPosition = cellLeftPosition + cellWidth
        let viewLeadingPosition = bounds.origin.x
        let viewTrailingPosition = viewLeadingPosition + frame.size.width

        let extraScrollWidth = layout.minimumLineSpacingForSectionAt(section: 0) + Constants.amountOfNextContactToShow
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

    private struct Constants {
        static let leadingInset: CGFloat = 16.0
        static let amountOfNextContactToShow: CGFloat = 20.0
    }

    private let layout: ContactCollectionViewLayout
    private var widthConstraint: NSLayoutConstraint?
    private lazy var heightConstraint: NSLayoutConstraint = {
        let heightConstraint = heightAnchor.constraint(equalToConstant: 0.0)
        return heightConstraint
    }()
    private var contactViewToIndexMap: [ContactView: Int] = [:]
}

extension ContactCollectionView: ContactViewDelegate {
    public func didTapContactView(_ contact: ContactView) {
        if let contactCollectionViewDelegate = contactCollectionViewDelegate, let currentTappedIndex = contactViewToIndexMap[contact] {
            let indexPath = IndexPath(item: currentTappedIndex, section: 0)
            scrollToContact(at: indexPath)
            contactCollectionViewDelegate.didTapOnContactViewAtIndex?(index: currentTappedIndex, personaData: contactList[currentTappedIndex])
        }
    }
}

extension ContactCollectionView: UICollectionViewDataSource {
    @objc public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contactList.count
    }

    @objc public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactCollectionViewCell.identifier, for: indexPath) as! ContactCollectionViewCell
        cell.setup(contact: contactList[indexPath.item])
        cell.contactView.contactViewDelegate = self
        contactViewToIndexMap[cell.contactView] = indexPath.item

        return cell
    }
}

extension UIContentSizeCategory {
    var contactHeight: CGFloat {
        switch self {
        case .extraSmall:
            return 115.0
        case .small:
            return 117.0
        case .medium:
            return 118.0
        case .large:
            return 121.0
        case .extraLarge:
            return 125.0
        case .extraExtraLarge:
            return 129.0
        case .extraExtraExtraLarge, .accessibilityMedium,
             .accessibilityLarge, .accessibilityExtraLarge,
             .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return 135.0
        default:
            return 135.0
        }
    }
}
