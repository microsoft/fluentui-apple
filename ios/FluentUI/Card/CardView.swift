//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Delegate protocol to handle user interaction with the CardView
@objc(MSFCardDelegate)
public protocol CardDelegate {
    /// Called after the Card or the button inside the Card is tapped
    /// - Parameter card: The Card that was tapped
    @objc optional func didTapCard(_ card: CardView)
}

/// Color style can be app colors, neutral colors, or custom colors. The style affects the background, border, title, subtitle and icon colors
@objc(MSFCardColorStyle)
public enum CardColorStyle: Int, CaseIterable {
    case appColor
    case neutral
    case custom
}

/// Card style can be horizontal, or vertical
/// Both styles have a title, an icon and an optional subtitle. The whole card is clickable
@objc(MSFCardStyle)
public enum CardStyle: Int, CaseIterable {
    /// Icon is positioned next to the title and subtitle is positioned below the title
    case horizontal
    /// Icon is at the top, title below the icon and subtitle below the title
    case vertical

    var width: CGFloat {
        switch self {
        case .horizontal:
            return 156
        case .vertical:
            return 120
        }
    }
}

/**
 `CardView` is a UIView used to display information in a card
 
 A card has a title, an optional subtitle, an icon, a style, and a color style
 
 Use `titleNumberOfLines` and `subtitleNumberOfLines`  to set the number of lines the title and subtitle should have respectively. When the string can not fit in the number of lines set, it will get truncated
 
 Use one of the defined color styles for an app color style, or a neutral gray color style
 When CardColorStyle.custom is used, default colors will be set unless a custom color is provided by setting the properties: `customBackgroundColor`, `customTitleColor`, `customSubtitleColor`, `customIconTintColor`, and `customBorderColor`
 
 Conform to the `CardDelegate` in order to provide a handler for the card tap event
 */
@objc(MSFCardView)
open class CardView: UIView {
    /// Delegate to handle user interaction with the CardView
    @objc public weak var delegate: CardDelegate?

    /// All card styles have a title. Setting `primaryText` will refresh the layout constraints
    @objc open var primaryText: String {
        didSet {
            if primaryText != oldValue {
                primaryLabel.text = primaryText
                setupLayoutConstraints()
            }
        }
    }

    /// Setting `secondaryText` is a way to add/remove the subtitle which will also refresh the layout constraints to adjust to the change
    @objc open var secondaryText: String? {
        didSet {
            if secondaryText != oldValue {
                secondaryLabel.text = secondaryText
                setupLayoutConstraints()
            }
        }
    }

    /// The card's icon. Announcement is the only card style that doesn't include an icon
    @objc open var icon: UIImage {
        didSet {
            if icon != oldValue {
                iconView.image = icon
            }
        }
    }

    /// The color style determines the border color, background color, icon tint color, and text color. When using the custom style, set custom properties to override the default color values
    @objc open var colorStyle: CardColorStyle = .neutral {
        didSet {
            if colorStyle != oldValue {
                setupColors()
            }
        }
    }

    /// Set `titleNumberOfLines` in order to control how many lines the title has. Setting this property will refresh the layout constrinats to adjust to the change
    @objc open var twoLineTitle: Bool = false {
        didSet {
            if twoLineTitle != oldValue {
                primaryLabel.numberOfLines = Constants.twoLineTitle
                setupLayoutConstraints()
            }
        }
    }

    /// Set `customBackgroundColor` in order to set the background color when using the custom color style
    @objc open var customBackgroundColor: UIColor = Constants.defaultBackgroundColor {
        didSet {
            if customBackgroundColor != oldValue {
                setupColors()
            }
        }
    }

    /// Set `customTitleColor` in order to set the title's text color when using the custom color style
    @objc open var customTitleColor: UIColor = Colors.textPrimary {
        didSet {
            if customTitleColor != oldValue {
                setupColors()
            }
        }
    }

    /// Set `customSubtitleColor` in order to set the subtitle's text color when using the custom color style
    @objc open var customSubtitleColor: UIColor = Colors.textSecondary {
        didSet {
            if customSubtitleColor != oldValue {
                setupColors()
            }
        }
    }

    /// Set `customIconTintColor` in order to set the icon's tint color when using the custom color style
    @objc open var customIconTintColor: UIColor = Colors.iconSecondary {
        didSet {
            if customIconTintColor != oldValue {
                setupColors()
            }
        }
    }

    /// Set `customBorderColor` in order to set the border's color when using the custom color style
    @objc open var customBorderColor: UIColor = Constants.defaultBorderColor {
        didSet {
            if customBorderColor != oldValue {
                setupColors()
            }
        }
    }

    /// Set `customWidth` in order to set the width of the card
    @objc open var customWidth: CGFloat {
        didSet {
            if customWidth != oldValue {
                setupLayoutConstraints()
            }
        }
    }

    /// The style of the card; vertical or horizontal. Style determines the layout of the content
    private var style: CardStyle = .horizontal

    /// The view of the icon. Appears on top of the text in vertical cards and besides the text in horizontal cards
    private var iconView: UIImageView

    /// The label for the Card's title
    private let primaryLabel: Label = {
        let primaryLabel = Label()
        primaryLabel.translatesAutoresizingMaskIntoConstraints = false
        primaryLabel.style = .subhead
        primaryLabel.colorStyle = .primary
        return primaryLabel
    }()

    /// The label for the Card's subtitle
    private let secondaryLabel: Label = {
        let secondaryLabel = Label()
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.style = .footnote
        secondaryLabel.colorStyle = .secondary
        return secondaryLabel
    }()

    /// The height constraint of the Card. It's updated when layout constraints are set up and when the preferred size category changes
    private lazy var heightConstraint: NSLayoutConstraint = {
        return self.heightAnchor.constraint(equalToConstant: 0)
    }()

    /**
     Initializes `CardView`
     
     - Parameter style: The style of the card
     - Parameter title: The title of the card
     - Parameter subtitle: The subtitle of the card - optional
     - Parameter icon: The icon of the card
     - Parameter colorStyle: The Card's color style; appColor, neutral, or custom
     **/
    @objc public init(style: CardStyle,
                      title: String,
                      subtitle: String? = nil,
                      icon: UIImage,
                      colorStyle: CardColorStyle) {
        self.primaryText = title
        self.style = style
        self.secondaryText = subtitle
        self.icon = icon
        self.colorStyle = colorStyle
        customWidth = style.width
        iconView = UIImageView(image: icon)

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        // View border and background
        layer.borderWidth = UIScreen.main.devicePixel
        layer.cornerRadius = Constants.borderRadius

        // Title
        primaryLabel.text = title
        primaryLabel.numberOfLines = twoLineTitle ? Constants.twoLineTitle : Constants.defaultTitleNumberOfLines
        primaryLabel.textAlignment = .natural
        addSubview(primaryLabel)

        // Subtitle
        if let secondaryText = secondaryText {
            secondaryLabel.text = secondaryText
            secondaryLabel.textAlignment = .natural
            addSubview(secondaryLabel)
        }

        // Icon
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        addSubview(iconView)

        // Tap event handler
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCardTapped(_:)))
        addGestureRecognizer(tapGesture)

        setupLayoutConstraints()
    }

    @available(*, unavailable)
    @objc public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        setupColors()
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if let previousTraitCollection = previousTraitCollection {
            if previousTraitCollection.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
                var height = style == .horizontal ? Constants.horizontalBaseHeight : Constants.verticalBaseHeight
                let (singleLineHeight, twoLineHeight) = labelHeight(for: traitCollection.preferredContentSizeCategory)

                if twoLineTitle {
                   height += twoLineHeight
                } else {
                    height += 2 * singleLineHeight
                }

                heightConstraint.constant = height
            }

            if previousTraitCollection.hasDifferentColorAppearance(comparedTo: traitCollection) {
                // Update border color
                switch colorStyle {
                case .appColor:
                    if let window = window {
                        layer.borderColor = UIColor(light: Colors.primaryTint30(for: window), dark: .clear).cgColor
                    }
                case .neutral:
                    layer.borderColor = Constants.defaultBorderColor.cgColor
                case .custom:
                    layer.borderColor = customBorderColor.cgColor
                }
            }
        }
    }

    /// Set up the background color of the card and update the icon and text color if necessary
    private func setupColors() {
        switch colorStyle {
        case .appColor:
            primaryLabel.textColor = UIColor(light: .black, dark: Colors.gray100)
            secondaryLabel.textColor = UIColor(light: Colors.gray600, dark: Colors.gray400)
            iconView.tintColor = UIColor(light: Colors.gray600, dark: Colors.gray500)
            if let window = window {
                backgroundColor = UIColor(light: Colors.primaryTint40(for: window), dark: Colors.primaryTint30(for: window))
                layer.borderColor = UIColor(light: Colors.primaryTint30(for: window), dark: .clear).cgColor
            }
        case .neutral:
            backgroundColor = Constants.defaultBackgroundColor
            primaryLabel.textColor = Colors.textPrimary
            secondaryLabel.textColor = Colors.textSecondary
            iconView.tintColor = Colors.iconSecondary
            layer.borderColor = Constants.defaultBorderColor.cgColor
        case .custom:
            backgroundColor = customBackgroundColor
            primaryLabel.textColor = customTitleColor
            secondaryLabel.textColor = customSubtitleColor
            iconView.tintColor = customIconTintColor
            layer.borderColor = customBorderColor.cgColor
        }
    }

    private struct Constants {
        static let defaultBackgroundColor = UIColor(light: .white, dark: Colors.gray900)
        static let defaultBorderColor = UIColor(light: Colors.dividerOnPrimary, dark: .clear)
        static let iconWidth: CGFloat = 24
        static let iconHeight: CGFloat = 24
        static let borderRadius: CGFloat = 8.0
        static let defaultTitleNumberOfLines: Int = 1
        static let twoLineTitle: Int = 2
        static let verticalBaseHeight: CGFloat = Constants.verticalPaddingTop + Constants.iconHeight + Constants.verticalContentSpacing + Constants.verticalPaddingBottom
        static let horizontalBaseHeight: CGFloat = 2 * Constants.horizontalPadding
        // Layout constants
        static let paddingTrailing: CGFloat = 16.0
        static let paddingLeading: CGFloat = 12.0
        // Horizontal card layout constants
        static let horizontalPadding: CGFloat = 6.0
        static let horizontalContentSpacing: CGFloat = 12.0
        // Vertical card layout constants
        static let verticalPaddingBottom: CGFloat = 8.0
        static let verticalPaddingTop: CGFloat = 10.0
        static let verticalContentSpacing: CGFloat = 2.0
    }

    private var layoutConstraints: [NSLayoutConstraint] = []

    private func setupLayoutConstraints() {
        if layoutConstraints.count > 0 {
            NSLayoutConstraint.deactivate(layoutConstraints)
            layoutConstraints.removeAll()
        }

        /// The possible text conigurations are:
        /// 1) Single-line Title
        /// 2) Two-line title
        /// 3) Single-line Title + single-line subtitle
        /// In all cases, the text height is: 2 * title's height
        var height: CGFloat = ceil(2 * primaryLabel.intrinsicContentSize.height)

        switch style {
        case .horizontal:
            height += Constants.horizontalBaseHeight

            layoutConstraints.append(contentsOf: [
                iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
                primaryLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: Constants.horizontalContentSpacing)
            ])

            // Center the title vertically if there is no subtitle
            if secondaryText == nil && !twoLineTitle {
                layoutConstraints.append(primaryLabel.centerYAnchor.constraint(equalTo: centerYAnchor))
            } else {
                layoutConstraints.append(primaryLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.horizontalPadding))
            }
        case .vertical:
            height += Constants.verticalBaseHeight

            layoutConstraints.append(contentsOf: [
                iconView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalPaddingTop),
                primaryLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: Constants.verticalContentSpacing),
                primaryLabel.leadingAnchor.constraint(equalTo: iconView.leadingAnchor)
            ])
        }

        heightConstraint.constant = height

        layoutConstraints.append(contentsOf: [
            widthAnchor.constraint(equalToConstant: style.width),
            heightConstraint,
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.paddingLeading),
            iconView.widthAnchor.constraint(equalToConstant: Constants.iconWidth),
            iconView.heightAnchor.constraint(equalToConstant: Constants.iconHeight),
            primaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.paddingTrailing)
        ])

        if secondaryText != nil {
            layoutConstraints.append(contentsOf: [
                secondaryLabel.leadingAnchor.constraint(equalTo: primaryLabel.leadingAnchor),
                secondaryLabel.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor),
                secondaryLabel.trailingAnchor.constraint(equalTo: primaryLabel.trailingAnchor)
            ])
        }

        NSLayoutConstraint.activate(layoutConstraints)
    }

    @objc private func handleCardTapped(_ recognizer: UITapGestureRecognizer) {
        delegate?.didTapCard?(self)
    }

    private func labelHeight(for sizeCategory: UIContentSizeCategory) -> (CGFloat, CGFloat) {
        var singleLineHeight: CGFloat = 0
        var twoLineHeight: CGFloat = 0

        switch sizeCategory {
        case .extraSmall:
            singleLineHeight = 15
            twoLineHeight = 30
        case .small:
            singleLineHeight = 16
            twoLineHeight = 34
        case .medium:
            singleLineHeight = 17
            twoLineHeight = 36
        case .large:
            singleLineHeight = 18
            twoLineHeight = 38
        case .extraLarge:
            singleLineHeight = 21
            twoLineHeight = 43
        case .extraExtraLarge:
            singleLineHeight = 23
            twoLineHeight = 47
        case .extraExtraExtraLarge:
            singleLineHeight = 26
            twoLineHeight = 52
        case .accessibilityMedium:
            singleLineHeight = 30
            twoLineHeight = 61
        case .accessibilityLarge:
            singleLineHeight = 36
            twoLineHeight = 72
        case .accessibilityExtraLarge:
            singleLineHeight = 43
            twoLineHeight = 86
        case .accessibilityExtraExtraLarge:
            singleLineHeight = 51
            twoLineHeight = 101
        case .accessibilityExtraExtraExtraLarge:
            singleLineHeight = 59
            twoLineHeight = 117
        default:
            break
        }

        return (singleLineHeight, twoLineHeight)
    }
}
