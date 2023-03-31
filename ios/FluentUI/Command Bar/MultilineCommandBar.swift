//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFMultilineCommandBarRow)
public class MultilineCommandBarRow: NSObject {
    var itemGroups: [CommandBarItemGroup] = []
    var isScrollable: Bool

    public init(itemGroups: [CommandBarItemGroup], isScrollable: Bool) {
        self.itemGroups = itemGroups
        self.isScrollable = isScrollable
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
        expandedContentView.addSubview(rowsStackView)

        rowsStackView.axis = .vertical
        rowsStackView.translatesAutoresizingMaskIntoConstraints = false

        if traitCollection.horizontalSizeClass == traitCollection.verticalSizeClass {
            addRows(rows: &self.landscapeRows)
        } else {
            addRows(rows: &self.portraitRows)
        }

        NSLayoutConstraint.activate([
            rowsStackView.topAnchor.constraint(equalTo: expandedContentView.topAnchor),
            rowsStackView.leadingAnchor.constraint(equalTo: expandedContentView.leadingAnchor, constant: 16),
            rowsStackView.trailingAnchor.constraint(equalTo: expandedContentView.trailingAnchor, constant: -16),
            rowsStackView.bottomAnchor.constraint(equalTo: expandedContentView.bottomAnchor)
        ])
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
            let rowView = CommandBar(itemGroups: row.itemGroups, leadingItemGroups: nil)
            rowView.isScrollable = row.isScrollable
            rowView.translatesAutoresizingMaskIntoConstraints = false

            if row == rows.first {
                rowView.tokenSet[.itemBackgroundColorRest] = .dynamicColor {
                    .init(light: GlobalTokens.neutralColors(.white),
                          dark: GlobalTokens.neutralColors(.black))
                }
            }
            rowsStackView.addArrangedSubview(rowView)
        }
        preferredExpandedContentHeight = rowsStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    }

    private func removeRows() {
        rowsStackView.subviews.forEach { rowView in
            rowView.removeFromSuperview()
        }
    }
}
