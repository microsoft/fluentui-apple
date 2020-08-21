//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Delegate protocol to handle user interaction with the Card
@objc(MSFCardDelegate)
public protocol CardDelegate {
    /// Called after the Card or the button inside the Card is tapped
    /// - Parameter card: The Card that was tapped
    @objc optional func didTapCard(_ card: Card)
}

@objc(MSFCardBackgroundColor)
public enum CardBackgroundColor: Int, CaseIterable {
    case appColor   // app tint 40
    case white      // white
    case gray       // gray 50
}

/// Card style can be announcement, simplified (xSmallHorizontal, xSmallVertical), or complete (small, medium)
/// announcement has  a title, a subtitle, and a button that are centrally aligned, and a featured image (the card is not clickable other than the button)
/// complete styles have a title, a subtitle, an icon and a featured image. The whole card is clickable
/// simplified styles have a title, an icon and an optional subtitle. The whole card is clickable
@objc(MSFCardStyle)
public enum CardStyle: Int, CaseIterable {
    /// Simplified Card Styles
    case xSmallHorizontal
    case xSmallVertical
    /// Complete Card Styles
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
            return CGSize(width: 12, height: 10.4)
        case .xSmallHorizontal, .xSmallVertical:
            return CGSize(width: 18, height: 18)
        case .announcement:
            return CGSize.zero
        }
    }

    var primaryTextSize: CGFloat {
       switch self {
       case .medium, .small, .xSmallHorizontal, .xSmallVertical:
           return 15
       case .announcement:
           return 17
       }
   }

    var secondaryTextSize: CGFloat {
        switch self {
        case .medium, .small, .xSmallHorizontal, .xSmallVertical:
            return 13
        case .announcement:
            return 15
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

@objc(MSFCard)
open class Card: UIView {
    /// delegate to handle user interaction with the Card
    @objc public weak var delegate: CardDelegate?

    @objc open var style: CardStyle = .medium
    @objc open var image: UIImage?
    @objc open var buttonTitle: String?
    @objc open var primaryText: String
    @objc open var secondaryText: String? {
        didSet {
            if secondaryText != oldValue {
                setupLayoutConstraints()
            }
        }
    }
    @objc open var icon: UIImage? {
        didSet {
            if icon != oldValue {
                setupLayoutConstraints()
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

    /**
        Initializes `Card` of simplified style; xSmallVertical or xSmallHorizontal

        - Parameter style: The style of the card; xSmallVertical or xSmallHorizontal
        - Parameter title: The title of the card
        - Parameter subtitle: The subtitle of the card - optional
        - Parameter icon: The icon of the card. Appears on the top in vertical card styles, and next to the title in horizontal card styles
        - Parameter backgroundColor: The Card's background color
    **/
    @objc public init(simplifiedStyle style: CardStyle, title: String, subtitle: String? = nil, icon: UIImage, backgroundColor: CardBackgroundColor) {
        self.primaryText = title
        self.secondaryText = subtitle
        self.icon = icon
        self.style = style

        super.init(frame: .zero)

        configureSubviews(backgroundColor: backgroundColor)
    }

    /**
        Initializes `Card` of Card Style: announcement

        - Parameter style: The style of the card; xSmallVertical or xSmallHorizontal
        - Parameter title: The title of the card
        - Parameter subtitle: The subtitle of the card - optional
        - Parameter button: The button of the card, appears below the subtitle
        - Parameter image: The announcement image
        - Parameter backgroundColor: The Card's background color
    **/
    @objc public init(announementCardTitle title: String, subtitle: String, buttonTitle: String, image: UIImage, backgroundColor: CardBackgroundColor) {
        self.primaryText = title
        self.secondaryText = subtitle
        self.buttonTitle = buttonTitle
        self.image = image
        self.style = .announcement

        super.init(frame: .zero)

        button = Button(style: .borderless)
        button!.setTitle(buttonTitle, for: .normal)
        button!.titleLabel?.font.withSize(style.secondaryTextSize)
        button!.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button!)

        configureSubviews(backgroundColor: backgroundColor)
    }

    /**
        Initializes `Card` of complete style; small or medium

        - Parameter style: The style of the card; small or medium
        - Parameter title: The title of the card
        - Parameter subtitle: The subtitle of the card
        - Parameter icon: The icon of the card
        - Parameter backgroundColor: The Card's background color
    **/
    @objc public init(style: CardStyle, title: String, subtitle: String, icon: UIImage, image: UIImage, backgroundColor: CardBackgroundColor) {
        self.primaryText = title
        self.secondaryText = subtitle
        self.icon = icon
        self.image = image
        self.style = style

        super.init(frame: .zero)

       configureSubviews(backgroundColor: backgroundColor)
    }

    @available(*, unavailable)
    @objc public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    private func configureSubviews(backgroundColor: CardBackgroundColor) {
        translatesAutoresizingMaskIntoConstraints = false

        // view border and background
        layer.borderColor = Colors.gray100.cgColor
        layer.borderWidth = Constants.borderWidth
        layer.cornerRadius = Constants.borderRadius
        self.backgroundColor = cardBackgroundColor(color: backgroundColor)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCardTapped(_:)))
        if style == .announcement {
            button!.addTarget(self, action: #selector(handleCardTapped(_:)), for: .touchUpInside)
        } else {
            addGestureRecognizer(tapGesture)
        }

        // Title
        primaryLabel.text = self.primaryText
        primaryLabel.font.withSize(style.primaryTextSize)
        primaryLabel.numberOfLines = titleNumberOfLines
        primaryLabel.textAlignment = style == .announcement ? .center : .left
        addSubview(primaryLabel)

        // Subtitle
        if secondaryText != nil {
            secondaryLabel.text = secondaryText
            secondaryLabel.font.withSize(style.secondaryTextSize)
            secondaryLabel.numberOfLines = subtitleNumberOfLines
            secondaryLabel.textAlignment = style == .announcement ? .center : .left
            addSubview(secondaryLabel)
        }

        // Icon
        if icon != nil {
            iconView = UIImageView(image: icon)
            iconView!.translatesAutoresizingMaskIntoConstraints = false
            addSubview(iconView!)
        }

        // Featured Image
        if image != nil {
            imageView = UIImageView(image: image)
            imageView!.translatesAutoresizingMaskIntoConstraints = false
            addSubview(imageView!)
        }

        setupLayoutConstraints()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        // Round the top corners to fit the image inside the card
        if imageView != nil {
           let roundTopCornersMask = CAShapeLayer()
           roundTopCornersMask.path = UIBezierPath(roundedRect: imageView!.frame, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: Constants.borderRadius, height: Constants.borderRadius)).cgPath
           imageView!.layer.mask = roundTopCornersMask
           imageView!.layer.masksToBounds = true
       }
    }

    private func cardBackgroundColor(color: CardBackgroundColor) -> UIColor {
        switch color {
        case .appColor:
            if let window = window {
                return Colors.primaryTint20(for: window)
            }
            return Colors.gray50
        case .gray:
            return Colors.gray50
        case .white:
            return .white
        }
    }

    private struct Constants {
        static let borderWidth: CGFloat = 0.5
        static let borderRadius: CGFloat = 8.0
        static let borderColor: UIColor = Colors.gray100
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
                    heightAnchor.constraint(equalToConstant: height),
                    widthAnchor.constraint(greaterThanOrEqualToConstant: style.cardMinWidth),
                    imageView!.leadingAnchor.constraint(equalTo: leadingAnchor),
                    imageView!.trailingAnchor.constraint(equalTo: trailingAnchor),
                    imageView!.topAnchor.constraint(equalTo: topAnchor),
                    imageView!.heightAnchor.constraint(equalToConstant: style.imageHeight),
                    iconView!.widthAnchor.constraint(equalToConstant: style.iconSize.width),
                    iconView!.heightAnchor.constraint(equalToConstant: style.iconSize.height),
                    iconView!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cardPaddingLeading),
                    iconView!.centerYAnchor.constraint(equalTo: secondaryLabel.centerYAnchor),
                    primaryLabel.topAnchor.constraint(equalTo: imageView!.bottomAnchor, constant: Constants.verticalContentSpacing),
                    primaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cardPaddingLeading),
                    primaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.cardPaddingTrailing),
                    secondaryLabel.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor),
                    secondaryLabel.leadingAnchor.constraint(equalTo: iconView!.trailingAnchor, constant: Constants.verticalContentSpacing),
                    secondaryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalCardPaddingBottom),
                    secondaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.cardPaddingTrailing)
                ])
        case .xSmallHorizontal:
                // title + subtitle? + icon
                height += (2 * Constants.horizontalCardPaddingTopBottom)

                layoutConstraints.append(contentsOf: [
                    widthAnchor.constraint(greaterThanOrEqualToConstant: style.cardMinWidth),
                    heightAnchor.constraint(equalToConstant: height),
                    iconView!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.xSmallPaddingLeading),
                    iconView!.centerYAnchor.constraint(equalTo: centerYAnchor),
                    iconView!.widthAnchor.constraint(equalToConstant: style.iconSize.width),
                    iconView!.heightAnchor.constraint(equalToConstant: style.iconSize.height),
                    primaryLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.horizontalCardPaddingTopBottom),
                    primaryLabel.leadingAnchor.constraint(equalTo: iconView!.trailingAnchor, constant: Constants.horizontalContentSpacing),
                    primaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.cardPaddingTrailing)
                ])

                if secondaryText != nil {
                    layoutConstraints.append(contentsOf: [
                        primaryLabel.bottomAnchor.constraint(equalTo: secondaryLabel.topAnchor),
                        secondaryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.horizontalCardPaddingTopBottom),
                        secondaryLabel.leadingAnchor.constraint(equalTo: iconView!.trailingAnchor, constant: Constants.horizontalContentSpacing),
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
                    iconView!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.xSmallPaddingLeading),
                    iconView!.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalCardPaddingTop),
                    iconView!.widthAnchor.constraint(equalToConstant: style.iconSize.width),
                    iconView!.heightAnchor.constraint(equalToConstant: style.iconSize.height),
                    primaryLabel.topAnchor.constraint(equalTo: iconView!.bottomAnchor, constant: Constants.verticalContentSpacing),
                    primaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.xSmallPaddingLeading),
                    primaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.cardPaddingTrailing)
                ])

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
               height += (image!.size.height + Constants.verticalContentSpacing + Constants.verticalCardPaddingBottom)

               layoutConstraints.append(contentsOf: [
                    heightAnchor.constraint(equalToConstant: height),
                    widthAnchor.constraint(greaterThanOrEqualToConstant: style.cardMinWidth),
                    imageView!.leadingAnchor.constraint(equalTo: leadingAnchor),
                    imageView!.trailingAnchor.constraint(equalTo: trailingAnchor),
                    imageView!.topAnchor.constraint(equalTo: topAnchor),
                    imageView!.heightAnchor.constraint(equalToConstant: style.imageHeight),
                    primaryLabel.topAnchor.constraint(equalTo: imageView!.bottomAnchor, constant: Constants.largeVerticalPadding),
                    primaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.largeHorizontalPadding),
                    primaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.largeHorizontalPadding),
                    secondaryLabel.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor, constant: Constants.largeContentSpacing),
                    secondaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.largeHorizontalPadding),
                    secondaryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.largeHorizontalPadding),
                    button!.centerXAnchor.constraint(equalTo: centerXAnchor),
                    button!.topAnchor.constraint(equalTo: secondaryLabel.bottomAnchor, constant: Constants.largeVerticalPadding),
                    button!.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.largeVerticalPadding)
                 ])
        }

        NSLayoutConstraint.activate(layoutConstraints)
    }

    @objc private func handleCardTapped(_ recognizer: UITapGestureRecognizer) {
        delegate?.didTapCard?(self)
      }
}
