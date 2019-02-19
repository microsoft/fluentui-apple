//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import UIKit

// MARK: MSPersonaListViewSelectionDirection

@objc public enum MSPersonaListViewSelectionDirection: Int {
    case next = 1
    case prev = -1
}

// MARK: - MSPersonaListViewSearchDirectoryDelegate

@objc public protocol MSPersonaListViewSearchDirectoryDelegate {
    func personaListSearchDirectory(_ personaListView: MSPersonaListView, completion: @escaping ((_ success: Bool) -> Void))
}

// MARK: - MSPersonaListView

open class MSPersonaListView: UITableView {
    private enum Section: Int {
        case personas
        case searchDirectory
    }

    private enum SearchDirectoryState {
        case idle
        case searching
        case displayingSearchResults
    }

    /// The personas to display in the list view
    @objc open var personaList: [MSPersona] = [] {
        didSet {
            reloadData()
        }
    }

    /// The type of accessory that appears on the trailing edge: a disclosure indicator or a details button with an ellipsis icon
    @objc public var accessoryType: MSTableViewCellAccessoryType = .none

    /// Bool indicating whether the 'Search Directory' button should be shown
    @objc open var showsSearchDirectoryButton: Bool = false {
        didSet {
            reloadData()
        }
    }

    @objc open weak var searchDirectoryDelegate: MSPersonaListViewSearchDirectoryDelegate?

    /// Callback with the selected MSPersona
    @objc open var onPersonaSelected: ((MSPersona) -> Void)?

    private var searchResultText: String = "" {
        didSet {
            searchDirectoryState = .displayingSearchResults
        }
    }

    private var searchDirectoryState: SearchDirectoryState = .idle {
        didSet {
            reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
        }
    }

    @objc override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)

        backgroundColor = MSColors.background
        separatorColor = MSColors.separator
        tableFooterView = UIView(frame: .zero)

        register(MSPersonaCell.self, forCellReuseIdentifier: MSPersonaCell.identifier)
        register(MSActionsCell.self, forCellReuseIdentifier: MSActionsCell.identifier)
        register(MSActivityIndicatorCell.self, forCellReuseIdentifier: MSActivityIndicatorCell.identifier)
        register(MSCenteredLabelCell.self, forCellReuseIdentifier: MSCenteredLabelCell.identifier)

        // Keep the cell layout margins fixed
        cellLayoutMarginsFollowReadableWidth = false

        dataSource = self
        delegate = self
    }

    @objc public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Keyboard shortcut support

    /// Selects a persona using the index path for selected row
    @objc public func pickPersona() {
        if personaList.isEmpty {
            return
        }

        guard let indexPathToPick = indexPathForSelectedRow else {
            return
        }
        delegate?.tableView?(self, didSelectRowAt: indexPathToPick)
    }

    /// Selects / deselects a row based on the MSPersonaListViewSelectionDirection value
    ///
    /// - Parameter direction: The MSPersonaListViewSelectionDirection value to select a 'next' or 'previous' cell
    @objc public func selectPersona(direction: MSPersonaListViewSelectionDirection) {
        if personaList.isEmpty {
            return
        }

        let newIndexPath: IndexPath
        if let oldIndexPath = indexPathForSelectedRow {
            deselectRow(at: oldIndexPath, animated: false)
            reloadRows(at: [oldIndexPath], with: .none)
            newIndexPath = indexPath(for: oldIndexPath, direction: direction)
        } else {
            newIndexPath = IndexPath(row: 0, section: 0)
        }

        selectRow(at: newIndexPath, animated: false, scrollPosition: .none)
    }

    private func indexPath(for indexPath: IndexPath, direction: MSPersonaListViewSelectionDirection) -> IndexPath {
        let newRow = indexPath.row + direction.rawValue
        if newRow < 0 || newRow >= personaList.count {
            return indexPath
        }
        return IndexPath(row: newRow, section: indexPath.section)
    }

    @objc private func searchDirectoryButtonTapped() {
        searchDirectoryState = .searching

        // Call searchDirectoryDelegate and show result text on completion
        searchDirectoryDelegate?.personaListSearchDirectory(self, completion: { success in
            if success {
                self.searchResultText = "%d results found from directory".localized.formatted(with: self.personaList.count)
            }
        })
    }
}

// MARK: - MSPersonaListView: UITableViewDataSource

extension MSPersonaListView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return showsSearchDirectoryButton ? 2 : 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            fatalError("numberOfRowsInSection: too many sections")
        }

        switch section {
        case .personas:
            return personaList.count
        case .searchDirectory:
            return 1
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("cellForRowAtIndexPath: too many sections")
        }

        switch section {
        case .personas:
            let cell = dequeueReusableCell(withIdentifier: MSPersonaCell.identifier, for: indexPath) as! MSPersonaCell
            let persona = personaList[indexPath.row]
            cell.setup(persona: persona, accessoryType: accessoryType)
            cell.accessibilityTraits = .button
            return cell
        case .searchDirectory:
            switch searchDirectoryState {
            case .searching:
                let cell = dequeueReusableCell(withIdentifier: MSActivityIndicatorCell.identifier, for: indexPath) as! MSActivityIndicatorCell
                cell.hideSeparator()
                return cell
            case .displayingSearchResults:
                let cell = dequeueReusableCell(withIdentifier: MSCenteredLabelCell.identifier, for: indexPath) as! MSCenteredLabelCell
                cell.setup(text: searchResultText)
                cell.hideSeparator()
                return cell
            case .idle:
                let cell = dequeueReusableCell(withIdentifier: MSActionsCell.identifier, for: indexPath) as! MSActionsCell
                cell.setup(action1Title: "MSPersonaListView.SearchDirectory".localized)
                cell.action1Button.addTarget(self, action: #selector(searchDirectoryButtonTapped), for: .touchUpInside)
                cell.accessibilityTraits = .button
                cell.hideSeparator()
                return cell
            }
        }
    }
}

// MARK: - MSPersonaListView: UITableViewDelegate

extension MSPersonaListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("heightForRowAtIndexPath: too many sections")
        }

        switch section {
        case .personas:
            return MSPersonaCell.defaultHeight
        case .searchDirectory:
            switch searchDirectoryState {
            case .searching:
                return MSActivityIndicatorCell.defaultHeight
            case .displayingSearchResults:
                return MSCenteredLabelCell.defaultHeight
            case .idle:
                return MSActionsCell.defaultHeight
            }
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselecting row affects voice over focus, calling `deselectRowAtIndexPath` before `onPersonaSelected` would help.
        tableView.deselectRow(at: indexPath, animated: false)

        guard let section = Section(rawValue: indexPath.section) else {
            return
        }

        switch section {
        case .personas:
            onPersonaSelected?(personaList[indexPath.row])
        case .searchDirectory:
            break
        }
    }
}
