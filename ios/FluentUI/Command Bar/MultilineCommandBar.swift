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

        super.init(expandedContentView: UIView())

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
        expandedContentView.addSubview(rowsStackView)
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
        }

        NSLayoutConstraint.activate([
            rowsStackView.leadingAnchor.constraint(equalTo: expandedContentView.leadingAnchor, constant: 16),
            rowsStackView.topAnchor.constraint(equalTo: expandedContentView.topAnchor),
            rowsStackView.trailingAnchor.constraint(equalTo: expandedContentView.trailingAnchor, constant: -16),
            rowsStackView.bottomAnchor.constraint(equalTo: expandedContentView.bottomAnchor)
        ])

        preferredExpandedContentHeight = 230
    }

    private func removeRows() {
        NSLayoutConstraint.deactivate([
            rowsStackView.leadingAnchor.constraint(equalTo: expandedContentView.leadingAnchor, constant: 16),
            rowsStackView.topAnchor.constraint(equalTo: expandedContentView.topAnchor),
            rowsStackView.trailingAnchor.constraint(equalTo: expandedContentView.trailingAnchor, constant: -16),
            rowsStackView.bottomAnchor.constraint(equalTo: expandedContentView.bottomAnchor)
        ])

        rowsStackView.removeFromSuperview()
        rowsStackView.subviews.forEach { rowView in
            rowView.removeFromSuperview()
        }
    }
}
