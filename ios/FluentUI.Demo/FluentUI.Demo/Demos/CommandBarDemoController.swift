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

        case keyboard

        var iconImage: UIImage? {
            switch self {
            case .add:
                return UIImage(named: "add24Regular")
            case .mention:
                return UIImage(named: "mention24Regular")
            case .calendar:
                return UIImage(named: "calendar24Regular")
            case .textBold:
                return UIImage(named: "textBold24Regular")
            case .textItalic:
                return UIImage(named: "textItalic24Regular")
            case .textUnderline:
                return UIImage(named: "textUnderline24Regular")
            case .textStrikethrough:
                return UIImage(named: "textStrikethrough24Regular")
            case .arrowUndo:
                return UIImage(named: "arrowUndo24Regular")
            case .arrowRedo:
                return UIImage(named: "arrowRedo24Filled")
            case .copy:
                return UIImage(named: "copy24Regular")
            case .delete:
                return UIImage(named: "delete24Regular")
            case .checklist:
                return UIImage(named: "textChecklistListLtr24Regular")
            case .bulletList:
                return UIImage(named: "textBulletList24Regular")
            case .numberList:
                return UIImage(named: "textNumberListLtr24Regular")
            case .link:
                return UIImage(named: "link24Regular")
            case .keyboard:
                return UIImage(named: "keyboardDock24Regular")
            }
        }

        var isPersistSelection: Bool {
            switch self {
            case .add, .mention, .calendar, .arrowUndo, .arrowRedo, .copy, .delete, .link, .keyboard:
                return false
            case .textBold, .textItalic, .textUnderline, .textStrikethrough, .checklist, .bulletList, .numberList:
                return true
            }
        }
    }

    class Item: CommandBarItem {
        let command: Command

        init(command: Command, isEnabled: Bool = true, isSelected: Bool = false) {
            self.command = command

            super.init(iconImage: command.iconImage, isEnabled: isEnabled, isSelected: isSelected, isPersistSelection: command.isPersistSelection)
        }

        @available(iOS 14.0, *)
        init(command: Command, isEnabled: Bool = true, isSelected: Bool = false, menu: UIMenu, showsMenuAsPrimaryAction: Bool = false) {
            self.command = command

            super.init(iconImage: command.iconImage, isEnabled: isEnabled, isSelected: isSelected, isPersistSelection: command.isPersistSelection, menu: menu, showsMenuAsPrimaryAction: showsMenuAsPrimaryAction)
        }
    }

    let textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = Colors.Navigation.System.background
        textField.placeholder = "Text Field"

        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        container.layoutMargins.right = 0
        container.layoutMargins.left = 0
        view.backgroundColor = Colors.surfaceSecondary

        let itemGroups: [CommandBarItemGroup] = [
            [
                Item(command: .add),
                Item(command: .mention, isEnabled: false),
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

        if #available(iOS 14.0, *) {
            // Copy item
            let copyItem = itemGroups[3][0]
            copyItem.menu = UIMenu(children: [UIAction(title: "Copy Image", image: UIImage(named: "copy24Regular"), handler: { _ in }),
                                              UIAction(title: "Copy Text", image: UIImage(named: "text24Regular"), handler: { _ in })])
            copyItem.showsMenuAsPrimaryAction = true
        }

        container.addArrangedSubview(createLabelWithText("Default"))

        let defaultCommandBar = CommandBar(itemGroups: itemGroups)
        defaultCommandBar.backgroundColor = Colors.Navigation.System.background
        defaultCommandBar.delegate = self
        container.addArrangedSubview(defaultCommandBar)

        container.addArrangedSubview(createLabelWithText("With Fixed Button"))

        let fixedButtonCommandBar = CommandBar(itemGroups: itemGroups, trailingItem: Item(command: .keyboard))
        fixedButtonCommandBar.backgroundColor = Colors.Navigation.System.background
        fixedButtonCommandBar.delegate = self
        container.addArrangedSubview(fixedButtonCommandBar)

        container.addArrangedSubview(createLabelWithText("In Input Accessory View"))

        let accessoryCommandBar = CommandBar(itemGroups: itemGroups, trailingItem: Item(command: .keyboard))
        accessoryCommandBar.delegate = self
        textField.inputAccessoryView = accessoryCommandBar
        container.addArrangedSubview(textField)
    }

    func createLabelWithText(_ text: String = "") -> Label {
        let label = Label(style: .subhead, colorStyle: .regular)
        label.text = text
        label.textAlignment = .center
        return label
    }
}

extension CommandBarDemoController: CommandBarDelegate {
    func commandBar(_ commandBar: CommandBar, didSelectItem item: CommandBarItem) {
        guard let item = item as? Item else {
            fatalError("Invalid item type")
        }

        switch item.command {
        case .keyboard:
            textField.resignFirstResponder()
        default:
            break
        }
    }
}
