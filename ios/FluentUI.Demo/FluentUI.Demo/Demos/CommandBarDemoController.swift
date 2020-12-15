//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class CommandBarDemoController: DemoController {
    enum Command {
        case add
        case mention
        case calendar

        case textBold
        case textItalic
        case textUnderline
        case textStrikethrough

        case arrowUndo
        case arrowRedo

        case copy
        case delete

        case checklist
        case bulletList
        case numberList
        case link

        var iconImage: UIImage? {
            switch self {
            case .add:
                return UIImage(named: "Add_24_Regular")
            case .mention:
                return UIImage(named: "Mention_24_Regular")
            case .calendar:
                return UIImage(named: "Calendar_24_Regular")
            case .textBold:
                return UIImage(named: "Text Bold_24_Regular")
            case .textItalic:
                return UIImage(named: "Text Italic_24_Regular")
            case .textUnderline:
                return UIImage(named: "Text Underline_24_Regular")
            case .textStrikethrough:
                return UIImage(named: "Text Strikethrough_24_Regular")
            case .arrowUndo:
                return UIImage(named: "Arrow Undo_24_Regular")
            case .arrowRedo:
                return UIImage(named: "Arrow Redo_24_Filled")
            case .copy:
                return UIImage(named: "Copy_24_Regular")
            case .delete:
                return UIImage(named: "Delete_24_Regular")
            case .checklist:
                return UIImage(named: "Text Checklist List LTR_24_Regular")
            case .bulletList:
                return UIImage(named: "Text Bullet List_24_Regular")
            case .numberList:
                return UIImage(named: "Text Number List LTR_24_Regular")
            case .link:
                return UIImage(named: "Link_24_Regular")
            }
        }

        var isPersistSelection: Bool {
            switch self {
            case .arrowUndo, .arrowRedo:
                return false
            default:
                return true
            }
        }
    }

    class Item: CommandBarItem {
        let command: Command

        init(command: Command) {
            self.command = command

            super.init(iconImage: command.iconImage, isPersistSelection: command.isPersistSelection)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        container.layoutMargins.right = 0
        container.layoutMargins.left = 0

        let itemGroups: [CommandBarItemGroup] = [
            [
                Item(command: .add),
                Item(command: .mention),
                Item(command: .calendar)
            ],
            [
                Item(command: .textBold),
                Item(command: .textItalic),
                Item(command: .textUnderline),
                Item(command: .textStrikethrough)
            ],
            [
                Item(command: .arrowUndo),
                Item(command: .arrowRedo)
            ],
            [
                Item(command: .copy),
                Item(command: .delete)
            ],
            [
                Item(command: .checklist),
                Item(command: .bulletList),
                Item(command: .numberList),
                Item(command: .link)
            ]
        ]

        let commandBar = CommandBar(appearance: CommandBarAppearance(), itemGroups: itemGroups)
        commandBar.backgroundColor = Colors.Navigation.System.background
        commandBar.delegate = self
        container.addArrangedSubview(commandBar)
    }
}

extension CommandBarDemoController: CommandBarDelegate {
    func commandBar(_ commandBar: CommandBar, didSelectItem item: CommandBarItem) {
        print("Did select command \((item as! Item).command)")
    }
}
