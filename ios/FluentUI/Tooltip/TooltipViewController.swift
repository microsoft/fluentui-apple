//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: TooltipViewController

class TooltipViewController: UIViewController {

    init(message: String,
         title: String? = nil,
         textAlignment: NSTextAlignment,
         positioner: TooltipPositioner,
         tokenSet: TooltipTokenSet) {

        self.tokenSet = tokenSet
        self.tooltipView = TooltipView(message: message,
                                       title: title,
                                       textAlignment: textAlignment,
                                       positioner: positioner,
                                       tokenSet: tokenSet)

        super.init(nibName: nil, bundle: nil)

        self.view.addSubview(tooltipView)
        updateAppearance(tokenSet: self.tokenSet)
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

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            updateAppearance(tokenSet: self.tokenSet)
        }
    }

    func updateAppearance(tokenSet: TooltipTokenSet) {
        self.tooltipView.updateAppearance(tokenSet: tokenSet)
        self.view.frame = self.tooltipView.positioner.tooltipRect
    }

    let tooltipView: TooltipView
    private let tokenSet: TooltipTokenSet
}
