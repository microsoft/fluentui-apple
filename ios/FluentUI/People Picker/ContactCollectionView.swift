//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: ContactCollectionViewDelegate

public typealias MSFContactCollectionViewDelegate = ContactCollectionViewDelegate

@objc(MSFContactCollectionViewDelegate)
public protocol ContactCollectionViewDelegate: AnyObject {
    @objc optional func didTapOnContactViewAtIndex(index: Int, personaData: PersonaData)
}

// MARK: ContactCollectionView

@objc(MSFContactCollectionView)
open class ContactCollectionView: UICollectionView {
    @objc(MSFContactCollectionViewSize)
    public enum Size: Int {
        case large
        case small

        var contactViewSize: ContactView.Size {
            switch self {
            case .large:
                return .large
            case .small:
                return .small
            }
        }

        var avatarSize: AvatarLegacySize {
            switch self {
            case .large:
                return .extraExtraLarge
            case .small:
                return .extraLarge
            }
        }

        var width: CGFloat {
            return contactViewSize.width
        }
    }

    /// The size of the collection view.
    @objc public let size: Size

    /// Initializes the collection view by setting the layout, constraints, and cell to be used.
    /// - Parameter size: The size of the collection view.
    /// - Parameter personas: Array of PersonaData used to create each individual ContactView.
    @objc public init(size: Size = .large, personas: [PersonaData] = []) {
        layout = ContactCollectionViewLayout(size: size)
        layout.scrollDirection = .horizontal
        self.size = size
        self.personas = personas
        super.init(frame: .zero, collectionViewLayout: layout)

        register(ContactCollectionViewCell.self, forCellWithReuseIdentifier: ContactCollectionViewCell.identifier)

        heightConstraint.isActive = true
        configureCollectionView()
        updateHeightConstraint()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sizeCategoryDidUpdate),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }

    @objc public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// The array of PersonaData which is used to create each ContactView.
    /// The height constraint of the ContactCollectionView is updated when the count increases from 0 or decreases to 0.
    @objc public var personas: [PersonaData] = [] {
        didSet {
            if (oldValue.count == 0 && personas.count > 0) || (oldValue.count > 0 && personas.count == 0) {
                updateHeightConstraint()
            }
        }
    }

    open weak var contactCollectionViewDelegate: ContactCollectionViewDelegate? {
        didSet {
            if oldValue == nil && contactCollectionViewDelegate != nil {
                let cells = visibleCells as? [ContactCollectionViewCell]
                for cell in cells ?? [] {
                    cell.contactView?.contactViewDelegate = self
                }
            }
        }
    }

    private func configureCollectionView() {
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        backgroundColor = Colors.surfacePrimary
        dataSource = self
        contentInset = UIEdgeInsets(top: Constants.verticalInset, left: Constants.horizontalInset, bottom: Constants.verticalInset, right: Constants.horizontalInset)
    }

    @objc private func sizeCategoryDidUpdate() {
        updateHeightConstraint()
        reloadData()
    }

    @objc private func updateHeightConstraint() {
        let height = UIApplication.shared.preferredContentSizeCategory.contactHeight(size: size.contactViewSize) + 2 * Constants.verticalInset
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
            offSet = max(offSet, -Constants.horizontalInset)
        } else if cellRightPosition > viewTrailingPosition {
            let maxOffsetX = contentSize.width - frame.size.width + extraScrollWidth - Constants.horizontalInset
            offSet = cellRightPosition - frame.size.width + extraScrollWidth
            offSet = min(offSet, maxOffsetX)
        }

        if offSet != contentOffset.x {
            setContentOffset(CGPoint(x: offSet, y: contentOffset.y), animated: true)
        }
    }

    private struct Constants {
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 8
        static let amountOfNextContactToShow: CGFloat = 20
    }

    private let layout: ContactCollectionViewLayout

    private lazy var heightConstraint: NSLayoutConstraint = {
        return heightAnchor.constraint(equalToConstant: 0)
    }()

    private var contactViewToIndexMap: [ContactView: Int] = [:]
}

extension ContactCollectionView: ContactViewDelegate {
    public func didTapContactView(_ contact: ContactView) {
        if let contactCollectionViewDelegate = contactCollectionViewDelegate, let currentTappedIndex = contactViewToIndexMap[contact] {
            let indexPath = IndexPath(item: currentTappedIndex, section: 0)
            scrollToContact(at: indexPath)
            contactCollectionViewDelegate.didTapOnContactViewAtIndex?(index: currentTappedIndex, personaData: personas[currentTappedIndex])
        }
    }
}

extension ContactCollectionView: UICollectionViewDataSource {
    @objc public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return personas.count
    }

    @objc public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactCollectionViewCell.identifier, for: indexPath) as? ContactCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setup(contact: personas[indexPath.item], size: size.contactViewSize)

        if contactCollectionViewDelegate != nil {
            cell.contactView?.contactViewDelegate = self
        }

        contactViewToIndexMap[cell.contactView!] = indexPath.item

        return cell
    }
}

extension UIContentSizeCategory {
    func contactHeight(size: ContactView.Size) -> CGFloat {
        var height: CGFloat = 0

        switch self {
        case .extraSmall:
            height = 117
        case .small:
            height = 119
        case .medium:
            height = 120
        case .large:
            height = 123
        case .extraLarge:
            height = 127
        case .extraExtraLarge:
            height = 131
        case .extraExtraExtraLarge:
            height = 137
        case .accessibilityMedium:
            height = 141
        case .accessibilityLarge:
            height = 151
        case .accessibilityExtraLarge:
            height = 165
        case .accessibilityExtraExtraLarge:
            height = 178
        case .accessibilityExtraExtraExtraLarge:
            height = 194
        default:
            break
        }

        if size == .small {
            // Remove height for smaller size to compensate for the missing secondary label.
            height -= 38
        }

        return height
    }
}
