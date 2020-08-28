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

@objc(MSFCardBackgroundStyle)
public enum CardBackgroundStyle: Int, CaseIterable {
	case appColor
	case neutral
	case custom
}

/// Card style can be announcement, xSmallHorizontal, xSmallVertical, small, or medium)
/// announcement has  a title, a subtitle, and a button that are centrally aligned, and a featured image (the card is not clickable other than the button)
/// small and medium styles have a title, a subtitle, an icon and a featured image. The whole card is clickable
/// xSmall styles have a title, an icon and an optional subtitle. The whole card is clickable
@objc(MSFCardStyle)
public enum CardStyle: Int, CaseIterable {
    case xSmallHorizontal
    case xSmallVertical
    case small
    case medium
    case announcement

    var imageHeight: CGFloat {
        switch self {
        case .medium:
            return 128
        case .small:
            return 76
        case .announcement:
            return 100
        case .xSmallHorizontal, .xSmallVertical:
            return .zero
        }
    }

    var iconSize: CGSize {
        switch self {
        case .medium, .small:
            return CGSize(width: 16, height: 16)
        case .xSmallHorizontal, .xSmallVertical:
            return CGSize(width: 18, height: 18)
        case .announcement:
            return .zero
        }
    }

	var textAlignment: NSTextAlignment {
		switch self {
		case .announcement:
			return NSTextAlignment.center
		default:
			return NSTextAlignment.left
		}
	}

    var cardMinWidth: CGFloat {
       switch self {
       case .medium:
            return 228
       case .small:
            return 135
       case .xSmallHorizontal:
           return 156
       case .xSmallVertical:
            return 120
       case .announcement:
           return 334
       }
   }
}

/**
`CardView` is a UIView used to display information in a card.

A card has a title, a style, a background style,  and the following optional components; subtitle, icon, featured image, and a button.
Refer to the `CardStyle` documentation for a detailed description of components in each CardView style.

Use `titleNumberOfLines` and `subtitleNumberOfLines`  to set the number of lines the title and subtitle should have respectively. When the string can not fit in the number of lines set, it will get truncated.

Use one of the defined background styles for appColor or a neutral grey color.
When CardBackgroundStyle.custom is used, a default color will be set unless a background color is provided by setting the `cardBackgroundColor` property.

Conform to the `CardDelegate` in order to provide a handler for tap events. All CardView styles are clickable other than announcement, which has a dedicatred button inside the card.
*/
@objc(MSFCardView)
open class CardView: UIView {
    /// delegate to handle user interaction with the CardView
    @objc public weak var delegate: CardDelegate?

	@objc open var style: CardStyle = .medium {
		didSet {
            if style != oldValue {
                configureSubviews()
            }
        }
	}
	@objc open var image: UIImage? {
		didSet {
            if image != oldValue {
				if let imageView = imageView {
					imageView.image = image
				}
            }
        }
	}
	@objc open var buttonTitle: String? {
		didSet {
			if buttonTitle != oldValue {
				if let button = button {
					button.setTitle(buttonTitle, for: .normal)
				}
			}
		}
	}
	@objc open var primaryText: String {
		didSet {
			if primaryText != oldValue {
				primaryLabel.text = primaryText
				setupLayoutConstraints()
			}
		}
	}
    @objc open var secondaryText: String? {
        didSet {
            if secondaryText != oldValue {
				secondaryLabel.text = secondaryText
                setupLayoutConstraints()
            }
        }
    }
    @objc open var icon: UIImage? {
        didSet {
            if icon != oldValue {
				if let iconView = iconView {
					iconView.image = icon
				}
            }
        }
    }
	@objc open var backgroundStyle: CardBackgroundStyle = .neutral {
		didSet {
			if backgroundStyle != oldValue {
				setupBackgroundColor()
			}
		}
	}
    @objc open var titleNumberOfLines: Int = Constants.titleDefaultNumberOfLines {
        didSet {
            if titleNumberOfLines != oldValue {
				primaryLabel.numberOfLines = titleNumberOfLines
				setupLayoutConstraints()
            }
        }
    }
    @objc open var subtitleNumberOfLines: Int = Constants.subtitleDefaultNumberOfLines {
        didSet {
			if subtitleNumberOfLines != oldValue {
				secondaryLabel.numberOfLines = subtitleNumberOfLines
				setupLayoutConstraints()
           }
       }
    }
	@objc open var cardBackgroundColor: UIColor = Constants.defualtBackgroundColor {
		didSet {
			if cardBackgroundColor != oldValue {
				setupBackgroundColor()
			}
		}
	}

    /**
        Initializes `CardView`

        - Parameter style: The style of the card
        - Parameter title: The title of the card
        - Parameter subtitle: The subtitle of the card - optional
        - Parameter icon: The icon of the card - optional
        - Parameter image: The featured image of the card (small, medium, or announcement) - optional
        - Parameter backgroundStyle: The Card's background style; appColor, neutral, or custom.
        - Parameter buttonTitle: The button's title (announcement type only) - optional
    **/
	@objc public init(style: CardStyle, title: String, subtitle: String? = nil, icon: UIImage? = nil, image: UIImage? = nil, backgroundStyle: CardBackgroundStyle, buttonTitle: String? = nil) {
        self.primaryText = title
        self.style = style
		self.secondaryText = subtitle
        self.icon = icon
        self.image = image
		self.buttonTitle = buttonTitle
		self.backgroundStyle = backgroundStyle

        super.init(frame: .zero)

        configureSubviews()
    }

    @available(*, unavailable)
    @objc public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

	private func configureSubviews() {
        translatesAutoresizingMaskIntoConstraints = false

        // view border and background
		layer.borderColor = Constants.borderColor.cgColor
        layer.borderWidth = Constants.borderWidth
        layer.cornerRadius = Constants.borderRadius
        setupBackgroundColor()

        if style != .announcement {
			let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCardTapped(_:)))
            addGestureRecognizer(tapGesture)
        }

        // Title
        primaryLabel.text = self.primaryText
        primaryLabel.numberOfLines = titleNumberOfLines
		primaryLabel.textAlignment = style.textAlignment
        addSubview(primaryLabel)

        // Subtitle
        if let secondaryText = secondaryText {
            secondaryLabel.text = secondaryText
            secondaryLabel.numberOfLines = subtitleNumberOfLines
			secondaryLabel.textAlignment = style.textAlignment
            addSubview(secondaryLabel)
        }

        // Icon
        if let icon = icon {
            let iconView = UIImageView(image: icon)
            iconView.translatesAutoresizingMaskIntoConstraints = false
			self.iconView = iconView
			addSubview(iconView)
        }

        // Featured Image
        if let image = image {
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
			self.imageView = imageView
			addSubview(imageView)
        }

		// Card button - for style 'announcement' only
		if style == .announcement {
			if let buttonTitle = buttonTitle {
				let button = Button(style: .borderless)
				button.setTitle(buttonTitle, for: .normal)
				button.addTarget(self, action: #selector(handleCardTapped(_:)), for: .touchUpInside)
				button.translatesAutoresizingMaskIntoConstraints = false
				self.button = button
				addSubview(button)
			}
		}

		setupLayoutConstraints()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        // Round the top corners to fit the image inside the card
        if let imageView = imageView {
           let roundTopCornersMask = CAShapeLayer()
           roundTopCornersMask.path = UIBezierPath(roundedRect: imageView.frame, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: Constants.borderRadius, height: Constants.borderRadius)).cgPath
           imageView.layer.mask = roundTopCornersMask
           imageView.layer.masksToBounds = true
       }
    }

	/// Set up the background color of the card and update the icon and text color if necessary
	private func setupBackgroundColor() {
		var color: UIColor = Constants.defualtBackgroundColor

		switch backgroundStyle {
		case .appColor:
            if let window = window {
                color = Colors.primaryTint40(for: window)
				primaryLabel.textColor = Colors.primaryShade20(for: window)
				secondaryLabel.textColor = Colors.primaryShade20(for: window)
				iconView?.tintColor = Colors.primaryShade20(for: window)
			}
		case .neutral:
			color = Colors.Button.background // TODO: will be updated to the right value once I have the values from design
		case .custom:
			color = cardBackgroundColor
        }

		self.backgroundColor = color
    }

    private struct Constants {
		static let defualtBackgroundColor: UIColor = Colors.surfacePrimary
        static let borderWidth: CGFloat = UIScreen.main.devicePixel
        static let borderRadius: CGFloat = 8.0
		static let borderColor = UIColor(light: Colors.gray100, dark: .clear)
        static let horizontalCardPaddingTopBottom: CGFloat = 6.0
        static let verticalCardPaddingBottom: CGFloat = 8.0
        static let verticalCardPaddingTop: CGFloat = 10.0
        static let cardPaddingTrailing: CGFloat = 16.0
        static let xSmallPaddingLeading: CGFloat = 12.0
        static let cardPaddingLeading: CGFloat = 10.0
        static let horizontalContentSpacing: CGFloat = 12.0
        static let verticalContentSpacing: CGFloat = 5.0
        static let titleDefaultNumberOfLines: Int = 2
        static let subtitleDefaultNumberOfLines: Int = 2
        static let smallContentSpacing: CGFloat = 2.0
		static let largeContentSpacing: CGFloat = 6.0
        static let largeHorizontalPadding: CGFloat = 16.0
        static let largeVerticalPadding: CGFloat = 14.0
    }

    private var iconView: UIImageView?

    private var button: UIButton?

    private var imageView: UIImageView?

    private let primaryLabel: UILabel = {
        let primaryLabel = UILabel()
        primaryLabel.translatesAutoresizingMaskIntoConstraints = false
        primaryLabel.font = TextStyle.subhead.font
        primaryLabel.textColor = Colors.textPrimary
        primaryLabel.textAlignment = .left
        return primaryLabel
    }()

    private let secondaryLabel: UILabel = {
        let secondaryLabel = UILabel()
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.font = TextStyle.footnote.font
        secondaryLabel.textColor = Colors.textSecondary
        secondaryLabel.textAlignment = .left
        return secondaryLabel
    }()

    private var layoutConstraints: [NSLayoutConstraint] = []

    private func setupLayoutConstraints() {
        if layoutConstraints.count > 0 {
            NSLayoutConstraint.deactivate(layoutConstraints)
            layoutConstraints.removeAll()
        }

        let titleHeight = primaryLabel.intrinsicContentSize.height
        let subtitleHeight = secondaryText != nil ? secondaryLabel.intrinsicContentSize.height : 0
        var height: CGFloat = titleHeight + subtitleHeight

        switch style {
        case .medium, .small:
			// background image + title + subtitle + icon
			height += (style.imageHeight + Constants.verticalContentSpacing + Constants.verticalCardPaddingBottom)

			layoutConstraints.append(contentsOf: [
				heightAnchor.constraint(greaterThanOrEqualToConstant: height),
				widthAnchor.constraint(greaterThanOrEqualToConstant: style.cardMinWidth),
				primaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cardPaddingLeading),
				primaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.cardPaddingTrailing),
				secondaryLabel.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor),
				secondaryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalCardPaddingBottom),
				secondaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.cardPaddingTrailing)
			])

			if let imageView = imageView {
				layoutConstraints.append(contentsOf: [
					imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
					imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
					imageView.topAnchor.constraint(equalTo: topAnchor),
					imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: style.imageHeight),
					primaryLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.verticalContentSpacing)
				])
			}

			if let iconView = iconView {
				layoutConstraints.append(contentsOf: [
					iconView.widthAnchor.constraint(equalToConstant: style.iconSize.width),
					iconView.heightAnchor.constraint(equalToConstant: style.iconSize.height),
					iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cardPaddingLeading),
					iconView.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor, constant: Constants.smallContentSpacing),
					iconView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9.0),
					secondaryLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: Constants.smallContentSpacing)
				])
			}
        case .xSmallHorizontal:
			// title + subtitle? + icon
			height += (2 * Constants.horizontalCardPaddingTopBottom)

			layoutConstraints.append(contentsOf: [
				widthAnchor.constraint(greaterThanOrEqualToConstant: style.cardMinWidth),
				heightAnchor.constraint(greaterThanOrEqualToConstant: height),
				primaryLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.horizontalCardPaddingTopBottom),
				primaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.cardPaddingTrailing)
			])

			if let iconView = iconView {
				layoutConstraints.append(contentsOf: [
					iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.xSmallPaddingLeading),
					iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
					iconView.widthAnchor.constraint(equalToConstant: style.iconSize.width),
					iconView.heightAnchor.constraint(equalToConstant: style.iconSize.height),
					primaryLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: Constants.horizontalContentSpacing)
				])
			}

			if secondaryText != nil {
				if let iconView = iconView {
					layoutConstraints.append(secondaryLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: Constants.horizontalContentSpacing))
				}
				layoutConstraints.append(contentsOf: [
					primaryLabel.bottomAnchor.constraint(equalTo: secondaryLabel.topAnchor),
					secondaryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.horizontalCardPaddingTopBottom),
					secondaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.cardPaddingTrailing)
				])
			} else {
				layoutConstraints.append(contentsOf: [
					primaryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.horizontalCardPaddingTopBottom)
				])
			}
        case .xSmallVertical:
                // title + subtitle? + icon
                height += (Constants.verticalCardPaddingTop + style.iconSize.height + Constants.verticalContentSpacing + Constants.verticalCardPaddingBottom)

                layoutConstraints.append(contentsOf: [
                    widthAnchor.constraint(greaterThanOrEqualToConstant: style.cardMinWidth),
                    heightAnchor.constraint(greaterThanOrEqualToConstant: height),
                    primaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.xSmallPaddingLeading),
                    primaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.cardPaddingTrailing)
                ])

				if let iconView = iconView {
					layoutConstraints.append(contentsOf: [
						iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.xSmallPaddingLeading),
						iconView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalCardPaddingTop),
						iconView.widthAnchor.constraint(equalToConstant: style.iconSize.width),
						iconView.heightAnchor.constraint(equalToConstant: style.iconSize.height),
						primaryLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: Constants.verticalContentSpacing)
					])
				}
                if secondaryText != nil {
                  layoutConstraints.append(contentsOf: [
                      secondaryLabel.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor),
                      secondaryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalCardPaddingBottom),
                      secondaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.xSmallPaddingLeading),
                      secondaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.cardPaddingTrailing)
                  ])
              } else {
                  layoutConstraints.append(contentsOf: [
                      primaryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalCardPaddingBottom)
                  ])
              }
        case .announcement:
			// featured image + title + subtitle + button
		   height += (style.imageHeight + Constants.verticalContentSpacing + Constants.verticalCardPaddingBottom)

		   layoutConstraints.append(contentsOf: [
				heightAnchor.constraint(greaterThanOrEqualToConstant: height),
				widthAnchor.constraint(greaterThanOrEqualToConstant: style.cardMinWidth),
				primaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.largeHorizontalPadding),
				primaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.largeHorizontalPadding),
				secondaryLabel.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor, constant: Constants.largeContentSpacing),
				secondaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.largeHorizontalPadding),
				secondaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.largeHorizontalPadding)
			 ])

			if let button = button {
				layoutConstraints.append(contentsOf: [
					button.centerXAnchor.constraint(equalTo: centerXAnchor),
                    button.topAnchor.constraint(equalTo: secondaryLabel.bottomAnchor, constant: Constants.largeVerticalPadding),
                    button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.largeVerticalPadding)
				])
			}

			if let imageView = imageView {
				layoutConstraints.append(contentsOf: [
					imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
					imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
					imageView.topAnchor.constraint(equalTo: topAnchor),
					imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: style.imageHeight),
					primaryLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.largeVerticalPadding)
				])
			}
		}

		NSLayoutConstraint.activate(layoutConstraints)
    }

    @objc private func handleCardTapped(_ recognizer: UITapGestureRecognizer) {
        delegate?.didTapCard?(self)
      }
}
