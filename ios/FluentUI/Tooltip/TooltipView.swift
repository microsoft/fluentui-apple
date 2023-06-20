//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: TooltipView
class TooltipView: UIView, Shadowable {

    init(anchorView: UIView,
         hostViewController: UIViewController?,
         message: String,
         title: String? = nil,
         textAlignment: NSTextAlignment,
         preferredArrowDirection: Tooltip.ArrowDirection,
         offset: CGPoint,
         arrowMargin: CGFloat,
         tokenSet: TooltipTokenSet) {
        self.anchorView = anchorView
        self.hostViewController = hostViewController
        self.message = message
        self.titleMessage = title
        self.preferredArrowDirection = preferredArrowDirection
        self.offset = offset
        self.arrowMargin = arrowMargin
        self.tokenSet = tokenSet

        let arrowImageViewBaseImage = UIImage.staticImageNamed("tooltip-arrow")
        arrowImageView = UIImageView(image: arrowImageViewBaseImage)
        arrowImageView.image = arrowImageViewBaseImage?.withTintColor(tokenSet[.tooltipColor].uiColor, renderingMode: .alwaysOriginal)

        super.init(frame: .zero)

        addSubview(backgroundView)
        accessibilityViewIsModal = true

        arrowImageView.transform = transformForArrowImageView()
        addSubview(arrowImageView)

        messageLabel.text = message
        messageLabel.textAlignment = textAlignment

        if let titleLabel = titleLabel, let title = title {
            titleLabel.text = title
            titleLabel.textAlignment = textAlignment
        }

        addSubview(textContainer)
        isAccessibilityElement = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateShadows()
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

        updateTextContainerSize()
    }

    func updateFonts() {
        messageLabel.font = tokenSet[.messageLabelTextStyle].uiFont
        if let titleLabel = titleLabel {
            titleLabel.font = tokenSet[.titleLabelTextStyle].uiFont
        }
    }

    func updateAppearance(tokenSet: TooltipTokenSet) {
        // Update tokenSet
        self.tokenSet = tokenSet

        updateFonts()
        updateTooltipSizeAndOrigin()
        updateColors()
    }

    // MARK: - Shadow Layers
    var ambientShadow: CALayer?
    var keyShadow: CALayer?

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

#if DEBUG
    override var accessibilityIdentifier: String? {
        get {
            var identifier: String = "Tooltip with message \"\(message)\""

            if let title = titleMessage {
                identifier += " and title \"\(title)\""
            }

            switch arrowDirection {
            case .up:
                identifier += " that is pointing up"
            case .down:
                identifier += " that is pointing down"
            case .left:
                identifier += " that is pointing left"
            case .right:
                identifier += " that is pointing right"
            }

            return identifier
        }
        set { }
    }
#endif

    override var accessibilityHint: String? {
        get { return "Accessibility.Dismiss.Hint".localized }
        set { }
    }

    var tooltipRect: CGRect {
        return CGRect(origin: tooltipOrigin, size: tooltipSize)
    }

    private func updateShadows() {
        let shadowInfo = tokenSet[.shadowInfo].shadowInfo
        shadowInfo.applyShadow(to: backgroundView)
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
        let textColor = tokenSet[.textColor].uiColor
        backgroundView.backgroundColor = tokenSet[.tooltipColor].uiColor
        arrowImageView.image = arrowImageView.image?.withTintColor(tokenSet[.tooltipColor].uiColor, renderingMode: .alwaysOriginal)
        messageLabel.textColor = textColor
        titleLabel?.textColor = textColor
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
        return text.preferredSize(for: tokenSet[isMessage ? .messageLabelTextStyle : .titleLabelTextStyle].uiFont, width: boundingWidth)
    }

    private var arrowPosition: CGFloat {
        let minPosition = arrowMargin
        let arrowWidth = tokenSet[.arrowWidth].float
        var idealPosition: CGFloat
        var maxPosition: CGFloat
        if arrowDirection.isVertical {
            idealPosition = sourcePointInHost.x - tooltipRect.minX - arrowWidth / 2
            maxPosition = tooltipRect.width - arrowMargin - arrowWidth
        } else {
            idealPosition = sourcePointInHost.y - tooltipRect.minY - arrowWidth / 2
            maxPosition = tooltipRect.height - arrowMargin - arrowWidth
        }
        return max(minPosition, min(idealPosition, maxPosition))
    }

    private var idealTooltipOrigin: CGPoint {
        switch arrowDirection {
        case .up:
            return CGPoint(x: sourcePointInHost.x - tooltipSize.width / 2, y: sourcePointInHost.y)
        case .down:
            return CGPoint(x: sourcePointInHost.x - tooltipSize.width / 2, y: sourcePointInHost.y - tooltipSize.height)
        case .left:
            return CGPoint(x: sourcePointInHost.x, y: sourcePointInHost.y - tooltipSize.height / 2)
        case .right:
            return CGPoint(x: sourcePointInHost.x - tooltipSize.width, y: sourcePointInHost.y - tooltipSize.height / 2)
        }
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

    private var sourcePointInHost: CGPoint {
        guard let anchorView = anchorView else {
            assertionFailure("Can't find anchorView")
            return CGPoint.zero
        }

        return anchorView.convert(sourcePointInAnchorView, to: hostViewController?.view ?? window)
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

        let anchorViewFrame = anchorView.convert(anchorView.bounds, to: hostViewController?.view ?? window)
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
    private weak var hostViewController: UIViewController?
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
        view.backgroundColor = tokenSet[.tooltipColor].uiColor

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
        label.font = tokenSet[.messageLabelTextStyle].uiFont
        label.textColor = tokenSet[.textColor].uiColor
        label.numberOfLines = 0
        label.lineBreakStrategy = []
        label.isAccessibilityElement = false
        return label
    }()

    private lazy var titleLabel: UILabel? = {
        if let title = titleMessage {
            let label = Label()
            label.font = tokenSet[.titleLabelTextStyle].uiFont
            label.textColor = tokenSet[.textColor].uiColor
            label.numberOfLines = 0
            label.lineBreakStrategy = []
            label.isAccessibilityElement = false
            return label
        }

        return nil
    }()
}
