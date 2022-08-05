//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: TooltipView

class TooltipView: UIView {
    private struct Constants {
        static let messageLabelTextStyle: TextStyle = .subhead

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
        self.message = message
        self.positionController = positionController

        arrowImageViewBaseImage = UIImage.staticImageNamed("tooltip-arrow")
        arrowImageView = UIImageView(image: arrowImageViewBaseImage)

        super.init(frame: .zero)

        updateColors()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)

        isAccessibilityElement = true

        addSubview(backgroundView)

        arrowImageView.transform = transformForArrowImageView()
        addSubview(arrowImageView)

        messageLabel.text = message
        messageLabel.textAlignment = textAlignment
        messageLabel.isAccessibilityElement = false
        addSubview(messageLabel)

        updateShadow()
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

        messageLabel.frame = backgroundView.frame.insetBy(dx: Constants.paddingHorizontal, dy: 0)
    }

    @objc private func themeDidChange(_ notification: Notification) {
        updateColors()
        updateShadow()
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

    private func updateShadow() {
        let shadow = fluentTheme.aliasTokens.shadow[.shadow16]
        let color = UIColor(dynamicColor: shadow.colorOne).cgColor

        layer.shadowColor = color
        layer.shadowOpacity = Float(color.alpha)
        layer.shadowRadius = shadow.blurOne
        layer.shadowOffset = CGSize(width: shadow.xOne, height: shadow.yOne)
    }

    private func updateColors() {
        let backgroundColor = UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.backgroundInverted])
        backgroundView.backgroundColor = backgroundColor
        arrowImageView.image = arrowImageViewBaseImage?.withTintColor(backgroundColor, renderingMode: .alwaysOriginal)
        messageLabel.textColor = UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foregroundInverted1])
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
