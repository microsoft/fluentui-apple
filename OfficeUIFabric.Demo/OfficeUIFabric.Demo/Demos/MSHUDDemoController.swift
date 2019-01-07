//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import OfficeUIFabric
import UIKit

class MSHUDDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        container.addArrangedSubview(createButton(title: "Show activity HUD", action: #selector(showActivityHUD)))
        container.addArrangedSubview(createButton(title: "Show success HUD", action: #selector(showSuccessHUD)))
        container.addArrangedSubview(createButton(title: "Show failure HUD", action: #selector(showFailureHUD)))
        container.addArrangedSubview(createButton(title: "Show custom HUD", action: #selector(showCustomHUD)))
        container.addArrangedSubview(createButton(title: "Show custom non-blocking HUD", action: #selector(showCustomNonBlockingHUD)))
        container.addArrangedSubview(createButton(title: "Show HUD with no label", action: #selector(showNoLabelHUD)))
    }

    @objc private func showActivityHUD(sender: UIButton) {
        MSHUD.shared.show(in: view, with: MSHUDParams(caption: "Loading for 3 seconds"))
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            MSHUD.shared.hide()
        }
    }

    @objc private func showSuccessHUD(sender: UIButton) {
        MSHUD.shared.showSuccess(from: self, with: "Success")
    }

    @objc private func showFailureHUD(sender: UIButton) {
        MSHUD.shared.showFailure(from: self, with: "Failure")
    }

    @objc private func showCustomHUD(sender: UIButton) {
        MSHUD.shared.show(in: self.view, with: MSHUDParams(caption: "Custom", image: UIImage(named: "flag-40x40"), isPersistent: false))
    }

    @objc private func showCustomNonBlockingHUD(sender: UIButton) {
        MSHUD.shared.show(in: view, with: MSHUDParams(caption: "Custom image non-blocking", image: UIImage(named: "flag-40x40"), isBlocking: false))
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            MSHUD.shared.hide()
        }
    }

    @objc private func showNoLabelHUD(sender: UIButton) {
        MSHUD.shared.show(in: view, with: MSHUDParams())
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            MSHUD.shared.hide()
        }
    }
}
