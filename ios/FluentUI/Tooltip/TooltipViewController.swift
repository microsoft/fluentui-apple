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
         arrowMargin: CGFloat) {
        tooltipView = TooltipView(anchorView: anchorView,
                                  message: message,
                                  title: title,
                                  textAlignment: textAlignment,
                                  preferredArrowDirection: preferredArrowDirection,
                                  offset: offset,
                                  arrowMargin: arrowMargin)

        super.init(nibName: nil, bundle: nil)

        view.addSubview(tooltipView)
        updateAppearance()
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: nil) { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.updateTooltipSizeAndOrigin()
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            tooltipView.updateFonts()
            updateTooltipSizeAndOrigin()
        }
    }

    func updateAppearance() {
        tooltipView.updateAppearance(tokenSet: Tooltip.shared.tokenSet)
        view.frame = tooltipView.tooltipRect
    }

    private func updateTooltipSizeAndOrigin() {
        tooltipView.updateTooltipSizeAndOrigin()
        view.frame = tooltipView.tooltipRect
    }

    private let tooltipView: TooltipView
}
