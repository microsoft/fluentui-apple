//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: TooltipViewController

class TooltipViewController: UIViewController {

    init(anchorView: UIView,
         message: String,
         title: String? = nil,
         textAlignment: NSTextAlignment,
         preferredArrowDirection: Tooltip.ArrowDirection,
         offset: CGPoint,
         arrowMargin: CGFloat,
         tokenSet: TooltipTokenSet) {
        guard let window = anchorView.window else {
            preconditionFailure("Can't find anchorView's window")
        }
        TooltipViewController.window = window
        TooltipViewController.anchorView = anchorView
        TooltipViewController.preferredArrowDirection = preferredArrowDirection
        TooltipViewController.offset = offset
        TooltipViewController.arrowMargin = arrowMargin
        TooltipViewController.tokenSet = tokenSet
        self.tooltipView = TooltipView(message: message,
                                       title: title,
                                       textAlignment: textAlignment,
                                       tokenSet: tokenSet)

        super.init(nibName: nil, bundle: nil)

        self.view.addSubview(tooltipView)
        updateAppearance(tokenSet: TooltipViewController.tokenSet)
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    static func updateArrowDirectionAndTooltipRect(for message: String, title: String? = nil, tokenSet: TooltipTokenSet) {
        let preferredBoundingRect = boundingRect.inset(by: anchorViewInset(for: preferredArrowDirection))
        let backupBoundingRect = boundingRect.inset(by: anchorViewInset(for: preferredArrowDirection.opposite))
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

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: nil) { _ in
            self.updateTooltipSizeAndOrigin()
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            tooltipView.updateFonts()
            updateTooltipSizeAndOrigin()
        }
    }

    func updateAppearance(tokenSet: TooltipTokenSet) {
        self.tooltipView.updateAppearance(tokenSet: tokenSet)
        self.view.frame = TooltipViewController.tooltipRect
    }

    func updateTooltipSizeAndOrigin() {
        self.tooltipView.updateTooltipSizeAndOrigin()
        self.view.frame = TooltipViewController.tooltipRect
    }

    static var arrowPosition: CGFloat {
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

    static var tooltipRect: CGRect {
        return CGRect(origin: TooltipViewController.tooltipOrigin, size: TooltipViewController.tooltipSize)
    }

    private static var idealTooltipOrigin: CGPoint {
        switch arrowDirection {
        case .up:
            return CGPoint(x: sourcePointInWindow.x - TooltipViewController.tooltipSize.width / 2, y: sourcePointInWindow.y)
        case .down:
            return CGPoint(x: sourcePointInWindow.x - TooltipViewController.tooltipSize.width / 2, y: sourcePointInWindow.y - TooltipViewController.tooltipSize.height)
        case .left:
            return CGPoint(x: sourcePointInWindow.x, y: sourcePointInWindow.y - TooltipViewController.tooltipSize.height / 2)
        case .right:
            return CGPoint(x: sourcePointInWindow.x - TooltipViewController.tooltipSize.width, y: sourcePointInWindow.y - TooltipViewController.tooltipSize.height / 2)
        }
    }

    private static var sourcePointInAnchorView: CGPoint {
        switch TooltipViewController.arrowDirection {
        case .up:
            return CGPoint(x: TooltipViewController.anchorView.frame.width / 2, y: TooltipViewController.anchorView.frame.height)
        case .down:
            return CGPoint(x: TooltipViewController.anchorView.frame.width / 2, y: 0)
        case .right:
            return CGPoint(x: 0, y: TooltipViewController.anchorView.frame.height / 2)
        case .left:
            return CGPoint(x: TooltipViewController.anchorView.frame.width, y: TooltipViewController.anchorView.frame.height / 2)
        }
    }

    private static var sourcePointInWindow: CGPoint {
        return TooltipViewController.anchorView.convert(sourcePointInAnchorView, to: TooltipViewController.window)
    }

    private static var boundingRect: CGRect {
        let screenMargin = TooltipTokenSet.screenMargin
        return window.bounds.inset(by: window.safeAreaInsets).inset(by: UIEdgeInsets(top: screenMargin,
                                                                                     left: screenMargin,
                                                                                     bottom: screenMargin,
                                                                                     right: screenMargin))
    }

    private let tooltipView: TooltipView
    private static var anchorView: UIView = UIView()
    private(set) static var arrowDirection: Tooltip.ArrowDirection = .down
    private static var preferredArrowDirection: Tooltip.ArrowDirection = .down
    private static var window: UIView = UIWindow()
    private static var arrowMargin: CGFloat = 0
    private static var offset: CGPoint = .zero
    private static var tokenSet: TooltipTokenSet = TooltipTokenSet()
    private static var tooltipSize: CGSize = .zero
    private static var tooltipOrigin: CGPoint = .zero

    private static func anchorViewInset(for arrowDirection: Tooltip.ArrowDirection) -> UIEdgeInsets {
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
