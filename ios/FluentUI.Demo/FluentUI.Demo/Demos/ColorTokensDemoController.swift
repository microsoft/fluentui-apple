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
        return GlobalTokens.SharedColors.allCases.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return GlobalTokens.SharedColors.allCases[section].text
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalTokens.SharedColorsTokens.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath)
        let colorSet = GlobalTokens.SharedColors.allCases[indexPath.section]
        let colorValue = GlobalTokens.SharedColorsTokens.allCases[indexPath.row]
        cell.backgroundConfiguration?.backgroundColor = UIColor(colorValue: GlobalTokens().sharedColors[colorSet][colorValue])
        cell.selectionStyle = .none

        var contentConfiguration = cell.defaultContentConfiguration()
        let textColor = indexPath.row > 8 ? UIColor.black : UIColor.white
        contentConfiguration.attributedText = NSAttributedString(string: colorValue.text, attributes: [.foregroundColor: textColor])
        contentConfiguration.textProperties.alignment = .center
        cell.contentConfiguration = contentConfiguration

        return cell
    }

    private struct Constants {
        static let cellID: String = "cellID"
    }
}

// MARK: - Private extensions

private extension GlobalTokens.SharedColors {
    var text: String {
        switch self {
        case .anchor:
            return "anchor"
        case .beige:
            return "beige"
        case .berry:
            return "berry"
        case .blue:
            return "blue"
        case .brass:
            return "brass"
        case .bronze:
            return "bronze"
        case .brown:
            return "brown"
        case .burgundy:
            return "burgundy"
        case .charcoal:
            return "charcoal"
        case .cornflower:
            return "cornflower"
        case .cranberry:
            return "cranberry"
        case .cyan:
            return "cyan"
        case .darkBlue:
            return "darkBlue"
        case .darkBrown:
            return "darkBrown"
        case .darkGreen:
            return "darkGreen"
        case .darkOrange:
            return "darkOrange"
        case .darkPurple:
            return "darkPurple"
        case .darkRed:
            return "darkRed"
        case .darkTeal:
            return "darkTeal"
        case .forest:
            return "forest"
        case .gold:
            return "gold"
        case .grape:
            return "grape"
        case .green:
            return "green"
        case .hotPink:
            return "hotPink"
        case .lavender:
            return "lavender"
        case .lightBlue:
            return "lightBlue"
        case .lightGreen:
            return "lightGreen"
        case .lightTeal:
            return "lightTeal"
        case .lilac:
            return "lilac"
        case .lime:
            return "lime"
        case .magenta:
            return "magenta"
        case .marigold:
            return "marigold"
        case .mink:
            return "mink"
        case .navy:
            return "navy"
        case .orange:
            return "orange"
        case .orchid:
            return "orchid"
        case .peach:
            return "peach"
        case .pink:
            return "pink"
        case .platinum:
            return "platinum"
        case .plum:
            return "plum"
        case .pumpkin:
            return "pumpkin"
        case .purple:
            return "purple"
        case .red:
            return "red"
        case .royalBlue:
            return "royalBlue"
        case .seafoam:
            return "seafoam"
        case .silver:
            return "silver"
        case .steel:
            return "steel"
        case .teal:
            return "teal"
        case .yellow:
            return "yellow"
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
}
