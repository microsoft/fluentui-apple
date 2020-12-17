//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class CommandBarButton: UIButton {
    let item: CommandBarItem

    private var currentApperance: CommandBarButtonAppearance?

    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? Constants.highlightedAlpha : Constants.defaultAlpha
        }
    }

    init(item: CommandBarItem, appearance: CommandBarButtonAppearance) {
        self.item = item

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        updateAppearance(appearance)

        widthAnchor.constraint(equalToConstant: Constants.buttonWidth).isActive = true
        setImage(item.iconImage, for: .normal)

        accessibilityLabel = item.accessibilityLabel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateAppearance(_ appearance: CommandBarButtonAppearance) {
        currentApperance = appearance

        updateStyleIfPossible()
    }

    func updateState() {
        isEnabled = item.isEnabled
        isSelected = item.isSelected

        updateStyleIfPossible()
    }
}

private extension CommandBarButton {
    struct Constants {
        static let highlightedAlpha: CGFloat = 0.5
        static let defaultAlpha: CGFloat = 1.0
        static let buttonWidth: CGFloat = 40
    }

    var selectedTitleColor: UIColor {
        guard let window = window else {
            return Colors.communicationBlue
        }

        return Colors.primary(for: window)
    }

    var selectedBackgroundColor: UIColor {
        guard let window = window else {
            return Colors.Palette.communicationBlueTint30.color
        }

        return Colors.primaryTint30(for: window)
    }

    func updateStyleIfPossible() {
        guard let appearance = currentApperance else {
            return
        }

        if isSelected {
            tintColor = selectedTitleColor
            backgroundColor = selectedBackgroundColor
        } else {
            tintColor = appearance.tintColor
            backgroundColor = appearance.backgroundColor
        }
    }
}
