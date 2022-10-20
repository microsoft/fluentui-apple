//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: TooltipView

class TooltipView: UIView {

    let positionController: TooltipPositionController

    private let message: String
    private let title: String?
    private let tooltipColor: UIColor
    private let textColor: UIColor
    private let backgroundCornerRadius: CGFloat
    private let messageLabelFont: UIFont
    private let titleLabelFont: UIFont
    private let paddingHorizontal: CGFloat
    private let paddingVertical: CGFloat
    private let spacingVertical: CGFloat
    private let maximumWidth: CGFloat

    private let shadowInfo: ShadowInfo

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = backgroundCornerRadius
        view.layer.cornerCurve = .continuous
        view.backgroundColor = tooltipColor

        return view
    }()

    private let arrowImageViewBaseImage: UIImage?
    private let arrowImageView: UIImageView

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
        label.font = messageLabelFont
        label.textColor = textColor
        label.numberOfLines = 0
        return label
    }()

    private lazy var titleLabel: UILabel? = {
        if let title = title {
            let label = Label()
            label.font = titleLabelFont
            label.textColor = textColor
            label.numberOfLines = 0
            return label
        }

        return nil
    }()

    init(message: String,
         title: String? = nil,
         tooltipColor: UIColor,
         textColor: UIColor,
         textAlignment: NSTextAlignment,
         positionController: TooltipPositionController,
         shadowInfo: ShadowInfo,
         backgroundCornerRadius: CGFloat,
         messageLabelFont: UIFont,
         titleLabelFont: UIFont,
         paddingHorizontal: CGFloat,
         paddingVertical: CGFloat,
         spacingVertical: CGFloat,
         maximumWidth: CGFloat) {
        self.message = message
        self.title = title
        self.tooltipColor = tooltipColor
        self.textColor = textColor
        self.positionController = positionController
        self.backgroundCornerRadius = backgroundCornerRadius
        self.messageLabelFont = messageLabelFont
        self.titleLabelFont = titleLabelFont
        self.paddingHorizontal = paddingHorizontal
        self.paddingVertical = paddingVertical
        self.spacingVertical = spacingVertical
        self.maximumWidth = maximumWidth

        self.shadowInfo = shadowInfo

        arrowImageViewBaseImage = UIImage.staticImageNamed("tooltip-arrow")
        arrowImageView = UIImageView(image: arrowImageViewBaseImage)
        arrowImageView.image = arrowImageViewBaseImage?.withTintColor(tooltipColor, renderingMode: .alwaysOriginal)

        super.init(frame: .zero)

        isAccessibilityElement = true

        addSubview(backgroundView)

        arrowImageView.transform = transformForArrowImageView()
        addSubview(arrowImageView)

        messageLabel.text = message
        messageLabel.textAlignment = textAlignment
        messageLabel.isAccessibilityElement = false

        if let titleLabel = titleLabel, let title = title {
            titleLabel.text = title
            titleLabel.textAlignment = textAlignment
            titleLabel.isAccessibilityElement = false
        }

        addSubview(textContainer)
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundView.frame = bounds

        if positionController.arrowDirection.isVertical {
            arrowImageView.frame.origin.x = positionController.arrowPosition
            backgroundView.frame.size.height -= arrowImageView.frame.height
        } else {
            arrowImageView.frame.origin.y = positionController.arrowPosition
            backgroundView.frame.size.width -= arrowImageView.frame.width
        }

        switch positionController.arrowDirection {
        case .up:
            arrowImageView.frame.origin.y = 0.0
            backgroundView.frame.origin.y = arrowImageView.frame.maxY
        case .down:
            arrowImageView.frame.origin.y = bounds.height - arrowImageView.frame.height
        case .left:
            arrowImageView.frame.origin.x = 0.0
            backgroundView.frame.origin.x = arrowImageView.frame.maxX
        case .right:
            arrowImageView.frame.origin.x = bounds.width - arrowImageView.frame.width
        }

        textContainer.frame = backgroundView.frame.insetBy(dx: paddingHorizontal, dy: paddingVertical)
        let preferredMessageSize = TooltipView.labelSizeThatFits(textContainer.frame.size,
                                                                 text: message,
                                                                 maximumWidth: maximumWidth,
                                                                 paddingHorizontal: 0,
                                                                 labelFont: messageLabelFont)
        messageLabel.frame.size = preferredMessageSize
        if let titleLabel = titleLabel, let title = title {
            let preferredTitleSize = TooltipView.labelSizeThatFits(textContainer.frame.size,
                                                                   text: title,
                                                                   maximumWidth: maximumWidth,
                                                                   paddingHorizontal: 0,
                                                                   labelFont: titleLabelFont)
            titleLabel.frame.size = preferredTitleSize
            messageLabel.frame.origin = CGPoint(x: 0, y: titleLabel.frame.height + spacingVertical)
        }

        // Shadow
        let ambientShadow = CALayer()
        ambientShadow.frame = bounds
        ambientShadow.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: backgroundCornerRadius).cgPath
        ambientShadow.shadowColor = UIColor(dynamicColor: shadowInfo.colorOne).cgColor
        ambientShadow.shadowOpacity = 1
        ambientShadow.shadowOffset = CGSize(width: shadowInfo.xOne, height: shadowInfo.yOne)
        ambientShadow.shadowRadius = shadowInfo.blurOne
        layer.insertSublayer(ambientShadow, at: 0)

        let perimeterShadow = CALayer()
        perimeterShadow.frame = bounds
        perimeterShadow.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: backgroundCornerRadius).cgPath
        perimeterShadow.shadowColor = UIColor(dynamicColor: shadowInfo.colorTwo).cgColor
        perimeterShadow.shadowOpacity = 1
        perimeterShadow.shadowOffset = CGSize(width: shadowInfo.xTwo, height: shadowInfo.yTwo)
        perimeterShadow.shadowRadius = shadowInfo.blurTwo
        layer.insertSublayer(perimeterShadow, at: 0)
    }

    func updateAppearance(tooltipColor: UIColor,
                          textColor: UIColor,
                          shadowInfo: ShadowInfo,
                          backgroundCornerRadius: CGFloat) {
        // Update colors
        backgroundView.backgroundColor = tooltipColor
        messageLabel.textColor = textColor
        titleLabel?.textColor = textColor

        // Update shadows
        layer.sublayers?.removeAll()
        let ambientShadow = CALayer()
        ambientShadow.frame = bounds
        ambientShadow.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: backgroundCornerRadius).cgPath
        ambientShadow.shadowColor = UIColor(dynamicColor: shadowInfo.colorOne).cgColor
        ambientShadow.shadowOpacity = 1
        ambientShadow.shadowOffset = CGSize(width: shadowInfo.xOne, height: shadowInfo.yOne)
        ambientShadow.shadowRadius = shadowInfo.blurOne
        layer.insertSublayer(ambientShadow, at: 0)

        let perimeterShadow = CALayer()
        perimeterShadow.frame = bounds
        perimeterShadow.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: backgroundCornerRadius).cgPath
        perimeterShadow.shadowColor = UIColor(dynamicColor: shadowInfo.colorTwo).cgColor
        perimeterShadow.shadowOpacity = 1
        perimeterShadow.shadowOffset = CGSize(width: shadowInfo.xTwo, height: shadowInfo.yTwo)
        perimeterShadow.shadowRadius = shadowInfo.blurTwo
        layer.insertSublayer(perimeterShadow, at: 0)

        // Update size
        backgroundView.layer.cornerRadius = backgroundCornerRadius
    }

    /// Returns the tooltip size
    static func sizeThatFits(_ size: CGSize,
                             message: String,
                             title: String? = nil,
                             arrowDirection: Tooltip.ArrowDirection,
                             arrowHeight: CGFloat,
                             totalPaddingVertical: CGFloat,
                             paddingHorizontal: CGFloat,
                             maximumWidth: CGFloat,
                             messageLabelFont: UIFont,
                             titleLabelFont: UIFont) -> CGSize {
        var textBoundingSize = size
        if arrowDirection.isVertical {
            textBoundingSize.height -= arrowHeight
        } else {
            textBoundingSize.width -= arrowHeight
        }
        textBoundingSize.height -= totalPaddingVertical
        let messageLabelFittingSize = labelSizeThatFits(textBoundingSize,
                                                        text: message,
                                                        maximumWidth: maximumWidth,
                                                        paddingHorizontal: paddingHorizontal,
                                                        labelFont: messageLabelFont)
        var width = messageLabelFittingSize.width + 2 * paddingHorizontal
        var height = messageLabelFittingSize.height + totalPaddingVertical

        if let title = title {
            let titleLabelFittingSize = labelSizeThatFits(textBoundingSize,
                                                          text: title,
                                                          maximumWidth: maximumWidth,
                                                          paddingHorizontal: paddingHorizontal,
                                                          labelFont: titleLabelFont)
            width = max(width, titleLabelFittingSize.width)
            height += titleLabelFittingSize.height
        }

        if arrowDirection.isVertical {
            height += arrowHeight
        } else {
            width += arrowHeight
        }
        return CGSize(width: width, height: height)
    }

    private static func labelSizeThatFits(_ size: CGSize,
                                          text: String,
                                          maximumWidth: CGFloat,
                                          paddingHorizontal: CGFloat,
                                          labelFont: UIFont) -> CGSize {
        let boundingWidth = min(maximumWidth, size.width) - 2 * paddingHorizontal
        return text.preferredSize(for: labelFont, width: boundingWidth)
    }

    private func transformForArrowImageView() -> CGAffineTransform {
        switch positionController.arrowDirection {
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

    // MARK: - Accessibility

    override var accessibilityLabel: String? {
        get { return messageLabel.text }
        set { }
    }

    override var accessibilityHint: String? {
        get { return "Accessibility.Dismiss.Hint".localized }
        set { }
    }
}
