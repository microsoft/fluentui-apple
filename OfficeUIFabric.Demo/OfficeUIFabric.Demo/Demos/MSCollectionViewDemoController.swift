//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import OfficeUIFabric

// MARK: MSCollectionViewCell

class MSCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "MSCollectionViewCell"

    private let separator = MSSeparator(style: .default, orientation: .horizontal)
    private let tableViewCell = MSTableViewCell()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(tableViewCell)
        tableViewCell.titleLineBreakMode = .byTruncatingMiddle

        contentView.addSubview(separator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(title: String, subtitle: String = "", footer: String = "", customView: UIView? = nil, customAccessoryView: UIView? = nil, accessoryType: MSTableViewCellAccessoryType = .none, numberOfLines: Int = 1, onAccessoryTapped: (() -> Void)? = nil, onSelected: (() -> Void)? = nil) {
        tableViewCell.setup(title: title, subtitle: subtitle, footer: footer, customView: customView, customAccessoryView: customAccessoryView, accessoryType: accessoryType)
        tableViewCell.titleNumberOfLines = numberOfLines
        tableViewCell.subtitleNumberOfLines = numberOfLines
        tableViewCell.footerNumberOfLines = numberOfLines
        tableViewCell.onAccessoryTapped = onAccessoryTapped
        tableViewCell.onSelected = onSelected
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        tableViewCell.frame = contentView.bounds
        separator.frame = CGRect(
            x: tableViewCell.separatorInset.left,
            y: contentView.height - separator.height,
            width: contentView.width - tableViewCell.separatorInset.left,
            height: separator.height
        )
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return tableViewCell.sizeThatFits(size)
    }
}

// MARK: - MSCollectionViewHeader

class MSCollectionViewHeader: UICollectionReusableView {
    static let height: CGFloat = 50
    static let identifier: String = "MSCollectionViewHeader"

    var title: String = "" {
        didSet {
            label.text = title
            setNeedsLayout()
        }
    }

    private let label: MSLabel = {
        let label = MSLabel(style: .footnote)
        label.textColor = MSColors.darkGray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let horizontalOffset: CGFloat = 16
        let bottomOffset: CGFloat = 8
        let labelHeight = label.font.deviceLineHeight
        label.frame = CGRect(
            x: horizontalOffset + safeAreaInsetsIfAvailable.left,
            y: MSCollectionViewHeader.height - labelHeight - bottomOffset,
            width: bounds.width - horizontalOffset - safeAreaInsetsIfAvailable.left,
            height: labelHeight
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - MSCollectionViewDemoController

class MSCollectionViewDemoController: DemoController {
    private let sections: [MSTableViewSampleData.Section] = MSTableViewSampleData.sections

    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(MSCollectionViewCell.self, forCellWithReuseIdentifier: MSCollectionViewCell.identifier)
        collectionView.register(MSCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MSCollectionViewHeader.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = MSColors.background
        view.addSubview(collectionView)

        NotificationCenter.default.addObserver(self, selector: #selector(handleContentSizeCategoryDidChange), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }

    override func viewWillLayoutSubviews() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            if #available(iOS 12, *) {
                flowLayout.estimatedItemSize = CGSize(width: view.width, height: MSTableViewCell.mediumHeight)
            } else {
                // Higher value of 100 needed for proper layout on iOS 11
                flowLayout.estimatedItemSize = CGSize(width: view.width, height: 100)
            }
            flowLayout.headerReferenceSize = CGSize(width: view.width, height: MSCollectionViewHeader.height)
        }
        super.viewWillLayoutSubviews()
    }

    @objc private func handleContentSizeCategoryDidChange() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - MSCollectionViewDemoController: UICollectionViewDataSource

extension MSCollectionViewDemoController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        let item = section.item

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MSCollectionViewCell.identifier, for: indexPath) as! MSCollectionViewCell
        cell.setup(
            title: item.title,
            subtitle: item.subtitle,
            footer: item.footer,
            customView: MSTableViewSampleData.createCustomView(imageName: item.image),
            customAccessoryView: section.hasAccessoryView ? MSTableViewSampleData.customAccessoryView : nil,
            accessoryType: MSTableViewSampleData.accessoryType(for: indexPath),
            numberOfLines: section.numberOfLines,
            onAccessoryTapped: { [unowned self] in self.showAlertForDetailButtonTapped(title: item.title) },
            onSelected: { collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath) }
        )

        return cell
    }

    private func showAlertForDetailButtonTapped(title: String) {
        let alert = UIAlertController(title: "\(title) detail button was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

// MARK: - MSCollectionViewDemoController: UICollectionViewDelegate

extension MSCollectionViewDemoController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MSCollectionViewHeader.identifier, for: indexPath) as! MSCollectionViewHeader
            header.title = sections[indexPath.section].title
            return header
        default:
            return UICollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
