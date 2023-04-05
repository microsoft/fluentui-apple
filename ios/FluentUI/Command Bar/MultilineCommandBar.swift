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
            updateCommandBarAppearance()
        }
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    public var commandBarOverrideTokens: [CommandBarTokenSet.Tokens: ControlTokenValue]? {
        didSet {
            updateCommandBarAppearance()
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

    private var commandBarRows = [CommandBar]()

    private var bottomSheetController: BottomSheetController?

    private func addRows(rows: inout [MultilineCommandBarRow]) {
        for row in rows {
            let commandBarRow = CommandBar(itemGroups: row.itemGroups, leadingItemGroups: nil)
            commandBarRow.isScrollable = row.isScrollable
            commandBarRow.translatesAutoresizingMaskIntoConstraints = false
            commandBarRows.append(commandBarRow)

            if row.isScrollable {
                commandBarRow.tokenSet[.itemBackgroundColorRest] = .uiColor {
                    UIColor(light: GlobalTokens.neutralColor(.white),
                            dark: GlobalTokens.neutralColor(.black))
                }
                rowsStackView.addArrangedSubview(commandBarRow)
            } else {
                let containerView = UIView()
                containerView.translatesAutoresizingMaskIntoConstraints = false
                containerView.addSubview(commandBarRow)

                NSLayoutConstraint.activate([
                    commandBarRow.topAnchor.constraint(equalTo: containerView.topAnchor),
                    commandBarRow.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                    commandBarRow.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                    commandBarRow.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
                ])
                rowsStackView.addArrangedSubview(containerView)
            }
        }
    }

    private func removeRows() {
        rowsStackView.subviews.forEach { commandBarRow in
            commandBarRow.removeFromSuperview()
        }
    }

    private func updateCommandBarAppearance() {
        for commandBarRow in commandBarRows {
            commandBarRow.tokenSet.replaceAllOverrides(with: commandBarOverrideTokens)
        }
    }
}
