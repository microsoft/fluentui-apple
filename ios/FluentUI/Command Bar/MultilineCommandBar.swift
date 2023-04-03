//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFMultilineCommandBarRow)
public class MultilineCommandBarRow: NSObject {
    var itemGroups: [CommandBarItemGroup] = []
    var isScrollable: Bool

    public init(itemGroups: [CommandBarItemGroup], isScrollable: Bool = false) {
        self.itemGroups = itemGroups
        self.isScrollable = isScrollable
    }
}

@objc(MSFMultilineCommandBar)
public class MultilineCommandBar: UIViewController {

    // MARK: - Public methods

    @objc public init(compactRows: [MultilineCommandBarRow], regularRows: [MultilineCommandBarRow]? = nil) {
        self.compactRows = compactRows
        if let regularRows = regularRows {
            self.regularRows = regularRows
        } else {
            self.regularRows = compactRows
        }
        super.init(nibName: nil, bundle: nil)
    }

    public override func loadView() {
        view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        let sheetController = BottomSheetController(expandedContentView: rowsStackView)
        addChild(sheetController)
        view.addSubview(sheetController.view)
        sheetController.didMove(toParent: self)

        if traitCollection.horizontalSizeClass == traitCollection.verticalSizeClass {
            addRows(rows: &self.regularRows)
        } else {
            addRows(rows: &self.compactRows)
        }
        sheetController.preferredExpandedContentHeight = rowsStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

        NSLayoutConstraint.activate([
            sheetController.view.topAnchor.constraint(equalTo: view.topAnchor),
            sheetController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sheetController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        bottomSheetController = sheetController
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass || previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass {
            removeRows()
            if traitCollection.horizontalSizeClass == traitCollection.verticalSizeClass {
                addRows(rows: &self.regularRows)
            } else {
                addRows(rows: &self.compactRows)
            }
            bottomSheetController?.preferredExpandedContentHeight = rowsStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        }
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private var rowsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var compactRows: [MultilineCommandBarRow]

    private var regularRows: [MultilineCommandBarRow]

    private var bottomSheetController: BottomSheetController?

    private func addRows(rows: inout [MultilineCommandBarRow]) {
        for row in rows {
            let rowView = CommandBar(itemGroups: row.itemGroups, leadingItemGroups: nil)
            rowView.isScrollable = row.isScrollable
            rowView.translatesAutoresizingMaskIntoConstraints = false

            if row.isScrollable {
                rowView.tokenSet[.itemBackgroundColorRest] = .uiColor {
                    UIColor(light: GlobalTokens.neutralColor(.white),
                            dark: GlobalTokens.neutralColor(.black))
                }
            }
            rowsStackView.addArrangedSubview(rowView)
        }
    }

    private func removeRows() {
        rowsStackView.subviews.forEach { rowView in
            rowView.removeFromSuperview()
        }
    }
}
