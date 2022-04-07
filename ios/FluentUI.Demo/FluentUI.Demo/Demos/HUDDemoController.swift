//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class HUDDemoController: DemoTableViewController {
    override init(nibName nibNameOrNil: String?,
                  bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(ActionsCell.self, forCellReuseIdentifier: ActionsCell.identifier)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return HUDDemoSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HUDDemoSection.allCases[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = HUDDemoSection.allCases[indexPath.section]
        let row = section.rows[indexPath.row]

        switch row {
        case .swiftUIDemo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
                return UITableViewCell()
            }
            cell.setup(title: row.title)
            cell.accessoryType = .disclosureIndicator

            return cell

        case .showHUD:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionsCell.identifier) as? ActionsCell else {
                return UITableViewCell()
            }

            cell.setup(action1Title: row.title, action1Type: .regular)
            cell.action1Button.addTarget(self,
                                         action: section.action,
                                         for: .touchUpInside)
            cell.bottomSeparatorType = .full

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return HUDDemoSection.allCases[section].title
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return HUDDemoSection.allCases[indexPath.section].rows[indexPath.row] == .swiftUIDemo
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }

        cell.setSelected(false, animated: true)

        switch HUDDemoSection.allCases[indexPath.section].rows[indexPath.row] {
        case .swiftUIDemo:
            navigationController?.pushViewController(HUDDemoControllerSwiftUI(),
                                                     animated: true)
        default:
            break
        }
    }

    @objc private func showActivityHUD(sender: UIButton) {
        HUD.shared.show(from: self,
                        with: HUDParams(caption: "Loading for 3 seconds"))
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            HUD.shared.hide()
        }
    }

    @objc private func showSuccessHUD(sender: UIButton) {
        HUD.shared.showSuccess(from: self,
                               with: "Success")
    }

    @objc private func showFailureHUD(sender: UIButton) {
        HUD.shared.showFailure(from: self,
                               with: "Failure")
    }

    @objc private func showCustomHUD(sender: UIButton) {
        HUD.shared.show(from: self, with: HUDParams(caption: "Custom",
                                                    image: UIImage(named: "flag-40x40"),
                                                    isPersistent: false))
    }

    @objc private func showCustomNonBlockingHUD(sender: UIButton) {
        HUD.shared.show(from: self,
                        with: HUDParams(caption: "Custom image non-blocking",
                                        image: UIImage(named: "flag-40x40"),
                                        isBlocking: false))
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            HUD.shared.hide()
        }
    }

    @objc private func showNoLabelHUD(sender: UIButton) {
        HUD.shared.show(from: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            HUD.shared.hide()
        }
    }

    @objc private func showGestureHUD(sender: UIButton) {
        HUD.shared.show(from: self, with: HUDParams(caption: "Downloading..."), onTap: {
            self.showMessage("Stop Download?", autoDismiss: false) {
                HUD.shared.hide()
            }
        })
    }

    @objc private func showUpdateHUD(sender: UIButton) {
        HUD.shared.show(from: self,
                        with: HUDParams(caption: "Downloading..."))

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

    override func showMessage(_ message: String, autoDismiss: Bool = true, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        present(alert, animated: true)

        if autoDismiss {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dismiss(animated: true)
            }
        } else {
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.dismiss(animated: true, completion: completion)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
        }

    }

    private enum HUDDemoSection: CaseIterable {
        case swiftUI
        case activity
        case success
        case failure
        case custom
        case nonblocking
        case nolabel
        case tapgesture
        case updatingcaption

        var isDemoSection: Bool {
            return self != .swiftUI
        }

        var rows: [HUDDemoRow] {
            switch self {
            case .swiftUI:
                return [.swiftUIDemo]
            case .activity,
                 .success,
                 .failure,
                 .custom,
                 .nonblocking,
                 .nolabel,
                 .tapgesture,
                 .updatingcaption:
                return [.showHUD]
            }
        }

        var action: Selector {
            switch self {
            case .swiftUI:
                preconditionFailure("This section should not need a selector.")
            case .activity:
                return #selector(showActivityHUD)
            case .success:
                return #selector(showSuccessHUD)
            case .failure:
                return #selector(showFailureHUD)
            case .custom:
                return #selector(showCustomHUD)
            case .nonblocking:
                return #selector(showCustomNonBlockingHUD)
            case .nolabel:
                return #selector(showNoLabelHUD)
            case .tapgesture:
                return #selector(showGestureHUD)
            case .updatingcaption:
                return #selector(showUpdateHUD)
            }
        }

        var title: String {
            switch self {
            case .swiftUI:
                return "SwiftUI"
            case .activity:
                return "Activity Type"
            case .success:
                return "Success Type"
            case .failure:
                return "Failure Type"
            case .custom:
                return "Custom Type"
            case .nonblocking:
                return "Non-blocking"
            case .nolabel:
                return "No label"
            case .tapgesture:
                return "Tap gesture callback"
            case .updatingcaption:
                return "Updating caption"
            }
        }
    }

    private enum HUDDemoRow: CaseIterable {
        case swiftUIDemo
        case showHUD

        var isDemoRow: Bool { return self != .swiftUIDemo }

        var title: String {
            switch self {
            case .swiftUIDemo:
                return "SwiftUI Demo"
            case .showHUD:
                return "Show"
            }
        }
    }
}

extension HUDDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }
        if isOverrideEnabled {
            fluentTheme.register(controlType: HeadsUpDisplay.self, tokens: { _ in
                ThemeWideOverrideActivityHeadsUpDisplayTokens()
            })
        } else {
            fluentTheme.register(controlType: HeadsUpDisplay.self, tokens: nil)
        }

    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        HUD.shared.overrideTokens = isOverrideEnabled ? PerControlOverrideHeadsUpDisplayTokens() : nil
    }

    func isThemeWideOverrideApplied() -> Bool {
        return view.window?.fluentTheme.tokenOverride(for: HeadsUpDisplay.self) != nil
    }

    // MARK: - Custom tokens

    private class ThemeWideOverrideActivityHeadsUpDisplayTokens: HeadsUpDisplayTokens {
        override var backgroundColor: DynamicColor {
            return aliasTokens.backgroundColors[.brandHover]
        }
    }

    private class PerControlOverrideHeadsUpDisplayTokens: HeadsUpDisplayTokens {
        override var cornerRadius: CGFloat {
            return globalTokens.borderRadius[.xLarge]
        }

        override var foregroundColor: DynamicColor {
            return globalTokens.brandColors[.primary]
        }
    }
}
