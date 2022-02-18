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
        contentConfiguration.attributedText = NSAttributedString(string: colorToken.text,
                                                                 attributes: [
                                                                    .foregroundColor: colorToken.textColor
                                                                 ])
        contentConfiguration.textProperties.alignment = .center
        cell.contentConfiguration = contentConfiguration

        return cell
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
            return "shade50"
        case .shade40:
            return "shade40"
        case .shade30:
            return "shade30"
        case .shade20:
            return "shade20"
        case .shade10:
            return "shade10"
        case .primary:
            return "primary"
        case .tint10:
            return "tint10"
        case .tint20:
            return "tint20"
        case .tint30:
            return "tint30"
        case .tint40:
            return "tint40"
        case .tint50:
            return "tint50"
        case .tint60:
            return "tint60"
        }
    }

    var textColor: UIColor {
        switch self {
        case .shade50, .shade40, .shade30, .shade20, .shade10, .primary, .tint10, .tint20, .tint30:
            return .white
        case .tint40, .tint50, .tint60:
            return .black
        }
    }
}
