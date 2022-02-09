//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ButtonDemoController: DemoTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ButtonDemoController.cellReuseIdentifier)

        configureAppearancePopover()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return ButtonDemoSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ButtonDemoSection.allCases[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = ButtonDemoSection.allCases[indexPath.section]
        let row = section.rows[indexPath.row]

        switch row {
        case .swiftUIDemo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
                return UITableViewCell()
            }
            cell.setup(title: "SwiftUI Demo")
            cell.accessoryType = .disclosureIndicator

            return cell

        case .textAndIcon,
             .textOnly,
             .iconOnly:
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonDemoController.cellReuseIdentifier, for: indexPath)
            let subviews = cell.contentView.subviews
            subviews.forEach { subview in
                subview.removeFromSuperview()
            }

            let image = row == .textOnly ? nil : section.image
            let text = row == .iconOnly ? nil : "Button"

            let button = dequeueDemoButton(indexPath: indexPath,
                                           style: section.buttonStyle,
                                           size: section.buttonSize,
                                           disabled: false)
            button.state.image = image
            button.state.text = text

            let disabledButton = dequeueDemoButton(indexPath: indexPath,
                                                   style: section.buttonStyle,
                                                   size: section.buttonSize,
                                                   disabled: true)
            disabledButton.state.image = image
            disabledButton.state.text = text

            let rowContentView = UIStackView(arrangedSubviews: [button.view, disabledButton.view])
            rowContentView.isLayoutMarginsRelativeArrangement = true
            rowContentView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)
            rowContentView.translatesAutoresizingMaskIntoConstraints = false
            rowContentView.alignment = .leading
            rowContentView.distribution = .fill
            rowContentView.spacing = 10

            cell.contentView.addSubview(rowContentView)
            NSLayoutConstraint.activate([
                cell.contentView.leadingAnchor.constraint(equalTo: rowContentView.leadingAnchor),
                cell.contentView.topAnchor.constraint(equalTo: rowContentView.topAnchor),
                cell.contentView.bottomAnchor.constraint(equalTo: rowContentView.bottomAnchor)
            ])

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ButtonDemoSection.allCases[section].title
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return ButtonDemoSection.allCases[indexPath.section].rows[indexPath.row] == .swiftUIDemo
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }

        cell.setSelected(false, animated: true)

        switch ButtonDemoSection.allCases[indexPath.section].rows[indexPath.row] {
        case .swiftUIDemo:
            navigationController?.pushViewController(ButtonDemoControllerSwiftUI(),
                                                     animated: true)
        default:
            break
        }
    }

    // MARK: - Custom tokens

    private func configureAppearancePopover() {
        super.configureAppearancePopover { [weak self] themeWideOverrideEnabled in
            guard let fluentTheme = self?.view.window?.fluentTheme else {
                return
            }

            var tokensClosure: ((FluentButton) -> ButtonTokens)?
            if themeWideOverrideEnabled {
                tokensClosure = { _ in
                    return ThemeWideOverrideButtonTokens()
                }
            }

            fluentTheme.register(controlType: FluentButton.self, tokens: tokensClosure)

        } onPerControlOverrideChanged: { [weak self] perControlOverrideEnabled in
            self?.buttons.forEach({ (_: String, value: MSFButton) in
                let tokens = perControlOverrideEnabled ? PerControlOverrideButtonTokens() : nil
                value.state.overrideTokens = tokens
            })
        }
    }

    private class ThemeWideOverrideButtonTokens: ButtonTokens {
        override var textFont: FontInfo {
            return FontInfo(name: "Times", size: 20.0, weight: .regular)
        }
    }

    private class PerControlOverrideButtonTokens: ButtonTokens {
        override var textFont: FontInfo {
            return FontInfo(name: "Papyrus", size: 20.0, weight: .regular)
        }
    }

    // MARK: - Private helpers

    private static let cellReuseIdentifier: String = "cellReuseIdentifier"

    private var buttons: [String: MSFButton] = [:]

    private func dequeueDemoButton(indexPath: IndexPath,
                                   style: MSFButtonStyle,
                                   size: MSFButtonSize,
                                   disabled: Bool) -> MSFButton {
        let key = "\(indexPath)-\(disabled)"
        if let button = buttons[key] {
            return button
        } else {
            let button = MSFButton(style: style,
                                   size: size) { _ in
                self.didPressButton()
            }
            button.state.isDisabled = disabled
            buttons[key] = button

            return button
        }
    }

    private func didPressButton() {
        let alert = UIAlertController(title: "A button was pressed",
                                      message: nil,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }

    private enum ButtonDemoSection: CaseIterable {
        case swiftUI
        case primarySmall
        case primaryMedium
        case primaryLarge
        case secondarySmall
        case secondaryMedium
        case secondaryLarge
        case ghostSmall
        case ghostMedium
        case ghostLarge
        case accentFloatingSmall
        case accentFloatingLarge
        case subtleFloatingSmall
        case subtleFloatingLarge

        var buttonSize: MSFButtonSize {
            switch self {
            case .primarySmall,
                 .secondarySmall,
                 .ghostSmall,
                 .accentFloatingSmall,
                 .subtleFloatingSmall:
                return .small
            case .primaryMedium,
                 .secondaryMedium,
                 .ghostMedium:
                return .medium
            case .primaryLarge,
                 .secondaryLarge,
                 .ghostLarge,
                 .accentFloatingLarge,
                 .subtleFloatingLarge:
                return .large
            case .swiftUI:
                preconditionFailure("SwiftUI row should not display a Button")
            }
        }

        var isDemoSection: Bool {
            return self != .swiftUI
        }

        var title: String {
            switch self {
            case .swiftUI:
                return "SwiftUI"
            case .primarySmall:
                return "Primary Style (small)"
            case .secondarySmall:
                return "Secondary Style (small)"
            case .ghostSmall:
                return "Ghost Style (small)"
            case .accentFloatingSmall:
                return "Accent Floating Style (small)"
            case .subtleFloatingSmall:
                return "Subtle Floating Style (small)"
            case .primaryMedium:
                return "Primary Style (medium)"
            case .secondaryMedium:
                return "Secondary Style (medium)"
            case .ghostMedium:
                return "Ghost Style (medium)"
            case .primaryLarge:
                return "Primary Style (large)"
            case .secondaryLarge:
                return "Secondary Style (large)"
            case .ghostLarge:
                return "Ghost Style (large)"
            case .accentFloatingLarge:
                return "Accent Floating Style (large)"
            case .subtleFloatingLarge:
                return "Subtle Floating Style (large)"
            }
        }

        var buttonStyle: MSFButtonStyle {
            switch self {
            case .primarySmall,
                 .primaryMedium,
                 .primaryLarge:
                return .primary
            case .secondarySmall,
                 .secondaryMedium,
                 .secondaryLarge:
                return .secondary
            case .ghostSmall,
                 .ghostMedium,
                 .ghostLarge:
                return .ghost
            case .accentFloatingSmall,
                 .accentFloatingLarge:
                return .accentFloating
            case .subtleFloatingSmall,
                 .subtleFloatingLarge:
                return .subtleFloating
            case .swiftUI:
                preconditionFailure("Row does not have an associated button style")
            }
        }

        var image: UIImage? {
            switch self {
            case .primarySmall,
                 .primaryMedium,
                 .primaryLarge,
                 .accentFloatingSmall,
                 .accentFloatingLarge,
                 .subtleFloatingSmall,
                 .subtleFloatingLarge:
                return UIImage(named: "Placeholder_24")!
            case .secondarySmall,
                 .secondaryMedium,
                 .secondaryLarge,
                 .ghostSmall,
                 .ghostMedium,
                 .ghostLarge:
                return UIImage(named: "Placeholder_20")!
            case .swiftUI:
                return nil
            }
        }

        var rows: [ButtonDemoRow] {
            switch self {
            case .swiftUI:
                return [.swiftUIDemo]
            case.primarySmall,
                .primaryMedium,
                .primaryLarge,
                .secondarySmall,
                .secondaryMedium,
                .secondaryLarge,
                .ghostSmall,
                .ghostMedium,
                .ghostLarge,
                .accentFloatingSmall,
                .accentFloatingLarge,
                .subtleFloatingSmall,
                .subtleFloatingLarge:
                return [.textAndIcon,
                        .textOnly,
                        .iconOnly]
            }
        }
    }

    private enum ButtonDemoRow: CaseIterable {
        case swiftUIDemo
        case textAndIcon
        case textOnly
        case iconOnly

        var isDemoRow: Bool {
            switch self {
            case .textAndIcon,
                 .textOnly,
                 .iconOnly:
                return true
            case .swiftUIDemo:
                return false
            }
        }
    }
}
