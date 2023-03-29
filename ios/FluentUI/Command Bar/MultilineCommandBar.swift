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
public class MultilineCommandBar: BottomSheetController {

    // MARK: - Public methods

    @objc public init(portraitRows: [MultilineCommandBarRow], landscapeRows: [MultilineCommandBarRow]? = nil) {
        self.portraitRows = portraitRows
        if let landscapeRows = landscapeRows {
            self.landscapeRows = landscapeRows
        } else {
            self.landscapeRows = portraitRows
        }

        rowsStackView = UIStackView()
        super.init(expandedContentView: rowsStackView)

        rowsStackView.axis = .vertical
        rowsStackView.distribution = .equalCentering
        rowsStackView.translatesAutoresizingMaskIntoConstraints = false

        if traitCollection.horizontalSizeClass == traitCollection.verticalSizeClass {
            addRows(rows: &self.landscapeRows)
        } else {
            addRows(rows: &self.portraitRows)
        }
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

    // MARK: - Private

    private var portraitRows: [MultilineCommandBarRow]

    private var landscapeRows: [MultilineCommandBarRow]

    private var rowsStackView: UIStackView

    private func addRows(rows: inout [MultilineCommandBarRow]) {
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
            NSLayoutConstraint.activate([
                multilineCommandBarRow.leadingAnchor.constraint(equalTo: rowsStackView.leadingAnchor, constant: 16),
                multilineCommandBarRow.trailingAnchor.constraint(equalTo: rowsStackView.trailingAnchor, constant: -16)
            ])
        }
        preferredExpandedContentHeight = rowsStackView.frame.height
    }

    private func removeRows() {
        rowsStackView.subviews.forEach { rowView in
            NSLayoutConstraint.deactivate([
                rowView.leadingAnchor.constraint(equalTo: rowsStackView.leadingAnchor, constant: 16),
                rowView.trailingAnchor.constraint(equalTo: rowsStackView.trailingAnchor, constant: -16)
            ])

            rowView.removeFromSuperview()
        }
    }
}
