//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class PillButtonDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        for style in buttonStyles {
            addTitle(text: "\(style.0) style")

            let pill1 = PillButton(pillBarItem: buttonItems[0], style: style.1)
            let pill2 = PillButton(pillBarItem: buttonItems[1], style: style.1)
            pill1.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
            pill2.addTarget(self, action: #selector(handleTap), for: .touchUpInside)

            addRow(items: [pill1])
            addRow(items: [pill2])
        }

        addTitle(text: "Mutability")
        addRow(items: [createButton(title: "Change titles", action: #selector(changeItemTitles))], stretchItems: true)
        addRow(items: [createButton(title: "Change unread dots", action: #selector(changeUnreadDots))], stretchItems: true)

    }

    @objc private func changeItemTitles() {
        itemTitlesChanged.toggle()
        buttonItems[0].title = itemTitlesChanged ? tabItemTitles[2] : tabItemTitles[0]
        buttonItems[1].title = itemTitlesChanged ? tabItemTitles[3] : tabItemTitles[1]
    }

    @objc private func changeUnreadDots() {
        unreadDotsChanged.toggle()
        buttonItems.forEach {
            $0.isUnread = unreadDotsChanged
        }
    }

    @objc private func handleTap() {
        let alert = UIAlertController(title: "Pill button was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }

    private lazy var buttonItems: [PillButtonBarItem] = {
        return [
            PillButtonBarItem(title: tabItemTitles[0]),
            PillButtonBarItem(title: tabItemTitles[1])
        ]
    }()

    private var itemTitlesChanged: Bool = false

    private var unreadDotsChanged: Bool = false

    private let tabItemTitles: [String] = [
        "All",
        "Documents",
        "Home",
        "Review"
    ]

    private let buttonStyles: [(String, PillButtonStyle)] = [
        ("Primary", .primary),
        ("onBrand", .onBrand)
    ]
}
