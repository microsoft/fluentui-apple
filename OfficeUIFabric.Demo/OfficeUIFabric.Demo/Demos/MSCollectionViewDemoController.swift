//
//  Copyright © 2019 Microsoft Corporation. All rights reserved.
//

import Foundation
import OfficeUIFabric

// MARK: MSCollectionViewHeader

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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: MSCollectionViewHeader.height)
    }

    override func layoutSubviews() {
        let horizontalOffset: CGFloat = 16
        let bottomOffset: CGFloat = 8
        let labelHeight = label.font.deviceLineHeight
        label.frame = CGRect(
            x: horizontalOffset,
            y: MSCollectionViewHeader.height - labelHeight - bottomOffset,
            width: bounds.width - horizontalOffset,
            height: labelHeight
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = ""
    }
}

// MARK: - MSCollectionViewDemoController

class MSCollectionViewDemoController: DemoController {
    static let cellIdentifier: String = "MSCollectionViewCell"

    private let sections: [MSTableViewSampleData.Section] = MSTableViewSampleData.sections

    override func viewDidLoad() {
        super.viewDidLoad()

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: MSCollectionViewDemoController.cellIdentifier)
        collectionView.register(MSCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MSCollectionViewHeader.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = MSColors.background
        view.addSubview(collectionView)

        NotificationCenter.default.addObserver(forName: UIContentSizeCategory.didChangeNotification, object: nil, queue: nil) { _ in
            collectionView.collectionViewLayout.invalidateLayout()
        }
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
        let item = sections[indexPath.section].item

        // Demo accessory types based on indexPath row
        let accessoryType: MSTableViewCellAccessoryType
        switch indexPath.row {
        case 0:
            accessoryType = .none
        case 1:
            accessoryType = .disclosureIndicator
        default:
            accessoryType = .detailButton
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MSCollectionViewDemoController.cellIdentifier, for: indexPath)
        cell.contentView.subviews.forEach({ $0.removeFromSuperview() })

        let tableViewCell = MSTableViewCell()
        tableViewCell.setup(title: item.title, subtitle: item.subtitle, footer: item.footer, customView: createCustomView(imageName: item.image), accessoryType: accessoryType)
        cell.contentView.addSubview(tableViewCell)
        tableViewCell.fitIntoSuperview()
        tableViewCell.onAccessoryTapped = { [unowned self] in self.showAlertForDetailButtonTapped(title: item.title) }
        tableViewCell.onSelected = { collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath) }

        // Add and adjust cell separator based on position of customView
        let separator = MSSeparator(style: .default, orientation: .horizontal)
        separator.frame = CGRect(
            x: tableViewCell.separatorInset.left,
            y: cell.contentView.height - separator.height,
            width: cell.contentView.width - tableViewCell.separatorInset.left,
            height: separator.height
        )
        separator.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        cell.contentView.addSubview(separator)

        return cell
    }

    private func createCustomView(imageName: String) -> UIImageView? {
        if imageName == "" {
            return nil
        }

        let customView = UIImageView(image: UIImage(named: imageName))
        customView.contentMode = .scaleAspectFit
        return customView
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.width, height: MSCollectionViewHeader.height)
    }

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

// MARK: - MSCollectionViewDemoController: UICollectionViewDelegateFlowLayout

extension MSCollectionViewDemoController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = sections[indexPath.section].item
        return CGSize(
            width: collectionView.width,
            height: MSTableViewCell.height(title: item.title, subtitle: item.subtitle, footer: item.footer)
        )
    }
}
