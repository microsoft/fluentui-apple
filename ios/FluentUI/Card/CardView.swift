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

/// Color theme can be app colors, neutral colors, or custom colors. The theme affects the background, border, title, subtitle and icon colors
@objc(MSFCardColorTheme)
public enum CardColorTheme: Int, CaseIterable {
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
 
 A card has a title, an optional subtitle, an icon, a style, and a color theme
 
 Use `titleNumberOfLines` and `subtitleNumberOfLines`  to set the number of lines the title and subtitle should have respectively. When the string can not fit in the number of lines set, it will get truncated
 
 Use one of the defined color themes for an app color theme, or a neutral gray color theme
 When CardColorTheme.custom is used, default colors will be set unless a custom color is provided by setting the properties: `customBackgroundColor`, `customTitleColor`, `customSubtitleColor`, `customIconTintColor`, and `customBorderColor`
 
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
    /// The color theme determines the border color, background color, icon tint color, and text color. When using the custom theme, set custom properties to override the default color values
    @objc open var colorTheme: CardColorTheme = .neutral {
        didSet {
            if colorTheme != oldValue {
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
    /// Set `customBackgroundColor` in order to set the background color when using the custom color theme
    @objc open var customBackgroundColor: UIColor = Constants.defaultBackgroundColor {
        didSet {
            if customBackgroundColor != oldValue {
                setupColors()
            }
        }
    }
    /// Set `customTitleColor` in order to set the title's text color when using the custom color theme
    @objc open var customTitleColor: UIColor = Constants.defaultTitleColor {
        didSet {
            if customTitleColor != oldValue {
                setupColors()
            }
        }
    }
    /// Set `customSubtitleColor` in order to set the subtitle's text color when using the custom color theme
    @objc open var customSubtitleColor: UIColor = Constants.defaultSubtitleColor {
        didSet {
            if customSubtitleColor != oldValue {
                setupColors()
            }
        }
    }
    /// Set `customIconTintColor` in order to set the icon's tint color when using the custom color theme
    @objc open var customIconTintColor: UIColor = Constants.defaultIconTintColor {
        didSet {
            if customIconTintColor != oldValue {
                setupColors()
            }
        }
    }
    /// Set `customBorderColor` in order to set the border's color when using the custom color theme
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

    private var iconView: UIImageView

    private let primaryLabel: UILabel = {
        let primaryLabel = UILabel()
        primaryLabel.translatesAutoresizingMaskIntoConstraints = false
        primaryLabel.adjustsFontForContentSizeCategory = true
        primaryLabel.font = TextStyle.subhead.font
        primaryLabel.textColor = Colors.textPrimary
        primaryLabel.textAlignment = .natural
        return primaryLabel
    }()

    private let secondaryLabel: UILabel = {
        let secondaryLabel = UILabel()
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.adjustsFontForContentSizeCategory = true
        secondaryLabel.font = TextStyle.footnote.font
        secondaryLabel.textColor = Colors.textSecondary
        secondaryLabel.textAlignment = .natural
        return secondaryLabel
    }()

    private var sizeCategoryIncrease: Bool = false
    private var sizeCategoryChanged: Bool = false
    /**
     Initializes `CardView`
     
     - Parameter style: The style of the card
     - Parameter title: The title of the card
     - Parameter subtitle: The subtitle of the card - optional
     - Parameter icon: The icon of the card
     - Parameter colorTheme: The Card's color theme; appColor, neutral, or custom
     **/
    @objc public init(style: CardStyle,
                      title: String,
                      subtitle: String? = nil,
                      icon: UIImage,
                      colorTheme: CardColorTheme) {
        self.primaryText = title
        self.style = style
        self.secondaryText = subtitle
        self.icon = icon
        self.colorTheme = colorTheme
        customWidth = style.width
        iconView = UIImageView(image: icon)

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        // View border and background
        layer.borderWidth = Constants.borderWidth
        layer.cornerRadius = Constants.borderRadius
        layer.borderColor = Constants.defaultBorderColor.cgColor
        backgroundColor = Constants.defaultBackgroundColor

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
                sizeCategoryIncrease = previousTraitCollection.preferredContentSizeCategory < traitCollection.preferredContentSizeCategory
                sizeCategoryChanged = true
                setupLayoutConstraints()
            }
            if #available(iOS 13, *) {
                if previousTraitCollection.hasDifferentColorAppearance(comparedTo: traitCollection) {
                    // Update border color
                    switch colorTheme {
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
    }

    /// Set up the background color of the card and update the icon and text color if necessary
    private func setupColors() {
        switch colorTheme {
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
            primaryLabel.textColor = Constants.defaultTitleColor
            secondaryLabel.textColor = Constants.defaultSubtitleColor
            iconView.tintColor = Constants.defaultIconTintColor
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
        static let defaultBorderColor = UIColor(light: Colors.gray100, dark: .clear)
        static let defaultTitleColor = UIColor(light: Colors.gray900, dark: Colors.gray100)
        static let defaultSubtitleColor = UIColor(light: Colors.gray500, dark: Colors.gray400)
        static let defaultIconTintColor = UIColor(light: Colors.gray400, dark: Colors.gray500)
        static let iconSize = CGSize(width: 24, height: 24)
        static let borderWidth: CGFloat = UIScreen.main.devicePixel
        static let borderRadius: CGFloat = 8.0
        static let defaultTitleNumberOfLines: Int = 1
        static let twoLineTitle: Int = 2
        static let multiLineSpacing: CGFloat = 2.0
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
        /// The possible text conigurations are:
        /// 1) Single-line Title
        /// 2) Two-line title
        /// 3) Single-line Title + single-line subtitle
        /// In all cases, the text height is: 2 * title's line height
        /// Use intrinsic height to support size category changes and the font line height when the string is truncated

        let heightBase: CGFloat = primaryLabel.intrinsicContentSize.height //isStringTruncated(string: primaryText, label: primaryLabel) ? primaryLabel.font.lineHeight : primaryLabel.intrinsicContentSize.height
        var height: CGFloat = ceil(2 * heightBase)

        switch style {
        case .horizontal:
            // title + subtitle? + icon
            height += (2 * Constants.horizontalPadding)

            layoutConstraints.append(contentsOf: [
                widthAnchor.constraint(equalToConstant: style.width),
                heightAnchor.constraint(equalToConstant: height),
                iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.paddingLeading),
                iconView.widthAnchor.constraint(equalToConstant: Constants.iconSize.width),
                iconView.heightAnchor.constraint(equalToConstant: Constants.iconSize.height),
                iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
                primaryLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: Constants.horizontalContentSpacing),
                primaryLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.horizontalPadding),
                primaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.paddingTrailing)
            ])

            if secondaryText != nil {
                layoutConstraints.append(contentsOf: [
                    secondaryLabel.leadingAnchor.constraint(equalTo: primaryLabel.leadingAnchor),
                    secondaryLabel.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor),
                    secondaryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.horizontalPadding),
                    secondaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.paddingTrailing)
                ])
            } else {
                layoutConstraints.append(contentsOf: [
                    primaryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.horizontalPadding)
                ])
            }
        case .vertical:
            // title + subtitle? + icon
            height += (Constants.verticalPaddingTop + Constants.iconSize.height + Constants.verticalContentSpacing + Constants.verticalPaddingBottom)
            if twoLineTitle {
                //height += Constants.multiLineSpacing
            }

            layoutConstraints.append(contentsOf: [
                widthAnchor.constraint(equalToConstant: style.width),
                heightAnchor.constraint(equalToConstant: height),
                iconView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalPaddingTop),
                iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.paddingLeading),
                iconView.widthAnchor.constraint(equalToConstant: Constants.iconSize.width),
                iconView.heightAnchor.constraint(equalToConstant: Constants.iconSize.height),
                primaryLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: Constants.verticalContentSpacing),
                primaryLabel.leadingAnchor.constraint(equalTo: iconView.leadingAnchor),
                primaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.paddingTrailing)
            ])
            if secondaryText != nil {
                layoutConstraints.append(contentsOf: [
                    secondaryLabel.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor),
                    secondaryLabel.leadingAnchor.constraint(equalTo: iconView.leadingAnchor),
                    secondaryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalPaddingBottom),
                    secondaryLabel.trailingAnchor.constraint(equalTo: primaryLabel.trailingAnchor)
                ])
            } else {
                layoutConstraints.append(contentsOf: [
                    primaryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalPaddingBottom)
                ])
            }
        }

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func isStringTruncated(string: String, label: UILabel) -> Bool {
        return string.preferredSize(for: label.font).width > label.frame.width
    }

    @objc private func handleCardTapped(_ recognizer: UITapGestureRecognizer) {
        delegate?.didTapCard?(self)
    }
}
