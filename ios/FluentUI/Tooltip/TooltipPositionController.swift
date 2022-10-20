//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: TooltipPositionController

class TooltipPositionController {
    let anchorView: UIView
    private(set) var arrowDirection: Tooltip.ArrowDirection = .down

    var arrowPosition: CGFloat {
        let minPosition = arrowMargin
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

    var tooltipRect: CGRect {
        return CGRect(origin: tooltipOrigin, size: tooltipSize)
    }

    private lazy var tooltipOrigin: CGPoint = {
        var tooltipOrigin = idealTooltipOrigin
        if arrowDirection.isVertical {
            tooltipOrigin.x = max(boundingRect.minX, min(tooltipOrigin.x, boundingRect.maxX - tooltipSize.width))
        } else {
            tooltipOrigin.y = max(boundingRect.minY, min(tooltipOrigin.y, boundingRect.maxY - tooltipSize.height))
        }
        tooltipOrigin.x += offset.x
        tooltipOrigin.y += offset.y
        return tooltipOrigin
    }()

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
    }

    private var sourcePointInAnchorView: CGPoint {
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
        return anchorView.convert(sourcePointInAnchorView, to: window)
    }

    private let preferredArrowDirection: Tooltip.ArrowDirection
    private let window: UIView

    private let arrowMargin: CGFloat
    private let arrowWidth: CGFloat
    private let arrowHeight: CGFloat
    private let totalPaddingVertical: CGFloat
    private let paddingHorizontal: CGFloat
    private let maximumWidth: CGFloat
    private let messageLabelFont: UIFont
    private let titleLabelFont: UIFont
    private let boundingRect: CGRect
    private let offset: CGPoint

    private var tooltipSize: CGSize = .zero
    init(anchorView: UIView,
         message: String,
         title: String? = nil,
         boundingRect: CGRect,
         preferredArrowDirection: Tooltip.ArrowDirection,
         offset: CGPoint,
         arrowMargin: CGFloat,
         arrowWidth: CGFloat,
         arrowHeight: CGFloat,
         totalPaddingVertical: CGFloat,
         paddingHorizontal: CGFloat,
         maximumWidth: CGFloat,
         messageLabelFont: UIFont,
         titleLabelFont: UIFont) {
        guard let window = anchorView.window else {
            preconditionFailure("Can't find anchorView's window")
        }
        self.window = window
        self.anchorView = anchorView
        self.preferredArrowDirection = preferredArrowDirection
        self.offset = offset
        self.arrowMargin = arrowMargin
        self.arrowWidth = arrowWidth
        self.arrowHeight = arrowHeight
        self.totalPaddingVertical = totalPaddingVertical
        self.paddingHorizontal = paddingHorizontal
        self.maximumWidth = maximumWidth
        self.messageLabelFont = messageLabelFont
        self.titleLabelFont = titleLabelFont
        self.boundingRect = boundingRect
        setupArrowDirectionAndTooltipSize(for: message, title: title)
    }

    private func setupArrowDirectionAndTooltipSize(for message: String, title: String? = nil) {
        let preferredBoundingRect = boundingRect.inset(by: anchorViewInset(for: preferredArrowDirection))
        let backupBoundingRect = boundingRect.inset(by: anchorViewInset(for: preferredArrowDirection.opposite))
        let preferredSize = TooltipView.sizeThatFits(preferredBoundingRect.size,
                                                     message: message,
                                                     title: title,
                                                     arrowDirection: preferredArrowDirection,
                                                     arrowHeight: arrowHeight,
                                                     totalPaddingVertical: totalPaddingVertical,
                                                     paddingHorizontal: paddingHorizontal,
                                                     maximumWidth: maximumWidth,
                                                     messageLabelFont: messageLabelFont,
                                                     titleLabelFont: titleLabelFont)
        let backupSize = TooltipView.sizeThatFits(backupBoundingRect.size,
                                                  message: message,
                                                  title: title,
                                                  arrowDirection: preferredArrowDirection.opposite,
                                                  arrowHeight: arrowHeight,
                                                  totalPaddingVertical: totalPaddingVertical,
                                                  paddingHorizontal: paddingHorizontal,
                                                  maximumWidth: maximumWidth,
                                                  messageLabelFont: messageLabelFont,
                                                  titleLabelFont: titleLabelFont)

        var usePreferred = true
        if preferredArrowDirection.isVertical {
            if preferredBoundingRect.height < preferredSize.height && backupBoundingRect.height >= backupSize.height {
                usePreferred = false
            }
        } else {
            if preferredBoundingRect.width < preferredSize.width && backupBoundingRect.width >= backupSize.width {
                usePreferred = false
            }
        }
        if usePreferred {
            arrowDirection = preferredArrowDirection
            tooltipSize = preferredSize
        } else {
            arrowDirection = preferredArrowDirection.opposite
            tooltipSize = backupSize
        }
    }

    private func anchorViewInset(for arrowDirection: Tooltip.ArrowDirection) -> UIEdgeInsets {
        guard let window = anchorView.window else {
            preconditionFailure("Can't find anchorView's window")
        }

        var inset = UIEdgeInsets.zero
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
}
