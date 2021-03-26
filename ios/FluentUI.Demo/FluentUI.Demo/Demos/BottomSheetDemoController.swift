//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import FluentUI

class BottomSheetDemoController: DemoController {
// MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPersonaListView()
        setupBottomSheet()
    }

    override func viewWillDisappear(_ animated: Bool) {
        bottomSheetViewController?.view.removeFromSuperview()
        super.viewWillDisappear(animated)
    }

// MARK: Setup Methods

    private func setupPersonaListView() {
        view.addSubview(personaListView)
        personaListView.frame = view.bounds
        personaListView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private func setupBottomSheet() {
        let contentViewController = TabButtonViewController()
        bottomSheetViewController = BottomSheetViewController(with: contentViewController)

        if let bottomSheet = bottomSheetViewController, let navController = navigationController {
            if let rootview = navController.view {
                rootview.addSubview(bottomSheet.view)
            }
        }
    }

// MARK: Private properties
    private let personaListView: PersonaListView = {
        let personaListView = PersonaListView()
        personaListView.personaList = samplePersonas
        personaListView.translatesAutoresizingMaskIntoConstraints = false
        return personaListView
    }()

    private var bottomSheetViewController: BottomSheetViewController?
}

class TabButtonViewController: UICollectionViewController {
    @objc public init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.itemSize = CGSize(width: 48, height: 48)
        flowLayout.sectionInsetReference = .fromSafeArea
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)

        super.init(collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(TabCollectionViewCell.self, forCellWithReuseIdentifier: TabCollectionViewCell.identifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabCollectionViewCell.identifier, for: indexPath as IndexPath)
        let item = TabBarItem(title: "Option \(indexPath.row + 1)", image: UIImage(named: "Home_28")!, selectedImage: UIImage(named: "Home_Selected_28")!)
        (cell as? TabCollectionViewCell)?.setup(with: item)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = true
    }

    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = false
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "\(indexPath.row + 1) was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.collectionView.deselectItem(at: indexPath, animated: false)
        })
        alert.addAction(action)
        present(alert, animated: true)
    }
}

class TabCollectionViewCell: UICollectionViewCell {
    static var identifier: String { return String(describing: self) }
    var tabItemView: TabBarItemView?

    override var isSelected: Bool {
        didSet {
            if oldValue != isSelected {
                tabItemView?.isSelected = isSelected
            }
        }
    }

    func setup(with item: TabBarItem) {
        tabItemView = TabBarItemView(item: item, showsTitle: true, canResizeImage: false)

        if let itemView = tabItemView {
            itemView.alwaysShowTitleBelowImage = true
            addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([itemView.topAnchor.constraint(equalTo: topAnchor),
                                         itemView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                         itemView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                         itemView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }
    }
}
