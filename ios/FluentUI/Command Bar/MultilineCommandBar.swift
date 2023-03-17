//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public typealias MultilineCommandBarRow = [CommandBarItemGroup]

@objc(MSFMultilineCommandBar)
public class MultilineCommandBar: UIView, TokenizedControlInternal {

    // MARK: - Public methods

    @objc public init(rows: [MultilineCommandBarRow]) {
        self.tokenSet = CommandBarTokenSet()

        itemGroupsViews = []
        rowsStackView = UIStackView()
        rowsStackView.axis = .vertical
        rowsStackView.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: .zero)

        addSubview(rowsStackView)

        for row in rows {
            let itemGroupsView = CommandBarCommandGroupsView(itemGroups: row,
                                                             tokenSet: tokenSet)
            itemGroupsView.translatesAutoresizingMaskIntoConstraints = false
            itemGroupsView.setEqualWidthGroups()
            itemGroupsViews.append(itemGroupsView)
            rowsStackView.addArrangedSubview(itemGroupsView)
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
        for itemGroupView in itemGroupsViews {
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

    private var itemGroupsViews: [CommandBarCommandGroupsView]

    private func updateButtonTokens() {
        for itemGroupView in itemGroupsViews {
            itemGroupView.updateButtonsShown()
        }
    }
}
