//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import OfficeUIFabric

// MARK: MSCollectionViewCellDemoController

class MSCollectionViewCellDemoController: DemoController {
    let sections: [TableViewSampleData.Section] = MSTableViewCellSampleData.sections

    private var isGrouped: Bool = false {
        didSet {
            updateCollectionView()
        }
    }

    private var isInSelectionMode: Bool = false {
        didSet {
            collectionView.allowsMultipleSelection = isInSelectionMode

            for indexPath in collectionView?.indexPathsForVisibleItems ?? [] {
                if !sections[indexPath.section].allowsMultipleSelection {
                    continue
                }

                if let cell = collectionView.cellForItem(at: indexPath) as? MSCollectionViewCell {
                    cell.cellView.setIsInSelectionMode(isInSelectionMode, animated: true)
                }
            }

            collectionView.indexPathsForSelectedItems?.forEach {
                collectionView.deselectItem(at: $0, animated: false)
            }

            updateNavigationTitle()
            navigationItem.rightBarButtonItem?.title = isInSelectionMode ? "Done" : "Select"
        }
    }

    private(set) var collectionView: UICollectionView!

    private var styleButtonTitle: String {
        return isGrouped ? "Switch to Plain style" : "Switch to Grouped style"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(MSCollectionViewCell.self, forCellWithReuseIdentifier: MSCollectionViewCell.identifier)
        collectionView.register(MSCollectionViewHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MSCollectionViewHeaderFooterView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        updateCollectionView()
        view.addSubview(collectionView)

        NotificationCenter.default.addObserver(self, selector: #selector(handleContentSizeCategoryDidChange), name: UIContentSizeCategory.didChangeNotification, object: nil)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectionBarButtonTapped))

        toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: styleButtonTitle, style: .plain, target: self, action: #selector(styleBarButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ]
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isToolbarHidden = false
    }

    override func viewWillLayoutSubviews() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            if #available(iOS 12, *) {
                flowLayout.estimatedItemSize = CGSize(width: view.frame.width, height: MSTableViewCell.mediumHeight)
            } else {
                // Higher value of 100 needed for proper layout on iOS 11
                flowLayout.estimatedItemSize = CGSize(width: view.frame.width, height: 100)
            }
        }
        super.viewWillLayoutSubviews()
    }

    @objc private func selectionBarButtonTapped(sender: UIBarButtonItem) {
        isInSelectionMode = !isInSelectionMode
    }

    @objc private func styleBarButtonTapped(sender: UIBarButtonItem) {
        isGrouped = !isGrouped
        sender.title = styleButtonTitle
    }

    @objc private func handleContentSizeCategoryDidChange() {
        collectionView.collectionViewLayout.invalidateLayout()
    }

    private func updateNavigationTitle() {
        if isInSelectionMode {
            let selectedCount = collectionView.indexPathsForSelectedItems?.count ?? 0
            navigationItem.title = selectedCount == 1 ? "1 item selected" : "\(selectedCount) items selected"
        } else {
            navigationItem.title = title
        }
    }

    private func updateCollectionView() {
        collectionView.backgroundColor = isGrouped ? MSColors.Table.backgroundGrouped : MSColors.Table.background
        collectionView.reloadData()
    }
}

// MARK: - MSCollectionViewCellDemoController: UICollectionViewDataSource

extension MSCollectionViewCellDemoController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MSTableViewCellSampleData.numberOfItemsInSection
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        let item = section.item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MSCollectionViewCell.identifier, for: indexPath) as! MSCollectionViewCell
        cell.cellView.setup(
            title: item.text1,
            subtitle: item.text2,
            footer: MSTableViewCellSampleData.hasFullLengthLabelAccessoryView(at: indexPath) ? "" : item.text3,
            customView: TableViewSampleData.createCustomView(imageName: item.image),
            customAccessoryView: section.hasAccessory ? MSTableViewCellSampleData.customAccessoryView : nil,
            accessoryType: MSTableViewCellSampleData.accessoryType(for: indexPath)
        )

        let showsLabelAccessoryView = MSTableViewCellSampleData.hasLabelAccessoryViews(at: indexPath)
        cell.cellView.titleLeadingAccessoryView = showsLabelAccessoryView ? item.text1LeadingAccessoryView() : nil
        cell.cellView.titleTrailingAccessoryView = showsLabelAccessoryView ? item.text1TrailingAccessoryView() : nil
        cell.cellView.subtitleLeadingAccessoryView = showsLabelAccessoryView ? item.text2LeadingAccessoryView() : nil
        cell.cellView.subtitleTrailingAccessoryView = showsLabelAccessoryView ? item.text2TrailingAccessoryView() : nil
        cell.cellView.footerLeadingAccessoryView = showsLabelAccessoryView ? item.text3LeadingAccessoryView() : nil
        cell.cellView.footerTrailingAccessoryView = showsLabelAccessoryView ? item.text3TrailingAccessoryView() : nil

        cell.cellView.titleNumberOfLines = section.numberOfLines
        cell.cellView.subtitleNumberOfLines = section.numberOfLines
        cell.cellView.footerNumberOfLines = section.numberOfLines

        cell.cellView.titleLineBreakMode = .byTruncatingMiddle

        cell.cellView.titleNumberOfLinesForLargerDynamicType = section.numberOfLines == 1 ? 3 : MSTableViewCell.defaultNumberOfLinesForLargerDynamicType
        cell.cellView.subtitleNumberOfLinesForLargerDynamicType = section.numberOfLines == 1 ? 2 : MSTableViewCell.defaultNumberOfLinesForLargerDynamicType
        cell.cellView.footerNumberOfLinesForLargerDynamicType = section.numberOfLines == 1 ? 2 : MSTableViewCell.defaultNumberOfLinesForLargerDynamicType

        cell.cellView.backgroundColor = isGrouped ? MSColors.Table.Cell.backgroundGrouped : MSColors.Table.Cell.background
        cell.cellView.topSeparatorType = isGrouped && indexPath.item == 0 ? .full : .none
        let isLastInSection = indexPath.item == collectionView.numberOfItems(inSection: indexPath.section) - 1
        cell.cellView.bottomSeparatorType = isLastInSection ? .full : .inset

        cell.cellView.isInSelectionMode = section.allowsMultipleSelection ? isInSelectionMode : false

        cell.cellView.onAccessoryTapped = { [unowned self] in self.showAlertForDetailButtonTapped(title: item.text1) }

        return cell
    }

    private func showAlertForDetailButtonTapped(title: String) {
        let alert = UIAlertController(title: "\(title) detail button was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

// MARK: - MSCollectionViewCellDemoController: UICollectionViewDelegate

extension MSCollectionViewCellDemoController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MSCollectionViewHeaderFooterView.identifier, for: indexPath) as! MSCollectionViewHeaderFooterView
            let section = sections[indexPath.section]
            header.headerFooterView.setup(style: section.headerStyle, title: section.title)
            return header
        default:
            return UICollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isInSelectionMode {
            updateNavigationTitle()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isInSelectionMode {
            updateNavigationTitle()
        } else {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}

// MARK: - MSCollectionViewCellDemoController: UICollectionViewDelegateFlowLayout

extension MSCollectionViewCellDemoController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: MSTableViewHeaderFooterView.height(style: .header, title: ""))
    }
}
