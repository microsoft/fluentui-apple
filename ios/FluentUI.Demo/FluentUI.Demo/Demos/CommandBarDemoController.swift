//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class CommandBarDemoController: DemoController {

    override func viewDidLoad() {
        super.viewDidLoad()
        container.layoutMargins.right = 0
        container.layoutMargins.left = 0

        let itemGroups: [CommandBarItemGroup] = [
            [
                CommandBarItem(iconImage: UIImage(named: "Add_24_Regular"), accessbilityLabel: nil),
                CommandBarItem(iconImage: UIImage(named: "Mention_24_Regular"), accessbilityLabel: nil),
                CommandBarItem(iconImage: UIImage(named: "Calendar_24_Regular"), accessbilityLabel: nil)
            ],
            [
                CommandBarItem(iconImage: UIImage(named: "Text Bold_24_Regular"), accessbilityLabel: nil),
                CommandBarItem(iconImage: UIImage(named: "Text Italic_24_Regular"), accessbilityLabel: nil),
                CommandBarItem(iconImage: UIImage(named: "Text Underline_24_Regular"), accessbilityLabel: nil),
                CommandBarItem(iconImage: UIImage(named: "Text Strikethrough_24_Regular"), accessbilityLabel: nil)
            ],
            [
                CommandBarItem(iconImage: UIImage(named: "Arrow Undo_24_Regular"), accessbilityLabel: nil),
                CommandBarItem(iconImage: UIImage(named: "Arrow Redo_24_Filled"), accessbilityLabel: nil)
            ],
            [
                CommandBarItem(iconImage: UIImage(named: "Copy_24_Regular"), accessbilityLabel: nil),
                CommandBarItem(iconImage: UIImage(named: "Delete_24_Regular"), accessbilityLabel: nil)
            ],
            [
                CommandBarItem(iconImage: UIImage(named: "Text Checklist List LTR_24_Regular"), accessbilityLabel: nil),
                CommandBarItem(iconImage: UIImage(named: "Text Bullet List_24_Regular"), accessbilityLabel: nil),
                CommandBarItem(iconImage: UIImage(named: "Text Number List LTR_24_Regular"), accessbilityLabel: nil),
                CommandBarItem(iconImage: UIImage(named: "Link_24_Regular"), accessbilityLabel: nil)
            ]
        ]

        let commandBar = CommandBar(appearance: CommandBarAppearance(), itemGroups: itemGroups)
        commandBar.backgroundColor = Colors.Navigation.System.background
        container.addArrangedSubview(commandBar)
    }

}
