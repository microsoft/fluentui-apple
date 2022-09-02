//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class CommandBarButton: UIButton {
    let item: CommandBarItem

    override var isHighlighted: Bool {
        didSet {
            updateStyle()
        }
    }

    override var isSelected: Bool {
        didSet {
            updateStyle()
        }
    }

    override var isEnabled: Bool {
        didSet {
            updateStyle()
        }
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        updateStyle()
    }

    init(item: CommandBarItem, isPersistSelection: Bool = true) {
        self.item = item
        self.isPersistSelection = isPersistSelection

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        if let makeCustomButtonView = item.customControlView {
            addCustomView(makeCustomButtonView())
            /// Disable accessiblity for the button so that the custom view can provide itself or its subviews as the accessilbity element(s)
            isAccessibilityElement = false
        } else {
            if #available(iOS 15.0, *) {
                var buttonConfiguration = UIButton.Configuration.plain()
                buttonConfiguration.image = item.iconImage
                buttonConfiguration.contentInsets = LayoutConstants.contentInsets
                buttonConfiguration.background.cornerRadius = 0
                configuration = buttonConfiguration
            } else {
                setImage(item.iconImage, for: .normal)
                contentEdgeInsets = LayoutConstants.contentEdgeInsets
            }

            let accessibilityDescription = item.accessibilityLabel
            accessibilityLabel = (accessibilityDescription != nil) ? accessibilityDescription : item.title
            accessibilityHint = item.accessibilityHint

            menu = item.menu
            showsMenuAsPrimaryAction = item.showsMenuAsPrimaryAction
        }

        updateState()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    func updateState() {
        isEnabled = item.isEnabled
        isSelected = isPersistSelection && item.isSelected
        isHidden = item.isHidden

        /// Additional state update is not needed if the `customControlView` is being shown
        guard item.customControlView == nil else {
            return
        }

        // always update icon and title as we only display one; we may alterenate between them, and the icon may also change
        let iconImage = item.iconImage
        let title = item.title
        let accessibilityDescription = item.accessibilityLabel

        if #available(iOS 15.0, *) {
            configuration?.image = iconImage
            configuration?.title = iconImage != nil ? nil : title

            if let font = item.titleFont {
                let attributeContainer = AttributeContainer([NSAttributedString.Key.font: font])
                configuration?.attributedTitle?.setAttributes(attributeContainer)
            }
        } else {
            setImage(iconImage, for: .normal)
            setTitle(iconImage != nil ? nil : title, for: .normal)
            titleLabel?.font = item.titleFont
        }

        titleLabel?.isEnabled = isEnabled

        accessibilityLabel = (accessibilityDescription != nil) ? accessibilityDescription : title
        accessibilityHint = item.accessibilityHint
    }

    private let isPersistSelection: Bool

    private var selectedTintColor: UIColor {
        guard let window = window else {
            return UIColor(light: Colors.communicationBlue,
                           dark: .black)
        }

        return UIColor(light: Colors.primary(for: window),
                       dark: .black)
    }

    private var selectedBackgroundColor: UIColor {
        guard let window = window else {
            return UIColor(light: Colors.Palette.communicationBlueTint30.color,
                           dark: Colors.Palette.communicationBlue.color)
        }

        return  UIColor(light: Colors.primaryTint30(for: window),
                        dark: Colors.primary(for: window))
    }

    private func updateStyle() {
        // TODO: Once iOS 14 support is dropped, this should be converted to a constant (let) that will be initialized by the logic below.
        var resolvedBackgroundColor: UIColor = .clear
        let resolvedTintColor: UIColor = isSelected ? selectedTintColor : ColorConstants.normalTintColor

        if isPersistSelection {
            if isSelected {
                resolvedBackgroundColor = selectedBackgroundColor
            } else if isHighlighted {
                resolvedBackgroundColor = ColorConstants.highlightedBackgroundColor
            } else {
                resolvedBackgroundColor = ColorConstants.normalBackgroundColor
            }
        }

        tintColor = resolvedTintColor
        if #available(iOS 15.0, *) {
            configuration?.baseForegroundColor = resolvedTintColor
            configuration?.background.backgroundColor = resolvedBackgroundColor
        } else {
            backgroundColor = resolvedBackgroundColor
            setTitleColor(tintColor, for: .normal)
        }
    }

    private func addCustomView(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        /// Constrain view to edges of the button
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    private struct LayoutConstants {
        static let contentInsets = NSDirectionalEdgeInsets(top: 8.0,
                                                           leading: 10.0,
                                                           bottom: 8.0,
                                                           trailing: 10.0)
        static let contentEdgeInsets = UIEdgeInsets(top: 8.0,
                                                    left: 10.0,
                                                    bottom: 8.0,
                                                    right: 10.0)
    }

    private struct ColorConstants {
        static let normalTintColor: UIColor = Colors.textPrimary
        static let normalBackgroundColor = UIColor(light: Colors.gray50,
                                                   dark: Colors.gray600)
        static let highlightedBackgroundColor = UIColor(light: Colors.gray100,
                                                        dark: Colors.gray900)
    }
}
