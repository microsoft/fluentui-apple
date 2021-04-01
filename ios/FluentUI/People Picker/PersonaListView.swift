//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: PersonaListViewSelectionDirection

@available(*, deprecated, renamed: "PersonaListViewSelectionDirection")
public typealias MSPersonaListViewSelectionDirection = PersonaListViewSelectionDirection

@objc(MSFPersonaListViewSelectionDirection)
public enum PersonaListViewSelectionDirection: Int {
    case next = 1
    case prev = -1
}

// MARK: - PersonaListViewSearchDirectoryDelegate

@available(*, deprecated, renamed: "PersonaListViewSearchDirectoryDelegate")
public typealias MSPersonaListViewSearchDirectoryDelegate = PersonaListViewSearchDirectoryDelegate

@objc(MSFPersonaListViewSearchDirectoryDelegate)
public protocol PersonaListViewSearchDirectoryDelegate {
    func personaListSearchDirectory(_ personaListView: PersonaListView, completion: @escaping ((_ success: Bool) -> Void))
}

// MARK: - PersonaListView

@available(*, deprecated, renamed: "PersonaListView")
public typealias MSPersonaListView = PersonaListView

@objc(MSFPersonaListView)
open class PersonaListView: UITableView {
    /// SearchDirectory button state enum
    enum SearchDirectoryState {
        case idle
        case searching
        case displayingSearchResults
    }

    private enum Section: Int {
        case personas
        case searchDirectory
    }

    /// The personas to display in the list view
    @objc open var personaList: [Persona] = [] {
        didSet {
            reloadData()
        }
    }

    /// searchDIrectoryState variable (persona list to reload rows on state change)
    var searchDirectoryState: SearchDirectoryState = .idle {
        didSet {
            if searchDirectoryState != oldValue {
                UIView.performWithoutAnimation {
                    reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
                }
            }
        }
    }

    /// The type of accessory that appears on the trailing edge: a disclosure indicator or a details button with an ellipsis icon
    @objc public var accessoryType: TableViewCellAccessoryType = .none

    /// Bool indicating whether the 'Search Directory' button should be shown
    @objc open var showsSearchDirectoryButton: Bool = false {
        didSet {
            reloadData()
        }
    }

    @objc open weak var searchDirectoryDelegate: PersonaListViewSearchDirectoryDelegate?

    /// Callback with the selected Persona
    @objc open var onPersonaSelected: ((Persona) -> Void)?

    private var searchResultText: String = "" {
        didSet {
            searchDirectoryState = .displayingSearchResults
        }
    }

    @objc override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)

        backgroundColor = Colors.Table.background
        separatorStyle = .none
        tableFooterView = UIView(frame: .zero)

        register(PersonaCellLegacy.self, forCellReuseIdentifier: PersonaCellLegacy.identifier)
        register(ActionsCell.self, forCellReuseIdentifier: ActionsCell.identifier)
        register(ActivityIndicatorCell.self, forCellReuseIdentifier: ActivityIndicatorCell.identifier)
        register(CenteredLabelCell.self, forCellReuseIdentifier: CenteredLabelCell.identifier)

        // Keep the cell layout margins fixed
        cellLayoutMarginsFollowReadableWidth = false

        dataSource = self
        delegate = self
    }

    @objc public required init(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
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

    /// Selects / deselects a row based on the PersonaListViewSelectionDirection value
    ///
    /// - Parameter direction: The PersonaListViewSelectionDirection value to select a 'next' or 'previous' cell
    @objc public func selectPersona(direction: PersonaListViewSelectionDirection) {
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

    private func indexPath(for indexPath: IndexPath, direction: PersonaListViewSelectionDirection) -> IndexPath {
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
                self.searchResultText = String(format: "%d results found from directory".localized, self.personaList.count)
            }
        })
        searchDirectoryState = .idle
    }
}

// MARK: - PersonaListView: UITableViewDataSource

extension PersonaListView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return showsSearchDirectoryButton ? 2 : 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            preconditionFailure("numberOfRowsInSection: too many sections")
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
            preconditionFailure("cellForRowAtIndexPath: too many sections")
        }

        switch section {
        case .personas:
            guard let cell = dequeueReusableCell(withIdentifier: PersonaCellLegacy.identifier, for: indexPath) as? PersonaCellLegacy else {
                return UITableViewCell()
            }
            let persona = personaList[indexPath.row]
            cell.setup(persona: persona, accessoryType: accessoryType)
            cell.backgroundColor = .clear
            cell.accessibilityTraits = .button
            return cell
        case .searchDirectory:
            switch searchDirectoryState {
            case .searching:
                guard let cell = dequeueReusableCell(withIdentifier: ActivityIndicatorCell.identifier, for: indexPath) as? ActivityIndicatorCell else {
                    return UITableViewCell()
                }
                cell.hideSystemSeparator()
                return cell
            case .displayingSearchResults:
                guard let cell = dequeueReusableCell(withIdentifier: CenteredLabelCell.identifier, for: indexPath) as? CenteredLabelCell else {
                    return UITableViewCell()
                }
                cell.setup(text: searchResultText)
                cell.hideSystemSeparator()
                return cell
            case .idle:
                guard let cell = dequeueReusableCell(withIdentifier: ActionsCell.identifier, for: indexPath) as? ActionsCell else {
                    return UITableViewCell()
                }
                cell.setup(action1Title: "MSPersonaListView.SearchDirectory".localized)
                cell.action1Button.addTarget(self, action: #selector(searchDirectoryButtonTapped), for: .touchUpInside)
                cell.accessibilityTraits = .button
                cell.hideSystemSeparator()
                return cell
            }
        }
    }
}

// MARK: - PersonaListView: UITableViewDelegate

extension PersonaListView: UITableViewDelegate {
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
