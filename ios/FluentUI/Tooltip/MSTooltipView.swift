//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSTooltipView

class MSTooltipView: UIView {
    private struct Constants {
        static let messageLabelTextStyle: MSTextStyle = .subhead

        static let shadowRadius: CGFloat = 4
        static let shadowOffset: CGFloat = 2
        static let shadowOpacity: Float = 0.24

        static let maximumWidth: CGFloat = 500

        static let paddingHorizontal: CGFloat = 13
        static let totalPaddingVertical: CGFloat = 12

        static let maxLines: Int = 3
    }

    static let backgroundCornerRadius: CGFloat = 8
    static let arrowSize = CGSize(width: 14.0, height: 7.0)

    /// Returns the tooltip size
    static func sizeThatFits(_ size: CGSize, message: String, arrowDirection: MSTooltip.ArrowDirection) -> CGSize {
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
        return message.preferredSize(for: Constants.messageLabelTextStyle.font, width: boundingWidth, numberOfLines: Constants.maxLines)
    }

    let positionController: MSTooltipPositionController

    private let message: String

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.Tooltip.background
        view.layer.cornerRadius = backgroundCornerRadius
        if #available(iOS 13.0, *) {
            view.layer.cornerCurve = .continuous
        }
        return view
    }()

    private let arrowImageView = UIImageView(image: UIImage.staticImageNamed("tooltip-arrow")?.image(withPrimaryColor: Colors.Tooltip.background))

    private let messageLabel: UILabel = {
        let label = Label(style: Constants.messageLabelTextStyle)
        label.textColor = Colors.Tooltip.text
        label.numberOfLines = Constants.maxLines
        return label
    }()

    init(message: String, textAlignment: NSTextAlignment, positionController: MSTooltipPositionController) {
        self.message = message
        self.positionController = positionController

        super.init(frame: .zero)

        isAccessibilityElement = true

        addSubview(backgroundView)

        arrowImageView.transform = transformForArrowImageView()
        addSubview(arrowImageView)

        messageLabel.text = message
        messageLabel.textAlignment = textAlignment
        messageLabel.isAccessibilityElement = false
        addSubview(messageLabel)

        // Shadow
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowRadius = Constants.shadowRadius
        layer.shadowOffset = CGSize(width: 0.0, height: Constants.shadowOffset)
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
