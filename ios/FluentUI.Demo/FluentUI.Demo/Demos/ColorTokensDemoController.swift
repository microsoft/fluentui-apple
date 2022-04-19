//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ColorTokensDemoController: DemoTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellID)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return GlobalTokens.SharedColorSets.allCases.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return GlobalTokens.SharedColorSets.allCases[section].text
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalTokens.SharedColorsTokens.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath)
        let colorSet = GlobalTokens.SharedColorSets.allCases[indexPath.section]
        let colorToken = GlobalTokens.SharedColorsTokens.allCases[indexPath.row]

        cell.backgroundConfiguration?.backgroundColor = UIColor(colorValue: globalTokens.sharedColors[colorSet][colorToken])
        cell.selectionStyle = .none

        var contentConfiguration = cell.defaultContentConfiguration()
        let text = "\(colorSet.text) \(colorToken.text)"
        contentConfiguration.attributedText = NSAttributedString(string: text,
                                                                 attributes: [
                                                                    .foregroundColor: textColor(for: colorToken, in: colorSet)
                                                                 ])
        contentConfiguration.textProperties.alignment = .center
        cell.contentConfiguration = contentConfiguration

        return cell
    }

    private func textColor(for colorToken: GlobalTokens.SharedColorsTokens, in colorSet: GlobalTokens.SharedColorSets) -> UIColor {
        // Yellow is special: it's much lighter than the other colors, so it needs a different text color scale.
        if colorSet == .yellow {
            switch colorToken {
            case .shade50, .shade40, .shade30, .shade20, .shade10:
                return .white
            case .primary, .tint10, .tint20, .tint30, .tint40, .tint50, .tint60:
                return .black
            }
        } else {
            switch colorToken {
            case .shade50, .shade40, .shade30, .shade20, .shade10, .primary, .tint10, .tint20, .tint30:
                return .white
            case .tint40, .tint50, .tint60:
                return .black
            }
        }
    }

    private var globalTokens: GlobalTokens {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return GlobalTokens()
        }
        return fluentTheme.globalTokens
    }

    private struct Constants {
        static let cellID: String = "cellID"
    }
}

// MARK: - Private extensions

private extension GlobalTokens.SharedColorSets {
    var text: String {
        switch self {
        case .anchor:
            return "Anchor"
        case .beige:
            return "Beige"
        case .berry:
            return "Berry"
        case .blue:
            return "Blue"
        case .brass:
            return "Brass"
        case .bronze:
            return "Bronze"
        case .brown:
            return "Brown"
        case .burgundy:
            return "Burgundy"
        case .charcoal:
            return "Charcoal"
        case .cornflower:
            return "Cornflower"
        case .cranberry:
            return "Cranberry"
        case .cyan:
            return "Cyan"
        case .darkBlue:
            return "Dark Blue"
        case .darkBrown:
            return "Dark Brown"
        case .darkGreen:
            return "Dark Green"
        case .darkOrange:
            return "Dark Orange"
        case .darkPurple:
            return "Dark Purple"
        case .darkRed:
            return "Dark Red"
        case .darkTeal:
            return "Dark Teal"
        case .forest:
            return "Forest"
        case .gold:
            return "Gold"
        case .grape:
            return "Grape"
        case .green:
            return "Green"
        case .hotPink:
            return "HotPink"
        case .lavender:
            return "Lavender"
        case .lightBlue:
            return "Light Blue"
        case .lightGreen:
            return "Light Green"
        case .lightTeal:
            return "Light Teal"
        case .lilac:
            return "Lilac"
        case .lime:
            return "Lime"
        case .magenta:
            return "Magenta"
        case .marigold:
            return "Marigold"
        case .mink:
            return "Mink"
        case .navy:
            return "Navy"
        case .orange:
            return "Orange"
        case .orchid:
            return "Orchid"
        case .peach:
            return "Peach"
        case .pink:
            return "Pink"
        case .platinum:
            return "Platinum"
        case .plum:
            return "Plum"
        case .pumpkin:
            return "Pumpkin"
        case .purple:
            return "Purple"
        case .red:
            return "Red"
        case .royalBlue:
            return "Royal Blue"
        case .seafoam:
            return "Seafoam"
        case .silver:
            return "Silver"
        case .steel:
            return "Steel"
        case .teal:
            return "Teal"
        case .yellow:
            return "Yellow"
        }
    }
}

private extension GlobalTokens.SharedColorsTokens {
    var text: String {
        switch self {
        case .shade50:
            return "Shade 50"
        case .shade40:
            return "Shade 40"
        case .shade30:
            return "Shade 30"
        case .shade20:
            return "Shade 20"
        case .shade10:
            return "Shade 10"
        case .primary:
            return "Primary"
        case .tint10:
            return "Tint 10"
        case .tint20:
            return "Tint 20"
        case .tint30:
            return "Tint 30"
        case .tint40:
            return "Tint 40"
        case .tint50:
            return "Tint 50"
        case .tint60:
            return "Tint 60"
        }
    }
}
