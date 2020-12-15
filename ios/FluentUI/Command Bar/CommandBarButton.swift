//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class CommandBarButton: UIButton {
    /// Background color style, either 'default' or 'brighter'
    enum BackgroundStyle {
        /// Default background
        case `default`
        /// In light mode, if the toolbar behind buttons is blurred,
        /// the button background will be invisible
        /// In that case, we change it to a special color
        case bright
    }

    var backgroundStyle: BackgroundStyle = .default {
        didSet {
            updateBackgroundColor()
        }
    }

    let appearance: CommandBarButtonAppearance
    let item: CommandBarItem

    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? Constants.highlightedAlpha : Constants.defaultAlpha
        }
    }

    init(item: CommandBarItem, appearance: CommandBarButtonAppearance) {
        self.item = item
        self.appearance = appearance

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        tintColor = appearance.tintColor
        setTitleColor(tintColor, for: .normal)
        backgroundColor = appearance.backgroundColor

        widthAnchor.constraint(equalToConstant: Constants.buttonWidth).isActive = true
        setImage(item.iconImage, for: .normal)

        accessibilityLabel = item.accessibilityLabel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateBackgroundColor() {
        if isSelected {
            backgroundColor = appearance.highlightedBackgroundColor
        } else {
            switch backgroundStyle {
            case .default:
                backgroundColor = appearance.backgroundColor
            case .bright:
                backgroundColor = appearance.brightBackgroundColor
            }
        }
    }

    func updateState() {
        isEnabled = item.isEnabled
        isSelected = item.isSelected

        tintColor = isSelected ? appearance.highlightedTintColor : appearance.tintColor
        setTitleColor(tintColor, for: .normal)
        updateBackgroundColor()
    }
}

private extension CommandBarButton {
    struct Constants {
        static let highlightedAlpha: CGFloat = 0.5
        static let defaultAlpha: CGFloat = 1.0
        static let buttonWidth: CGFloat = 40
    }
}
