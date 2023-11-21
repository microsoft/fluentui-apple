//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// An object representing a row in the `MultilineCommandBar`.
///
/// `MultilineCommandBarRow` contains the row's  itemGroups and whether or not the row is scrollable. By default, multiline command bar rows are not scrollable.
@objc(MSFMultilineCommandBarRow)
public class MultilineCommandBarRow: NSObject {
    var itemGroups: [CommandBarItemGroup] = []
    var isScrollable: Bool

    @objc public init(itemGroups: [CommandBarItemGroup], isScrollable: Bool = false) {
        self.itemGroups = itemGroups
        self.isScrollable = isScrollable
    }
}

/**
 `MultilineCommandBar` is a vertical list of `CommandBars`, hosted in a `BottomSheetController`.
 Provide `compactRows` in `init` to set the rows in the MultilineCommandBar. Provide the optional `regularRows` if either layout or buttons change in regular mode. If regularRows is not provided, compactRows will be used.
 */
@objc(MSFMultilineCommandBar)
public class MultilineCommandBar: UIViewController {

    // MARK: - Public methods

    @objc public init(compactRows: [MultilineCommandBarRow], regularRows: [MultilineCommandBarRow]? = nil) {
        if compactRows.isEmpty {
            assertionFailure("compactRows can not be empty.")
        }
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
            addRows(rows: self.regularRows)
        } else {
            addRows(rows: self.compactRows)
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

    @available(iOS, deprecated: 17.0)
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass || previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass {
            removeRows()
            if traitCollection.horizontalSizeClass == traitCollection.verticalSizeClass {
                addRows(rows: self.regularRows)
            } else {
                addRows(rows: self.compactRows)
            }
            bottomSheetController?.preferredExpandedContentHeight = rowsStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            updateCommandBarAppearance()
        }
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    public var scrollableRowOverrideTokens: [CommandBarTokenSet.Tokens: ControlTokenValue]? {
        didSet {
            updateScrollableRows()
        }
    }

    public var fixedRowOverrideTokens: [CommandBarTokenSet.Tokens: ControlTokenValue]? {
        didSet {
            updateFixedRows()
        }
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

    private var scrollableRows = [CommandBar]()

    private var fixedRows = [CommandBar]()

    private var bottomSheetController: BottomSheetController?

    private struct Constants {
        static let horizontalPadding: CGFloat = GlobalTokens.spacing(.size160)
    }

    private func addRows(rows: [MultilineCommandBarRow]) {
        for row in rows {
            let commandBarRow = CommandBar(itemGroups: row.itemGroups, leadingItemGroups: nil)
            commandBarRow.isScrollable = row.isScrollable
            commandBarRow.isScrollableContentCentered = row.isScrollable
            commandBarRow.translatesAutoresizingMaskIntoConstraints = false

            if row.isScrollable {
                rowsStackView.addArrangedSubview(commandBarRow)
                scrollableRows.append(commandBarRow)
            } else {
                let containerView = UIView()
                containerView.translatesAutoresizingMaskIntoConstraints = false
                containerView.addSubview(commandBarRow)

                NSLayoutConstraint.activate([
                    commandBarRow.topAnchor.constraint(equalTo: containerView.topAnchor),
                    commandBarRow.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.horizontalPadding),
                    commandBarRow.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                    commandBarRow.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.horizontalPadding)
                ])
                rowsStackView.addArrangedSubview(containerView)
                fixedRows.append(commandBarRow)
            }
        }
    }

    private func removeRows() {
        rowsStackView.subviews.forEach { commandBarRow in
            commandBarRow.removeFromSuperview()
        }
    }

    private func updateCommandBarAppearance() {
        updateScrollableRows()
        updateFixedRows()
    }

    private func updateScrollableRows() {
        for row in scrollableRows {
            row.tokenSet.replaceAllOverrides(with: scrollableRowOverrideTokens)
        }
    }

    private func updateFixedRows() {
        for row in fixedRows {
            row.tokenSet.replaceAllOverrides(with: fixedRowOverrideTokens)
        }
    }
}
