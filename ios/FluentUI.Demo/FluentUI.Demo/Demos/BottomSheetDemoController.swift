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

class TabButtonViewController: UIViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(container)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        container.addArrangedSubview(tableView)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.topAnchor),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private lazy var container: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private lazy var tableView: UITableView = createTableView()

    func createTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(TableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: TableViewHeaderFooterView.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }
}

// MARK: - TabButtonViewController: UITableViewDataSource

extension TabButtonViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
            return UITableViewCell()
        }

        cell.setup(title: TableViewHeaderFooterSampleData.itemTitle)
        let isLastInSection = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        cell.bottomSeparatorType = isLastInSection ? .full : .inset

        return cell
    }
}

// MARK: - TabButtonViewController: UITableViewDelegate

extension TabButtonViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeaderFooterView.identifier) as? TableViewHeaderFooterView
        header?.setup(style: .header, title: "Header for Section \(section + 1)")

        return header
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
