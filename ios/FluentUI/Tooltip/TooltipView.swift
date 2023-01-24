//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: TooltipView
<<<<<<< HEAD

class TooltipView: UIView, Shadowable {

    var shadow1: CALayer?
    var shadow2: CALayer?

    private struct Constants {
        static let messageLabelTextStyle: TextStyle = .subhead
||||||| d6f35783

class TooltipView: UIView {
    private struct Constants {
        static let messageLabelTextStyle: TextStyle = .subhead
=======
class TooltipView: UIView {
>>>>>>> main

<<<<<<< HEAD
        static let maximumWidth: CGFloat = 500

        static let paddingHorizontal: CGFloat = 13
        static let totalPaddingVertical: CGFloat = 12
    }

    static let backgroundCornerRadius: CGFloat = 8
    static let arrowSize = CGSize(width: 14.0, height: 7.0)

    /// Returns the tooltip size
    static func sizeThatFits(_ size: CGSize, message: String, arrowDirection: Tooltip.ArrowDirection) -> CGSize {
        var messageBoundingSize = size
        if arrowDirection.isVertical {
            messageBoundingSize.height -= arrowSize.height
        } else {
            messageBoundingSize.width -= arrowSize.height
        }
        messageBoundingSize.height -= Constants.totalPaddingVertical
        let messageLabelFittingSize = messageLabelSizeThatFits(messageBoundingSize, message: message)
        var width = messageLabelFittingSize.width + 2 * Constants.paddingHorizontal
        var height = messageLabelFittingSize.height + Constants.totalPaddingVertical
        if arrowDirection.isVertical {
            height += arrowSize.height
        } else {
            width += arrowSize.height
        }
        return CGSize(width: width, height: height)
    }

    private static func messageLabelSizeThatFits(_ size: CGSize, message: String) -> CGSize {
        let boundingWidth = min(Constants.maximumWidth, size.width) - 2 * Constants.paddingHorizontal
        return message.preferredSize(for: Constants.messageLabelTextStyle.font, width: boundingWidth)
    }

    let positionController: TooltipPositionController

    private let message: String

    private let backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = backgroundCornerRadius
        view.layer.cornerCurve = .continuous

        return view
    }()

    private let arrowImageViewBaseImage: UIImage?
    private let arrowImageView: UIImageView

    private let messageLabel: UILabel = {
        let label = Label(style: Constants.messageLabelTextStyle)
        label.numberOfLines = 0
        return label
    }()

    init(message: String, textAlignment: NSTextAlignment, positionController: TooltipPositionController) {
||||||| d6f35783
        static let shadowRadius: CGFloat = 4
        static let shadowOffset: CGFloat = 2
        static let shadowOpacity: Float = 0.24

        static let maximumWidth: CGFloat = 500

        static let paddingHorizontal: CGFloat = 13
        static let totalPaddingVertical: CGFloat = 12
    }

    static let backgroundCornerRadius: CGFloat = 8
    static let arrowSize = CGSize(width: 14.0, height: 7.0)

    /// Returns the tooltip size
    static func sizeThatFits(_ size: CGSize, message: String, arrowDirection: Tooltip.ArrowDirection) -> CGSize {
        var messageBoundingSize = size
        if arrowDirection.isVertical {
            messageBoundingSize.height -= arrowSize.height
        } else {
            messageBoundingSize.width -= arrowSize.height
        }
        messageBoundingSize.height -= Constants.totalPaddingVertical
        let messageLabelFittingSize = messageLabelSizeThatFits(messageBoundingSize, message: message)
        var width = messageLabelFittingSize.width + 2 * Constants.paddingHorizontal
        var height = messageLabelFittingSize.height + Constants.totalPaddingVertical
        if arrowDirection.isVertical {
            height += arrowSize.height
        } else {
            width += arrowSize.height
        }
        return CGSize(width: width, height: height)
    }

    private static func messageLabelSizeThatFits(_ size: CGSize, message: String) -> CGSize {
        let boundingWidth = min(Constants.maximumWidth, size.width) - 2 * Constants.paddingHorizontal
        return message.preferredSize(for: Constants.messageLabelTextStyle.font, width: boundingWidth)
    }

    let positionController: TooltipPositionController

    private let message: String

    private let backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = backgroundCornerRadius
        view.layer.cornerCurve = .continuous

        return view
    }()

    private let arrowImageViewBaseImage: UIImage?
    private let arrowImageView: UIImageView

    private let messageLabel: UILabel = {
        let label = Label(style: Constants.messageLabelTextStyle)
        label.textColor = Colors.Tooltip.text
        label.numberOfLines = 0
        return label
    }()

    init(message: String, textAlignment: NSTextAlignment, positionController: TooltipPositionController) {
=======
    init(anchorView: UIView,
         message: String,
         title: String? = nil,
         textAlignment: NSTextAlignment,
         preferredArrowDirection: Tooltip.ArrowDirection,
         offset: CGPoint,
         arrowMargin: CGFloat,
         tokenSet: TooltipTokenSet) {
        self.anchorView = anchorView
>>>>>>> main
        self.message = message
        self.titleMessage = title
        self.preferredArrowDirection = preferredArrowDirection
        self.offset = offset
        self.arrowMargin = arrowMargin
        self.tokenSet = tokenSet

        let arrowImageViewBaseImage = UIImage.staticImageNamed("tooltip-arrow")
        arrowImageView = UIImageView(image: arrowImageViewBaseImage)
        arrowImageView.image = arrowImageViewBaseImage?.withTintColor(UIColor(dynamicColor: tokenSet[.tooltipColor].dynamicColor), renderingMode: .alwaysOriginal)

        super.init(frame: .zero)

<<<<<<< HEAD
        updateColors()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)

        isAccessibilityElement = true

||||||| d6f35783
        isAccessibilityElement = true

=======
>>>>>>> main
        addSubview(backgroundView)
        accessibilityViewIsModal = true

        arrowImageView.transform = transformForArrowImageView()
        addSubview(arrowImageView)

        messageLabel.text = message
        messageLabel.textAlignment = textAlignment
<<<<<<< HEAD
        messageLabel.isAccessibilityElement = false
        addSubview(messageLabel)
||||||| d6f35783
        messageLabel.isAccessibilityElement = false
        addSubview(messageLabel)

        // Shadow
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowRadius = Constants.shadowRadius
        layer.shadowOffset = CGSize(width: 0.0, height: Constants.shadowOffset)
=======

        if let titleLabel = titleLabel, let title = title {
            titleLabel.text = title
            titleLabel.textAlignment = textAlignment
        }

        addSubview(textContainer)

        // TODO: Integrate with new applyShadow functionality
        // Shadow
        layer.insertSublayer(CALayer(), at: 0)
        layer.insertSublayer(CALayer(), at: 0)
        updateShadows()

        isAccessibilityElement = true
>>>>>>> main
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTooltipSizeAndOrigin() {
        updateArrowDirectionAndTooltipRect(for: message, title: titleMessage, tokenSet: tokenSet)
        frame.size = tooltipRect.size
        backgroundView.frame = bounds
        arrowImageView.transform = transformForArrowImageView()
        if arrowDirection.isVertical {
            arrowImageView.frame.origin.x = arrowPosition
            backgroundView.frame.size.height -= arrowImageView.frame.height
        } else {
            arrowImageView.frame.origin.y = arrowPosition
            backgroundView.frame.size.width -= arrowImageView.frame.width
        }

        switch arrowDirection {
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

<<<<<<< HEAD
        messageLabel.frame = backgroundView.frame.insetBy(dx: Constants.paddingHorizontal, dy: 0)
        updateShadow()
||||||| d6f35783
        messageLabel.frame = backgroundView.frame.insetBy(dx: Constants.paddingHorizontal, dy: 0)
=======
        updateTextContainerSize()
        updateShadows()
>>>>>>> main
    }

<<<<<<< HEAD
    @objc private func themeDidChange(_ notification: Notification) {
        guard let themeView = notification.object as? UIView, self.isDescendant(of: themeView) else {
            return
        }
        updateColors()
        updateShadow()
||||||| d6f35783
    override func didMoveToWindow() {
        super.didMoveToWindow()
        updateWindowSpecificColors()
=======
    func updateFonts() {
        messageLabel.font = UIFont.fluent(tokenSet[.messageLabelTextStyle].fontInfo)
        if let titleLabel = titleLabel {
            titleLabel.font = UIFont.fluent(tokenSet[.titleLabelTextStyle].fontInfo)
        }
    }

    func updateAppearance(tokenSet: TooltipTokenSet) {
        // Update tokenSet
        self.tokenSet = tokenSet

        updateFonts()
        updateTooltipSizeAndOrigin()
        updateColors()
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

    var tooltipRect: CGRect {
        return CGRect(origin: tooltipOrigin, size: tooltipSize)
    }

    private func updateArrowDirectionAndTooltipRect(for message: String, title: String? = nil, tokenSet: TooltipTokenSet) {
        let preferredBoundingRect = boundingRect.inset(by: anchorViewInset(for: preferredArrowDirection))
        let backupBoundingRect = boundingRect.inset(by: anchorViewInset(for: preferredArrowDirection.opposite))

        guard let window = anchorView?.window else {
            return
        }

        let isAccessibilityContentSize = window.traitCollection.preferredContentSizeCategory.isAccessibilityCategory
        let preferredSize = TooltipView.sizeThatFits(preferredBoundingRect.size,
                                                     message: message,
                                                     title: title,
                                                     isAccessibilityContentSize: isAccessibilityContentSize,
                                                     arrowDirection: preferredArrowDirection,
                                                     tokenSet: tokenSet)
        let backupSize = TooltipView.sizeThatFits(backupBoundingRect.size,
                                                  message: message,
                                                  title: title,
                                                  isAccessibilityContentSize: isAccessibilityContentSize,
                                                  arrowDirection: preferredArrowDirection.opposite,
                                                  tokenSet: tokenSet)
        var usePreferred = true
        if (preferredArrowDirection.isVertical &&
            preferredBoundingRect.height < preferredSize.height &&
            backupBoundingRect.height >= backupSize.height) ||
            (!preferredArrowDirection.isVertical &&
             preferredBoundingRect.width < preferredSize.width &&
             backupBoundingRect.width >= backupSize.width) {
            usePreferred = false
        }

        if usePreferred {
            arrowDirection = preferredArrowDirection
            tooltipSize = preferredSize
        } else {
            arrowDirection = preferredArrowDirection.opposite
            tooltipSize = backupSize
        }

        tooltipOrigin = idealTooltipOrigin
        if arrowDirection.isVertical {
            tooltipOrigin.x = max(boundingRect.minX, min(tooltipOrigin.x, boundingRect.maxX - tooltipSize.width))
        } else {
            tooltipOrigin.y = max(boundingRect.minY, min(tooltipOrigin.y, boundingRect.maxY - tooltipSize.height))
        }
        tooltipOrigin.x += offset.x
        tooltipOrigin.y += offset.y
    }

    private func updateTextContainerSize() {
        backgroundView.layer.cornerRadius = tokenSet[.backgroundCornerRadius].float
        textContainer.frame = backgroundView.frame.insetBy(dx: TooltipTokenSet.paddingHorizontal, dy: (titleMessage != nil) ? TooltipTokenSet.paddingVerticalWithTitle : TooltipTokenSet.paddingVerticalWithoutTitle)
        let isAccessibilityContentSize = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
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
    }

    private func updateColors() {
        let textColor = UIColor(dynamicColor: tokenSet[.textColor].dynamicColor)
        backgroundView.backgroundColor = UIColor(dynamicColor: tokenSet[.tooltipColor].dynamicColor)
        arrowImageView.image = arrowImageView.image?.withTintColor(UIColor(dynamicColor: tokenSet[.tooltipColor].dynamicColor), renderingMode: .alwaysOriginal)
        messageLabel.textColor = textColor
        titleLabel?.textColor = textColor
    }

    private func updateShadows() {
        let backgroundCornerRadius = tokenSet[.backgroundCornerRadius].float
        let shadowInfo = tokenSet[.shadowInfo].shadowInfo
        if let ambientShadow = layer.sublayers?[1] {
            ambientShadow.frame = bounds
            ambientShadow.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: backgroundCornerRadius).cgPath
            ambientShadow.shadowColor = UIColor(dynamicColor: shadowInfo.colorOne).cgColor
            ambientShadow.shadowOpacity = 1
            ambientShadow.shadowOffset = CGSize(width: shadowInfo.xOne, height: shadowInfo.yOne)
            ambientShadow.shadowRadius = shadowInfo.blurOne
        }

        if let perimeterShadow = layer.sublayers?[0] {
            perimeterShadow.frame = bounds
            perimeterShadow.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: backgroundCornerRadius).cgPath
            perimeterShadow.shadowColor = UIColor(dynamicColor: shadowInfo.colorTwo).cgColor
            perimeterShadow.shadowOpacity = 1
            perimeterShadow.shadowOffset = CGSize(width: shadowInfo.xTwo, height: shadowInfo.yTwo)
            perimeterShadow.shadowRadius = shadowInfo.blurTwo
        }
>>>>>>> main
    }

    private func transformForArrowImageView() -> CGAffineTransform {
        switch arrowDirection {
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

<<<<<<< HEAD
    private func updateShadow() {
        let shadowInfo = fluentTheme.aliasTokens.shadow[.shadow16]
        shadowInfo.applyShadow(to: backgroundView)
    }

    private func updateColors() {
        let backgroundColor = UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.backgroundDarkStatic])
        backgroundView.backgroundColor = backgroundColor
        arrowImageView.image = arrowImageViewBaseImage?.withTintColor(backgroundColor, renderingMode: .alwaysOriginal)
        messageLabel.textColor = UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foregroundLightStatic])
||||||| d6f35783
    private func updateWindowSpecificColors() {
        if let window = window {
            let backgroundColor = UIColor(light: Colors.gray900.withAlphaComponent(0.95), dark: Colors.primary(for: window))
            backgroundView.backgroundColor = backgroundColor
            arrowImageView.image = arrowImageViewBaseImage?.withTintColor(backgroundColor, renderingMode: .alwaysOriginal)
        }
=======
    /// Returns the tooltip size
    private static func sizeThatFits(_ size: CGSize,
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

    private static func labelSizeThatFits(_ size: CGSize,
                                          text: String,
                                          isAccessibilityContentSize: Bool,
                                          tokenSet: TooltipTokenSet,
                                          isMessage: Bool) -> CGSize {
        let boundingWidth = isAccessibilityContentSize ? size.width : min(tokenSet[.maximumWidth].float - (2 * TooltipTokenSet.paddingHorizontal), size.width)
        return text.preferredSize(for: UIFont.fluent(tokenSet[isMessage ? .messageLabelTextStyle : .titleLabelTextStyle].fontInfo), width: boundingWidth)
    }

    private var arrowPosition: CGFloat {
        let minPosition = arrowMargin
        let arrowWidth = tokenSet[.arrowWidth].float
        var idealPosition: CGFloat
        var maxPosition: CGFloat
        if arrowDirection.isVertical {
            idealPosition = sourcePointInWindow.x - tooltipRect.minX - arrowWidth / 2
            maxPosition = tooltipRect.width - arrowMargin - arrowWidth
        } else {
            idealPosition = sourcePointInWindow.y - tooltipRect.minY - arrowWidth / 2
            maxPosition = tooltipRect.height - arrowMargin - arrowWidth
        }
        return max(minPosition, min(idealPosition, maxPosition))
    }

    private var idealTooltipOrigin: CGPoint {
        switch arrowDirection {
        case .up:
            return CGPoint(x: sourcePointInWindow.x - tooltipSize.width / 2, y: sourcePointInWindow.y)
        case .down:
            return CGPoint(x: sourcePointInWindow.x - tooltipSize.width / 2, y: sourcePointInWindow.y - tooltipSize.height)
        case .left:
            return CGPoint(x: sourcePointInWindow.x, y: sourcePointInWindow.y - tooltipSize.height / 2)
        case .right:
            return CGPoint(x: sourcePointInWindow.x - tooltipSize.width, y: sourcePointInWindow.y - tooltipSize.height / 2)
        }
>>>>>>> main
    }

    private var sourcePointInAnchorView: CGPoint {
        guard let anchorView = anchorView else {
            assertionFailure("Can't find anchorView")
            return CGPoint.zero
        }

        switch arrowDirection {
        case .up:
            return CGPoint(x: anchorView.frame.width / 2, y: anchorView.frame.height)
        case .down:
            return CGPoint(x: anchorView.frame.width / 2, y: 0)
        case .right:
            return CGPoint(x: 0, y: anchorView.frame.height / 2)
        case .left:
            return CGPoint(x: anchorView.frame.width, y: anchorView.frame.height / 2)
        }
    }

    private var sourcePointInWindow: CGPoint {
        guard let anchorView = anchorView else {
            assertionFailure("Can't find anchorView")
            return CGPoint.zero
        }

        return anchorView.convert(sourcePointInAnchorView, to: window)
    }

    private var boundingRect: CGRect {
        let screenMargin = TooltipTokenSet.screenMargin
        guard let window = anchorView?.window else {
            assertionFailure("Can't find anchorView's window")
            return CGRect.zero
        }

        return window.bounds.inset(by: window.safeAreaInsets).inset(by: UIEdgeInsets(top: screenMargin,
                                                                                     left: screenMargin,
                                                                                     bottom: screenMargin,
                                                                                     right: screenMargin))
    }

    private func anchorViewInset(for arrowDirection: Tooltip.ArrowDirection) -> UIEdgeInsets {
        var inset = UIEdgeInsets.zero
        guard let anchorView = anchorView else {
            assertionFailure("Can't find anchorView")
            return inset
        }

        let anchorViewFrame = anchorView.convert(anchorView.bounds, to: window)
        switch arrowDirection {
        case .up:
            inset.top = max(anchorViewFrame.maxY - boundingRect.minY, 0)
        case .down:
            inset.bottom = max(boundingRect.maxY - anchorViewFrame.minY, 0)
        case .left:
            inset.left = max(anchorViewFrame.maxX - boundingRect.minX, 0)
        case .right:
            inset.right = max(boundingRect.maxX - anchorViewFrame.minX, 0)
        }
        return inset
    }

    private weak var anchorView: UIView?
    private let message: String
    private let titleMessage: String?
    private let arrowImageView: UIImageView
    private let arrowMargin: CGFloat
    private let offset: CGPoint
    private let preferredArrowDirection: Tooltip.ArrowDirection
    private(set) var arrowDirection: Tooltip.ArrowDirection = .down
    private var tooltipSize: CGSize = .zero
    private var tooltipOrigin: CGPoint = .zero
    private var tokenSet: TooltipTokenSet

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
