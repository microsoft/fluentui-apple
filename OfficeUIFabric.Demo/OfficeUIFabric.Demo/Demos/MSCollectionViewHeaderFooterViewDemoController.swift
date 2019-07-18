//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import OfficeUIFabric

// MARK: MSCollectionViewHeaderFooterViewDemoController

class MSCollectionViewHeaderFooterViewDemoController: DemoController {
    private let groupedSections: [TableViewHeaderFooterSampleData.Section] = TableViewHeaderFooterSampleData.groupedSections
    private let plainSections: [TableViewHeaderFooterSampleData.Section] = TableViewHeaderFooterSampleData.plainSections

    private var groupedCollectionView: UICollectionView!
    private var plainCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MSColors.background2

        let groupedTitle = TableViewHeaderFooterSampleData.groupedTitle
        let plainTitle = TableViewHeaderFooterSampleData.plainTitle

        groupedCollectionView = createCollectionView(isPlainStyle: false)
        plainCollectionView = createCollectionView(isPlainStyle: true)

        container.addArrangedSubview(groupedTitle)
        container.addArrangedSubview(groupedCollectionView)
        container.addArrangedSubview(plainTitle)
        container.addArrangedSubview(plainCollectionView)

        groupedCollectionView.heightAnchor.constraint(equalTo: plainCollectionView.heightAnchor).isActive = true

        container.heightAnchor.constraint(equalTo: scrollingContainer.heightAnchor).isActive = true
        container.layoutMargins.left = 0
        container.layoutMargins.right = 0
        container.layoutMargins.bottom = 0

        NotificationCenter.default.addObserver(self, selector: #selector(handleContentSizeCategoryDidChange), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let collectionViews = [groupedCollectionView, plainCollectionView]
        let itemSize = CGSize(width: view.width, height: MSTableViewCell.height(title: TableViewHeaderFooterSampleData.itemTitle))
        collectionViews.forEach {
            if let flowLayout = $0?.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.itemSize = itemSize
            }
        }
    }

    func createCollectionView(isPlainStyle: Bool) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionHeadersPinToVisibleBounds = isPlainStyle
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MSCollectionViewCell.self, forCellWithReuseIdentifier: MSCollectionViewCell.identifier)
        collectionView.register(MSCollectionViewHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MSCollectionViewHeaderFooterView.identifier)
        collectionView.register(MSCollectionViewHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MSCollectionViewHeaderFooterView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = MSColors.Table.background
        return collectionView
    }

    @objc private func handleContentSizeCategoryDidChange() {
        groupedCollectionView.collectionViewLayout.invalidateLayout()
        plainCollectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - MSCollectionViewHeaderFooterViewDemoController: UICollectionViewDataSource

extension MSCollectionViewHeaderFooterViewDemoController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionView == groupedCollectionView ? groupedSections.count : plainSections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TableViewHeaderFooterSampleData.numberOfItemsInSection
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MSCollectionViewCell.identifier, for: indexPath) as! MSCollectionViewCell
        cell.cellView.setup(title: TableViewHeaderFooterSampleData.itemTitle)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = collectionView == groupedCollectionView ? groupedSections[indexPath.section] : plainSections[indexPath.section]
        let headerFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MSCollectionViewHeaderFooterView.identifier, for: indexPath) as! MSCollectionViewHeaderFooterView
        headerFooterView.headerFooterView.titleNumberOfLines = section.numberOfLines
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            headerFooterView.headerFooterView.setup(style: section.headerStyle, title: section.title, accessoryButtonTitle: section.hasAccessoryView ? "See More" : "")
            headerFooterView.headerFooterView.onAccessoryButtonTapped = { [unowned self] in self.showAlertForAccessoryTapped(title: section.title) }
            return headerFooterView
        case UICollectionView.elementKindSectionFooter:
            if groupedSections[indexPath.section].hasFooter {
                headerFooterView.headerFooterView.setup(style: .footer, title: section.footerText)
                return headerFooterView
            }
            return UICollectionReusableView()
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - MSCollectionViewHeaderFooterViewDemoController: UICollectionViewDelegate

extension MSCollectionViewHeaderFooterViewDemoController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    private func showAlertForAccessoryTapped(title: String) {
        let alert = UIAlertController(title: "\(title) was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

// MARK: - MSCollectionViewHeaderFooterViewDemoController: UICollectionViewDelegateFlowLayout

extension MSCollectionViewHeaderFooterViewDemoController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let section = collectionView == groupedCollectionView ? groupedSections[section] : plainSections[section]
        let height = MSTableViewHeaderFooterView.height(
            style: section.headerStyle,
            title: section.title,
            titleNumberOfLines: section.numberOfLines,
            containerWidth: view.width
        )
        return CGSize(width: view.width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if collectionView == groupedCollectionView && groupedSections[section].hasFooter {
            let section = groupedSections[section]
            let height = MSTableViewHeaderFooterView.height(
                style: section.headerStyle,
                title: section.footerText,
                titleNumberOfLines: section.numberOfLines,
                containerWidth: view.width
            )
            return CGSize(width: view.width, height: height)
        }
        return .zero
    }
}
