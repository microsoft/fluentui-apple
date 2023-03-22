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
        commandBarRowViews = []

        super.init(frame: .zero)

        rowsStackView.axis = .vertical
        rowsStackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(rowsStackView)

        for row in rows {
            let multilineCommandBarRow = CommandBar(itemGroups: row.itemGroups, leadingItemGroups: nil)
            multilineCommandBarRow.isScrollable = row.isScrollable
            multilineCommandBarRow.translatesAutoresizingMaskIntoConstraints = false

            if row.isScrollable {
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

        // Update appearance whenever `tokenSet` changes.
        tokenSet.registerOnUpdate(for: self) { [weak self] in
            self?.updateCommandBarRows()
        }
    }

//    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        if let previousTraitCollection = previousTraitCollection {
//            if previousTraitCollection.verticalSizeClass != traitCollection.verticalSizeClass {
//                innerStackView.axis = traitCollection.verticalSizeClass == .regular ? .vertical : .horizontal
//                innerStackView.spacing = traitCollection.verticalSizeClass == .regular ? 1 : 8
//            }
//        }
//    }

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

    /// Container UIStackView that holds all rows of the MultilineCommandBar
    private var rowsStackView: UIStackView

    private var commandBarRowViews: [CommandBar]

    private func updateCommandBarRows() {
        for commandBarRowView in commandBarRowViews {
            commandBarRowView.updateButtonTokens()
        }
    }
}
