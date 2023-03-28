//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFMultilineCommandBarRow)
public class MultilineCommandBarRow: NSObject {
    var itemGroups: [CommandBarItemGroup] = []
    var isScrollable: Bool
    // only applies to scrollable rows
    var centerAligned: Bool

    public init(itemGroups: [CommandBarItemGroup], isScrollable: Bool, centerAligned: Bool = false) {
        self.itemGroups = itemGroups
        self.isScrollable = isScrollable
        self.centerAligned = centerAligned
    }
}

@objc(MSFMultilineCommandBar)
public class MultilineCommandBar: UIView, TokenizedControlInternal {

    // MARK: - Public methods

    @objc public init(portraitRows: [MultilineCommandBarRow], landscapeRows: [MultilineCommandBarRow]? = nil) {
        self.tokenSet = CommandBarTokenSet()
        self.portraitRows = portraitRows
        if let landscapeRows = landscapeRows {
            self.landscapeRows = landscapeRows
        } else {
            self.landscapeRows = portraitRows
        }

        rowsStackView = UIStackView()
        commandBarRowViews = []

        super.init(frame: .zero)

        rowsStackView.axis = .vertical
        rowsStackView.translatesAutoresizingMaskIntoConstraints = false

        if traitCollection.horizontalSizeClass == traitCollection.verticalSizeClass {
            addRows(rows: &self.landscapeRows)
        } else {
            addRows(rows: &self.portraitRows)
        }

        // Update appearance whenever `tokenSet` changes.
        tokenSet.registerOnUpdate(for: self) { [weak self] in
            self?.updateCommandBarRows()
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

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass || previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass {
            removeRows()
            if traitCollection.horizontalSizeClass == traitCollection.verticalSizeClass {
                addRows(rows: &self.landscapeRows)
            } else {
                addRows(rows: &self.portraitRows)
            }
        }
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

    private var landscapeRows: [MultilineCommandBarRow]

    private var rowsStackView: UIStackView

    private var commandBarRowViews: [CommandBar]

    private func addRows(rows: inout [MultilineCommandBarRow]) {
        addSubview(rowsStackView)
        for row in rows {
            let multilineCommandBarRow = CommandBar(itemGroups: row.itemGroups, leadingItemGroups: nil)
            multilineCommandBarRow.isScrollable = row.isScrollable
            multilineCommandBarRow.translatesAutoresizingMaskIntoConstraints = false
            multilineCommandBarRow.centerAligned = row.centerAligned

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
            rowsStackView.topAnchor.constraint(equalTo: topAnchor),
            rowsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            rowsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rowsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    private func removeRows() {
        NSLayoutConstraint.deactivate([
            rowsStackView.topAnchor.constraint(equalTo: topAnchor),
            rowsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            rowsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rowsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
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
