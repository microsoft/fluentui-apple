//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFMultilineCommandBarRow)
public class MultilineCommandBarRow: NSObject {
    var itemGroups: [CommandBarItemGroup] = []
    var isScrollable: Bool = false

    public init(itemGroups: [CommandBarItemGroup], isScrollable: Bool) {
        self.itemGroups = itemGroups
        self.isScrollable = isScrollable
    }
}

@objc(MSFMultilineCommandBar)
public class MultilineCommandBar: UIView, TokenizedControlInternal {

    // MARK: - Public methods

    @objc public init(rows: [MultilineCommandBarRow]) {
        self.tokenSet = CommandBarTokenSet()

        rowsStackView = UIStackView()
        rowsStackView.axis = .vertical
        rowsStackView.translatesAutoresizingMaskIntoConstraints = false
        itemGroupViews = []

        super.init(frame: .zero)

        addSubview(rowsStackView)

        for row in rows {
            if row.isScrollable {
                let scrollableRow = CommandBar(itemGroups: row.itemGroups, leadingItemGroups: nil)
                scrollableRow.translatesAutoresizingMaskIntoConstraints = false
                rowsStackView.addArrangedSubview(scrollableRow)
            } else {
                let fixedRow = CommandBarCommandGroupsView(itemGroups: row.itemGroups,
                                                           tokenSet: tokenSet)
                fixedRow.translatesAutoresizingMaskIntoConstraints = false
                fixedRow.setEqualWidthGroups()
                rowsStackView.addArrangedSubview(fixedRow)
                itemGroupViews.append(fixedRow)
            }
        }

        NSLayoutConstraint.activate([
            rowsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            rowsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])

        // Update appearance whenever `tokenSet` changes.
        tokenSet.registerOnUpdate(for: self) { [weak self] in
            self?.updateButtonTokens()
        }
    }

    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        tokenSet.update(newWindow.fluentTheme)
        updateButtonTokens()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// Apply `isEnabled` and `isSelected` state from `CommandBarItem` to the buttons
    @available(*, message: "Changes on CommandBarItem objects will automatically trigger updates to their corresponding CommandBarButtons. Calls to this method are no longer necessary.")
    @objc public func updateButtonsState() {
        for itemGroupView in itemGroupViews {
            itemGroupView.updateButtonsState()
        }
    }

    // MARK: Overrides

    public override var intrinsicContentSize: CGSize {
        .zero
    }

    // MARK: - TokenizedControl

    public typealias TokenSetKeyType = CommandBarTokenSet.Tokens
    public var tokenSet: CommandBarTokenSet

    // MARK: - Private

    /// Container UIStackView that holds all rows of the MultilineCommandBar
    private var rowsStackView: UIStackView

    private var itemGroupViews: [CommandBarCommandGroupsView]

    private func updateButtonTokens() {
        for itemGroupView in itemGroupViews {
            itemGroupView.updateButtonsShown()
        }
    }
}
