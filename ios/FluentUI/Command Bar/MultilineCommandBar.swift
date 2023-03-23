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

    @objc public init(portraitRows: [MultilineCommandBarRow], landscapeRows: [MultilineCommandBarRow]? = nil) {
        self.tokenSet = CommandBarTokenSet()
        self.portraitRows = portraitRows
        self.landscapeRows = landscapeRows

        rowsStackView = UIStackView()
        commandBarRowViews = []

        super.init(frame: .zero)

        rowsStackView.axis = .vertical
        rowsStackView.translatesAutoresizingMaskIntoConstraints = false

        if traitCollection.verticalSizeClass == .compact && landscapeRows != nil {
            addRows(rows: &(self.landscapeRows)!)
        } else {
            addRows(rows: &self.portraitRows)
        }

        // Update appearance whenever `tokenSet` changes.
        tokenSet.registerOnUpdate(for: self) { [weak self] in
            self?.updateCommandBarRows()
        }
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if landscapeRows != nil {
            if previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass {
                removeRows()
                if traitCollection.verticalSizeClass == .regular {
                    addRows(rows: &self.portraitRows)
                } else {
                    addRows(rows: &(self.landscapeRows)!)
                }
            }
        }
    }

    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        tokenSet.update(newWindow.fluentTheme)
        updateCommandBarRows()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    // MARK: Overrides

    public override var intrinsicContentSize: CGSize {
        .zero
    }

    // MARK: - TokenizedControl

    public typealias TokenSetKeyType = CommandBarTokenSet.Tokens
    public var tokenSet: CommandBarTokenSet

    // MARK: - Private

    private var portraitRows: [MultilineCommandBarRow]

    private var landscapeRows: [MultilineCommandBarRow]?

    private var rowsStackView: UIStackView

    private var commandBarRowViews: [CommandBar]

    private func addRows(rows: inout [MultilineCommandBarRow]) {
        addSubview(rowsStackView)
        for row in rows {
            let multilineCommandBarRow = CommandBar(itemGroups: row.itemGroups, leadingItemGroups: nil)
            multilineCommandBarRow.isScrollable = row.isScrollable
            multilineCommandBarRow.translatesAutoresizingMaskIntoConstraints = false

            if row == rows.first {
                multilineCommandBarRow.tokenSet[.itemBackgroundColorRest] = .dynamicColor {
                    .init(light: GlobalTokens.neutralColors(.white),
                          dark: GlobalTokens.neutralColors(.black))
                }
            }
            rowsStackView.addArrangedSubview(multilineCommandBarRow)
            commandBarRowViews.append(multilineCommandBarRow)
        }

        NSLayoutConstraint.activate([
            rowsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            rowsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }

    private func removeRows() {
        NSLayoutConstraint.deactivate([
            rowsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            rowsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])

        rowsStackView.removeFromSuperview()
        rowsStackView.subviews.forEach { rowView in
            rowView.removeFromSuperview()
        }
    }

    private func updateCommandBarRows() {
        for commandBarRowView in commandBarRowViews {
            commandBarRowView.updateButtonTokens()
        }
    }
}
