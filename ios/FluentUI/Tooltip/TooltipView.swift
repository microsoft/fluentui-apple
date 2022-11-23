//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: TooltipView

class TooltipView: UIView {

    init(message: String,
         title: String? = nil,
         textAlignment: NSTextAlignment,
         tokenSet: TooltipTokenSet) {
        self.message = message
        self.titleMessage = title
        self.tokenSet = tokenSet

        arrowImageViewBaseImage = UIImage.staticImageNamed("tooltip-arrow")
        arrowImageView = UIImageView(image: arrowImageViewBaseImage)
        arrowImageView.image = arrowImageViewBaseImage?.withTintColor(UIColor(dynamicColor: tokenSet[.tooltipColor].dynamicColor), renderingMode: .alwaysOriginal)

        super.init(frame: .zero)

        self.addSubview(backgroundView)
        self.accessibilityViewIsModal = true

        arrowImageView.transform = transformForArrowImageView()
        self.addSubview(arrowImageView)

        messageLabel.text = message
        messageLabel.textAlignment = textAlignment

        if let titleLabel = titleLabel, let title = title {
            titleLabel.text = title
            titleLabel.textAlignment = textAlignment
        }

        self.addSubview(textContainer)

        // Shadow
        self.layer.insertSublayer(CALayer(), at: 0)
        self.layer.insertSublayer(CALayer(), at: 0)
        updateShadows(tokenSet: tokenSet)

        self.isAccessibilityElement = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Returns the tooltip size
    static func sizeThatFits(_ size: CGSize,
                             message: String,
                             title: String? = nil,
                             isAccessibilityContentSize: Bool,
                             arrowDirection: Tooltip.ArrowDirection,
                             tokenSet: TooltipTokenSet) -> CGSize {
        let paddingVertical = (title != nil) ? TooltipTokenSet.paddingVerticalWithTitle : TooltipTokenSet.paddingVerticalWithoutTitle
        let totalPaddingHorizontal = 2 * TooltipTokenSet.paddingHorizontal
        let arrowHeight = tokenSet[.arrowHeight].float
        var textBoundingSize = size

        textBoundingSize.width -= totalPaddingHorizontal
        if !arrowDirection.isVertical {
            textBoundingSize.width -= arrowHeight
        }

        let messageLabelFittingSize = labelSizeThatFits(textBoundingSize,
                                                        text: message,
                                                        isAccessibilityContentSize: isAccessibilityContentSize,
                                                        tokenSet: tokenSet,
                                                        isMessage: true)
        var width = messageLabelFittingSize.width
        var height = messageLabelFittingSize.height

        if let title = title {
            let titleLabelFittingSize = labelSizeThatFits(textBoundingSize,
                                                          text: title,
                                                          isAccessibilityContentSize: isAccessibilityContentSize,
                                                          tokenSet: tokenSet,
                                                          isMessage: false)
            width = max(width, titleLabelFittingSize.width)
            height += titleLabelFittingSize.height
        }

        if arrowDirection.isVertical {
            height += arrowHeight
        } else {
            width += arrowHeight
        }

        height += (title != nil) ? (2 * paddingVertical) + TooltipTokenSet.spacingVertical : 2 * paddingVertical
        width += totalPaddingHorizontal

        return CGSize(width: width, height: height)
    }

    func updateAppearance(tokenSet: TooltipTokenSet) {
        // Update tokenSet
        self.tokenSet = tokenSet

        // Update tooltip origin and size
        TooltipViewController.updateArrowDirectionAndTooltipRect(for: message, title: titleMessage, tokenSet: tokenSet)
        self.frame.size = TooltipViewController.tooltipRect.size
        backgroundView.frame = self.bounds
        arrowImageView.transform = transformForArrowImageView()
        if TooltipViewController.arrowDirection.isVertical {
            arrowImageView.frame.origin.x = TooltipViewController.arrowPosition
            backgroundView.frame.size.height -= arrowImageView.frame.height
        } else {
            arrowImageView.frame.origin.y = TooltipViewController.arrowPosition
            backgroundView.frame.size.width -= arrowImageView.frame.width
        }

        switch TooltipViewController.arrowDirection {
        case .up:
            arrowImageView.frame.origin.y = 0.0
            backgroundView.frame.origin.y = arrowImageView.frame.maxY
        case .down:
            arrowImageView.frame.origin.y = self.bounds.height - arrowImageView.frame.height
        case .left:
            arrowImageView.frame.origin.x = 0.0
            backgroundView.frame.origin.x = arrowImageView.frame.maxX
        case .right:
            arrowImageView.frame.origin.x = self.bounds.width - arrowImageView.frame.width
        }

        // Update colors
        let textColor = UIColor(dynamicColor: tokenSet[.textColor].dynamicColor)
        backgroundView.backgroundColor = UIColor(dynamicColor: tokenSet[.tooltipColor].dynamicColor)
        messageLabel.textColor = textColor
        titleLabel?.textColor = textColor

        // Update fonts
        messageLabel.font = UIFont.fluent(tokenSet[.messageLabelTextStyle].fontInfo)
        if let titleLabel = titleLabel {
            titleLabel.font = UIFont.fluent(tokenSet[.titleLabelTextStyle].fontInfo)
        }

        // Update text container size
        backgroundView.layer.cornerRadius = tokenSet[.backgroundCornerRadius].float
        textContainer.frame = backgroundView.frame.insetBy(dx: TooltipTokenSet.paddingHorizontal, dy: (titleMessage != nil) ? TooltipTokenSet.paddingVerticalWithTitle : TooltipTokenSet.paddingVerticalWithoutTitle)
        let isAccessibilityContentSize = self.traitCollection.preferredContentSizeCategory.isAccessibilityCategory
        let preferredMessageSize = TooltipView.labelSizeThatFits(textContainer.frame.size,
                                                                 text: message,
                                                                 isAccessibilityContentSize: isAccessibilityContentSize,
                                                                 tokenSet: tokenSet,
                                                                 isMessage: true)
        messageLabel.frame.size = preferredMessageSize
        if let titleLabel = titleLabel, let title = titleMessage {
            let preferredTitleSize = TooltipView.labelSizeThatFits(textContainer.frame.size,
                                                                   text: title,
                                                                   isAccessibilityContentSize: isAccessibilityContentSize,
                                                                   tokenSet: tokenSet,
                                                                   isMessage: false)
            titleLabel.frame.size = preferredTitleSize
            messageLabel.frame.origin = CGPoint(x: 0, y: titleLabel.frame.height + TooltipTokenSet.spacingVertical)
        }

        // Update shadows
        updateShadows(tokenSet: tokenSet)
    }

    // MARK: - Accessibility

    override var accessibilityLabel: String? {
        get {
            guard let title = titleMessage
            else {
                return message
            }

            return title + message
        }
        set { }
    }

    override var accessibilityHint: String? {
        get { return "Accessibility.Dismiss.Hint".localized }
        set { }
    }

    private func updateShadows(tokenSet: TooltipTokenSet) {
        let backgroundCornerRadius = tokenSet[.backgroundCornerRadius].float
        let shadowInfo = tokenSet[.shadowInfo].shadowInfo
        if let ambientShadow = self.layer.sublayers?[1] {
            ambientShadow.frame = self.bounds
            ambientShadow.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: backgroundCornerRadius).cgPath
            ambientShadow.shadowColor = UIColor(dynamicColor: shadowInfo.colorOne).cgColor
            ambientShadow.shadowOpacity = 1
            ambientShadow.shadowOffset = CGSize(width: shadowInfo.xOne, height: shadowInfo.yOne)
            ambientShadow.shadowRadius = shadowInfo.blurOne
        }

        if let perimeterShadow = self.layer.sublayers?[0] {
            perimeterShadow.frame = self.bounds
            perimeterShadow.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: backgroundCornerRadius).cgPath
            perimeterShadow.shadowColor = UIColor(dynamicColor: shadowInfo.colorTwo).cgColor
            perimeterShadow.shadowOpacity = 1
            perimeterShadow.shadowOffset = CGSize(width: shadowInfo.xTwo, height: shadowInfo.yTwo)
            perimeterShadow.shadowRadius = shadowInfo.blurTwo
        }
    }

    private static func labelSizeThatFits(_ size: CGSize,
                                          text: String,
                                          isAccessibilityContentSize: Bool,
                                          tokenSet: TooltipTokenSet,
                                          isMessage: Bool) -> CGSize {
        let boundingWidth = isAccessibilityContentSize ? size.width : min(tokenSet[.maximumWidth].float - (2 * TooltipTokenSet.paddingHorizontal), size.width)
        return text.preferredSize(for: UIFont.fluent(tokenSet[isMessage ? .messageLabelTextStyle : .titleLabelTextStyle].fontInfo), width: boundingWidth)
    }

    private func transformForArrowImageView() -> CGAffineTransform {
        switch TooltipViewController.arrowDirection {
        case .up:
            return CGAffineTransform.identity
        case .down:
            return CGAffineTransform(rotationAngle: .pi)
        case .left:
            return CGAffineTransform(rotationAngle: .pi * 1.5)
        case .right:
            return CGAffineTransform(rotationAngle: .pi * 0.5)
        }
    }

    private var tokenSet: TooltipTokenSet
    private let message: String
    private let titleMessage: String?
    private let arrowImageViewBaseImage: UIImage?
    private let arrowImageView: UIImageView

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = tokenSet[.backgroundCornerRadius].float
        view.layer.cornerCurve = .continuous
        view.backgroundColor = UIColor(dynamicColor: tokenSet[.tooltipColor].dynamicColor)

        return view
    }()

    private lazy var textContainer: UIView = {
        let view = UIView()
        view.addSubview(messageLabel)

        if let titleLabel = titleLabel {
            view.addSubview(titleLabel)
        }

        return view
    }()

    private lazy var messageLabel: UILabel = {
        let label = Label()
        label.font = UIFont.fluent(tokenSet[.messageLabelTextStyle].fontInfo)
        label.textColor = UIColor(dynamicColor: tokenSet[.textColor].dynamicColor)
        label.numberOfLines = 0
        label.lineBreakStrategy = []
        label.isAccessibilityElement = false
        return label
    }()

    private lazy var titleLabel: UILabel? = {
        if let title = titleMessage {
            let label = Label()
            label.font = UIFont.fluent(tokenSet[.titleLabelTextStyle].fontInfo)
            label.textColor = UIColor(dynamicColor: tokenSet[.textColor].dynamicColor)
            label.numberOfLines = 0
            label.lineBreakStrategy = []
            label.isAccessibilityElement = false
            return label
        }

        return nil
    }()
}
