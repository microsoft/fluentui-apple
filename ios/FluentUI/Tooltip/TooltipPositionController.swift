//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: TooltipPositionController

class TooltipPositionController {

    init(anchorView: UIView,
         message: String,
         title: String? = nil,
         boundingRect: CGRect,
         preferredArrowDirection: Tooltip.ArrowDirection,
         offset: CGPoint,
         arrowMargin: CGFloat,
         tokenSet: TooltipTokenSet) {
        guard let window = anchorView.window else {
            preconditionFailure("Can't find anchorView's window")
        }
        self.window = window
        self.anchorView = anchorView
        self.preferredArrowDirection = preferredArrowDirection
        self.offset = offset
        self.arrowMargin = arrowMargin
        self.tokenSet = tokenSet
        self.boundingRect = boundingRect
        updateArrowDirectionAndTooltipSize(for: message, title: title, tokenSet: tokenSet)
    }

    func updateArrowDirectionAndTooltipSize(for message: String, title: String? = nil, tokenSet: TooltipTokenSet) {
        let preferredBoundingRect = boundingRect.inset(by: anchorViewInset(for: preferredArrowDirection))
        let backupBoundingRect = boundingRect.inset(by: anchorViewInset(for: preferredArrowDirection.opposite))
        let isAccessibilityContentSize = window.traitCollection.preferredContentSizeCategory.isAccessibilityCategory
        let preferredSize = TooltipViewController.sizeThatFits(preferredBoundingRect.size,
                                                     message: message,
                                                     title: title,
                                                     isAccessibilityContentSize: isAccessibilityContentSize,
                                                     arrowDirection: preferredArrowDirection,
                                                     tokenSet: tokenSet)
        let backupSize = TooltipViewController.sizeThatFits(backupBoundingRect.size,
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
    }

    let anchorView: UIView

    var arrowPosition: CGFloat {
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

    var tooltipRect: CGRect {
        return CGRect(origin: tooltipOrigin, size: tooltipSize)
    }

    private var tooltipOrigin: CGPoint {
        var tooltipOrigin = idealTooltipOrigin
        if arrowDirection.isVertical {
            tooltipOrigin.x = max(boundingRect.minX, min(tooltipOrigin.x, boundingRect.maxX - tooltipSize.width))
        } else {
            tooltipOrigin.y = max(boundingRect.minY, min(tooltipOrigin.y, boundingRect.maxY - tooltipSize.height))
        }
        tooltipOrigin.x += offset.x
        tooltipOrigin.y += offset.y
        return tooltipOrigin
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

    private(set) var arrowDirection: Tooltip.ArrowDirection = .down

    private let preferredArrowDirection: Tooltip.ArrowDirection
    private let window: UIView

    private let arrowMargin: CGFloat
    private let boundingRect: CGRect
    private let offset: CGPoint
    private let tokenSet: TooltipTokenSet

    private var tooltipSize: CGSize = .zero

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
