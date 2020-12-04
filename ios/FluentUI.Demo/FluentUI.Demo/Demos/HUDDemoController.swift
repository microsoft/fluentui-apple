//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class HUDDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        container.alignment = .leading
        let showActivityButton = MSFButtonVnext(style: .secondary, size: .small, action: {
            self.showActivityHUD()
        })
        showActivityButton.state.text = "Show activity HUD"
        container.addArrangedSubview(showActivityButton.view)

        let showSuccessButton = MSFButtonVnext(style: .secondary, size: .small, action: {
            self.showSuccessHUD()
        })
        showSuccessButton.state.text = "Show success HUD"
        container.addArrangedSubview(showSuccessButton.view)

        let showFailureButton = MSFButtonVnext(style: .secondary, size: .small, action: {
            self.showFailureHUD()
        })
        showFailureButton.state.text = "Show failure HUD"
        container.addArrangedSubview(showFailureButton.view)

        let showCustomButton = MSFButtonVnext(style: .secondary, size: .small, action: {
            self.showCustomHUD()
        })
        showCustomButton.state.text = "Show custom HUD"
        container.addArrangedSubview(showCustomButton.view)

        let showCustomNonBlockingButton = MSFButtonVnext(style: .secondary, size: .small, action: {
            self.showCustomNonBlockingHUD()
        })
        showCustomNonBlockingButton.state.text = "Show custom non-blocking HUD"
        container.addArrangedSubview(showCustomNonBlockingButton.view)

        let showNolabelButton = MSFButtonVnext(style: .secondary, size: .small, action: {
            self.showNoLabelHUD()
        })
        showNolabelButton.state.text = "Show HUD with no label"
        container.addArrangedSubview(showNolabelButton.view)

        let showGestureButton = MSFButtonVnext(style: .secondary, size: .small, action: {
            self.showGestureHUD()
        })
        showGestureButton.state.text = "Show HUD with tap gesture callback"
        container.addArrangedSubview(showGestureButton.view)

        let showUpdatingButton = MSFButtonVnext(style: .secondary, size: .small, action: {
            self.showUpdateHUD()
        })
        showUpdatingButton.state.text = "Show HUD with updating caption"
        container.addArrangedSubview(showUpdatingButton.view)
    }

    @objc private func showActivityHUD() {
        HUD.shared.show(in: view, with: HUDParams(caption: "Loading for 3 seconds"))
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            HUD.shared.hide()
        }
    }

    @objc private func showSuccessHUD() {
        HUD.shared.showSuccess(from: self, with: "Success")
    }

    @objc private func showFailureHUD() {
        HUD.shared.showFailure(from: self, with: "Failure")
    }

    @objc private func showCustomHUD() {
        HUD.shared.show(in: self.view, with: HUDParams(caption: "Custom", image: UIImage(named: "flag-40x40"), isPersistent: false))
    }

    @objc private func showCustomNonBlockingHUD() {
        HUD.shared.show(in: view, with: HUDParams(caption: "Custom image non-blocking", image: UIImage(named: "flag-40x40"), isBlocking: false))
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            HUD.shared.hide()
        }
    }

    @objc private func showNoLabelHUD() {
        HUD.shared.show(in: view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            HUD.shared.hide()
        }
    }

    @objc private func showGestureHUD() {
        HUD.shared.show(in: view, with: HUDParams(caption: "Downloading..."), onTap: {
            self.showMessage("Stop Download?", autoDismiss: false) {
                HUD.shared.hide()
            }
        })
    }

    @objc private func showUpdateHUD() {
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
