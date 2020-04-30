//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class HUDDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        container.addArrangedSubview(createButton(title: "Show activity HUD", action: #selector(showActivityHUD)))
        container.addArrangedSubview(createButton(title: "Show success HUD", action: #selector(showSuccessHUD)))
        container.addArrangedSubview(createButton(title: "Show failure HUD", action: #selector(showFailureHUD)))
        container.addArrangedSubview(createButton(title: "Show custom HUD", action: #selector(showCustomHUD)))
        container.addArrangedSubview(createButton(title: "Show custom non-blocking HUD", action: #selector(showCustomNonBlockingHUD)))
        container.addArrangedSubview(createButton(title: "Show HUD with no label", action: #selector(showNoLabelHUD)))
        container.addArrangedSubview(createButton(title: "Show HUD with tap gesture callback", action: #selector(showGestureHUD)))
        container.addArrangedSubview(createButton(title: "Show HUD with updating caption", action: #selector(showUpdateHUD)))
    }

    @objc private func showActivityHUD(sender: UIButton) {
        HUD.shared.show(in: view, with: HUDParams(caption: "Loading for 3 seconds"))
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            HUD.shared.hide()
        }
    }

    @objc private func showSuccessHUD(sender: UIButton) {
        HUD.shared.showSuccess(from: self, with: "Success")
    }

    @objc private func showFailureHUD(sender: UIButton) {
        HUD.shared.showFailure(from: self, with: "Failure")
    }

    @objc private func showCustomHUD(sender: UIButton) {
        HUD.shared.show(in: self.view, with: HUDParams(caption: "Custom", image: UIImage(named: "flag-40x40"), isPersistent: false))
    }

    @objc private func showCustomNonBlockingHUD(sender: UIButton) {
        HUD.shared.show(in: view, with: HUDParams(caption: "Custom image non-blocking", image: UIImage(named: "flag-40x40"), isBlocking: false))
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            HUD.shared.hide()
        }
    }

    @objc private func showNoLabelHUD(sender: UIButton) {
        HUD.shared.show(in: view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            HUD.shared.hide()
        }
    }

    @objc private func showGestureHUD(sender: UIButton) {
        HUD.shared.show(in: view, with: HUDParams(caption: "Downloading..."), onTap: {
            self.showMessage("Stop Download?", autoDismiss: false) {
                HUD.shared.hide()
            }
        })
    }

    @objc private func showUpdateHUD(sender: UIButton) {
        HUD.shared.show(in: view, with: HUDParams(caption: "Downloading..."))
        var time: TimeInterval = 0
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            time += timer.timeInterval
            if time < 4 {
                HUD.shared.update(with: "Downloading \(Int(time))")
            } else {
                timer.invalidate()
                HUD.shared.update(with: "Download complete!")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    HUD.shared.hide()
                }
            }
        }
    }
}
