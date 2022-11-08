//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: TooltipView

class TooltipViewController: UIViewController {

    init(message: String,
         title: String? = nil,
         textAlignment: NSTextAlignment,
         positionController: TooltipPositionController,
         tokenSet: TooltipTokenSet) {
        self.message = message
        self.titleMessage = title
        self.positionController = positionController
        self.tokenSet = tokenSet

        arrowImageViewBaseImage = UIImage.staticImageNamed("tooltip-arrow")
        arrowImageView = UIImageView(image: arrowImageViewBaseImage)
        arrowImageView.image = arrowImageViewBaseImage?.withTintColor(UIColor(dynamicColor: tokenSet[.tooltipColor].dynamicColor), renderingMode: .alwaysOriginal)

        super.init(nibName: nil, bundle: nil)

        isAccessibilityElement = true

        view.addSubview(backgroundView)

        arrowImageView.transform = transformForArrowImageView()
        view.addSubview(arrowImageView)

        messageLabel.text = message
        messageLabel.textAlignment = textAlignment

        if let titleLabel = titleLabel, let title = title {
            titleLabel.text = title
            titleLabel.textAlignment = textAlignment
        }

        view.addSubview(textContainer)

        // Shadow
        view.layer.insertSublayer(CALayer(), at: 0)
        view.layer.insertSublayer(CALayer(), at: 0)
        updateShadows(tokenSet: tokenSet)
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: nil) { _ in
            self.updateAppearance(tokenSet: self.tokenSet)
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        updateAppearance(tokenSet: tokenSet)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            viewWillLayoutSubviews()
        }
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

    let positionController: TooltipPositionController
    var tokenSet: TooltipTokenSet

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

    private func updateAppearance(tokenSet: TooltipTokenSet) {
        // Update tooltip size
        positionController.updateArrowDirectionAndTooltipSize(for: message, title: titleMessage, tokenSet: tokenSet)
        view.frame = positionController.tooltipRect
        backgroundView.frame = view.bounds
        arrowImageView.transform = transformForArrowImageView()
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
            arrowImageView.frame.origin.y = view.bounds.height - arrowImageView.frame.height
        case .left:
            arrowImageView.frame.origin.x = 0.0
            backgroundView.frame.origin.x = arrowImageView.frame.maxX
        case .right:
            arrowImageView.frame.origin.x = view.bounds.width - arrowImageView.frame.width
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
        let preferredMessageSize = TooltipViewController.labelSizeThatFits(textContainer.frame.size,
                                                                 text: message,
                                                                 isAccessibilityContentSize: isAccessibilityContentSize,
                                                                 tokenSet: tokenSet,
                                                                 isMessage: true)
        messageLabel.frame.size = preferredMessageSize
        if let titleLabel = titleLabel, let title = titleMessage {
            let preferredTitleSize = TooltipViewController.labelSizeThatFits(textContainer.frame.size,
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

    private func updateShadows(tokenSet: TooltipTokenSet) {
        let backgroundCornerRadius = tokenSet[.backgroundCornerRadius].float
        let shadowInfo = tokenSet[.shadowInfo].shadowInfo
        if let ambientShadow = view.layer.sublayers?[1] {
            ambientShadow.frame = view.bounds
            ambientShadow.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: backgroundCornerRadius).cgPath
            ambientShadow.shadowColor = UIColor(dynamicColor: shadowInfo.colorOne).cgColor
            ambientShadow.shadowOpacity = 1
            ambientShadow.shadowOffset = CGSize(width: shadowInfo.xOne, height: shadowInfo.yOne)
            ambientShadow.shadowRadius = shadowInfo.blurOne
        }

        if let perimeterShadow = view.layer.sublayers?[0] {
            perimeterShadow.frame = view.bounds
            perimeterShadow.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: backgroundCornerRadius).cgPath
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

    private let message: String
    private let titleMessage: String?

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = tokenSet[.backgroundCornerRadius].float
        view.layer.cornerCurve = .continuous
        view.backgroundColor = UIColor(dynamicColor: tokenSet[.tooltipColor].dynamicColor)

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
