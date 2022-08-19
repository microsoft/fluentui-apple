//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class TypographyTokensDemoController: DemoTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellID)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AliasTokens.TypographyTokens.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath)
        let typographyToken = AliasTokens.TypographyTokens.allCases[indexPath.row]

        cell.selectionStyle = .none

        var contentConfiguration = cell.defaultContentConfiguration()
        let text = "\(typographyToken.text)"
        contentConfiguration.attributedText = NSAttributedString(string: text,
                                                                 attributes: [
                                                                    .font: UIFont.fluent(aliasTokens.typography[typographyToken])
                                                                 ])
        contentConfiguration.textProperties.alignment = .center
        cell.contentConfiguration = contentConfiguration

        return cell
    }

    private var aliasTokens: AliasTokens {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return AliasTokens()
        }
        return fluentTheme.aliasTokens
    }

    private struct Constants {
        static let cellID: String = "cellID"
    }
}

// MARK: - Private extensions

private extension AliasTokens.TypographyTokens {
    var text: String {
        switch self {
        case .display:
            return "Display"
        case .largeTitle:
            return "Large Title"
        case .title1:
            return "Title 1"
        case .title2:
            return "Title 2"
        case .title3:
            return "Title 3"
        case .body1Strong:
            return "Body 1 Strong"
        case .body1:
            return "Body 1"
        case .body2Strong:
            return "Body 2 Strong"
        case .body2:
            return "Body 2"
        case .caption1Strong:
            return "Caption 1 Strong"
        case .caption1:
            return "Caption 1"
        case .caption2:
            return "Caption 2"
        }
    }
}
