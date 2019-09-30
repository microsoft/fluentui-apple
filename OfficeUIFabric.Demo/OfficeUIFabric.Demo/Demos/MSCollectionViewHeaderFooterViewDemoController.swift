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

    private let segmentedControl: MSSegmentedControl = {
        let segmentedControl = MSSegmentedControl(items: TableViewHeaderFooterSampleData.tabTitles)
        segmentedControl.addTarget(self, action: #selector(updateActiveTabContent), for: .valueChanged)
        return segmentedControl
    }()
    private lazy var groupedCollectionView: UICollectionView = createCollectionView(isPlainStyle: false)
    private lazy var plainCollectionView: UICollectionView = createCollectionView(isPlainStyle: true)

    override func viewDidLoad() {
        super.viewDidLoad()

        container.heightAnchor.constraint(equalTo: scrollingContainer.heightAnchor).isActive = true
        container.layoutMargins = .zero
        container.spacing = 0

        container.addArrangedSubview(segmentedControl)
        container.addArrangedSubview(groupedCollectionView)
        container.addArrangedSubview(plainCollectionView)

        updateActiveTabContent()

        NotificationCenter.default.addObserver(self, selector: #selector(handleContentSizeCategoryDidChange), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let itemSize = CGSize(width: view.width, height: MSTableViewCell.height(title: TableViewHeaderFooterSampleData.itemTitle))
        [groupedCollectionView, plainCollectionView].forEach {
            ($0.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = itemSize
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

    @objc private func updateActiveTabContent() {
        groupedCollectionView.isHidden = segmentedControl.selectedSegmentIndex == 1
        plainCollectionView.isHidden = !groupedCollectionView.isHidden
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
        var isLastInSection = indexPath.item == collectionView.numberOfItems(inSection: indexPath.section) - 1
        if collectionView == groupedCollectionView {
            if groupedSections[indexPath.section].hasFooter {
                isLastInSection = false
            }
            cell.cellView.bottomSeparatorType = isLastInSection ? .full : .inset
        } else {
            cell.cellView.bottomSeparatorType = isLastInSection ? .none : .inset
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = collectionView == groupedCollectionView ? groupedSections[indexPath.section] : plainSections[indexPath.section]
        let headerFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MSCollectionViewHeaderFooterView.identifier, for: indexPath) as! MSCollectionViewHeaderFooterView
        headerFooterView.headerFooterView.titleNumberOfLines = section.numberOfLines
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            headerFooterView.headerFooterView.setup(style: section.headerStyle, title: section.title, accessoryButtonTitle: section.hasAccessory ? "See More" : "")
            headerFooterView.headerFooterView.accessoryButtonStyle = section.accessoryButtonStyle
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
