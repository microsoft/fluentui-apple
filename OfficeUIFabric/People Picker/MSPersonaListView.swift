//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import UIKit

// MARK: MSPersonaListViewSelectionDirection

@objc public enum MSPersonaListViewSelectionDirection: Int {
    case next = 1
    case prev = -1
}

// MARK: - MSPersonaListView

open class MSPersonaListView: UITableView {
    /// The personas to display in the list view
    open var personaList: [MSPersona] = [] {
        didSet {
            reloadData()
        }
    }

    /// Callback with the selected MSPersona
    @objc open var onPersonaSelected: ((MSPersona) -> Void)?
    
    @objc override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)

        backgroundColor = MSColors.background
        separatorColor = MSColors.separator
        separatorInset = UIEdgeInsets(top: 0, left: MSPersonaCell.separatorLeftInset, bottom: 0, right: 0)
        tableFooterView = UIView(frame: .zero)

        register(MSPersonaCell.self, forCellReuseIdentifier: MSPersonaCell.identifier)

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
}

// MARK: - UITableViewDataSource

extension MSPersonaListView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personaList.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: MSPersonaCell.identifier, for: indexPath) as! MSPersonaCell
        let persona = personaList[indexPath.row]
        cell.setup(persona: persona)
        cell.accessibilityTraits = UIAccessibilityTraitButton
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MSPersonaListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MSPersonaCell.defaultHeight
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselecting row affects voice over focus, calling `deselectRowAtIndexPath` before `onPersonaSelected` would help.
        tableView.deselectRow(at: indexPath, animated: false)
        onPersonaSelected?(personaList[indexPath.row])
    }
}
