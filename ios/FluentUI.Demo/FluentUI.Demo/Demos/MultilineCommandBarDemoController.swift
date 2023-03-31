//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class MultilineCommandBarDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(multilineCommandBar)
        view.addSubview(multilineCommandBar.view)
        multilineCommandBar.didMove(toParent: self)

        NSLayoutConstraint.activate([
            multilineCommandBar.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            multilineCommandBar.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            multilineCommandBar.view.topAnchor.constraint(equalTo: view.topAnchor),
            multilineCommandBar.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.layoutIfNeeded()
    }

    private var multilineCommandBar: MultilineCommandBar = {
        let commandBarItems: [CommandBarItem] = Command.allCases.map { command -> CommandBarItem in
            switch command {
            case .heading1, .heading2, .heading3, .paragraph:
                return CommandBarItem(iconImage: nil, title: command.title, titleFont: command.titleFont)
            default:
                return CommandBarItem(
                    iconImage: command.iconImage
                )
            }
        }
        let portraitRows: [MultilineCommandBarRow] = [
            MultilineCommandBarRow(itemGroups: [[commandBarItems[0]],
                                                [commandBarItems[1]],
                                                [commandBarItems[2]],
                                                [commandBarItems[3]]], isScrollable: true),
            MultilineCommandBarRow(itemGroups: [Array(commandBarItems[4...7])]),
            MultilineCommandBarRow(itemGroups: [Array(commandBarItems[8...11])]),
            MultilineCommandBarRow(itemGroups: [Array(commandBarItems[12...13]),
                                                [commandBarItems[14]]])
        ]

        let landscapeRows: [MultilineCommandBarRow] = [
            MultilineCommandBarRow(itemGroups: [[commandBarItems[0]],
                                                [commandBarItems[1]],
                                                [commandBarItems[2]],
                                                [commandBarItems[3]]], isScrollable: true),
            MultilineCommandBarRow(itemGroups: [Array(commandBarItems[4...7]),
                                                Array(commandBarItems[8...11]),
                                                Array(commandBarItems[12...13]),
                                                [commandBarItems[14]]])
        ]

        return MultilineCommandBar(portraitRows: portraitRows, landscapeRows: landscapeRows)
    }()

    enum Command: CaseIterable {
        case heading1
        case heading2
        case heading3
        case paragraph

        case textBold
        case textItalic
        case textUnderline
        case textStrikethrough

        case bulletList
        case numberList
        case checklist
        case link

        case arrowUndo
        case arrowRedo
        case add

        var iconImage: UIImage? {
            switch self {
            case .heading1, .heading2, .heading3, .paragraph:
                return nil

            case .textBold:
                return UIImage(named: "textBold24Regular")
            case .textItalic:
                return UIImage(named: "textItalic24Regular")
            case .textUnderline:
                return UIImage(named: "textUnderline24Regular")
            case .textStrikethrough:
                return UIImage(named: "textStrikethrough24Regular")

            case .bulletList:
                return UIImage(named: "textBulletList24Regular")
            case .numberList:
                return UIImage(named: "textNumberListLtr24Regular")
            case .checklist:
                return UIImage(named: "textChecklistListLtr24Regular")
            case .link:
                return UIImage(named: "link24Regular")

            case .arrowUndo:
                return UIImage(named: "arrowUndo24Regular")
            case .arrowRedo:
                return UIImage(named: "arrowRedo24Filled")
            case .add:
                return UIImage(named: "add24Regular")
            }
        }

        var title: String? {
            switch self {
            case .heading1:
                return TextStyle.heading1.textRepresentation
            case .heading2:
                return TextStyle.heading2.textRepresentation
            case .heading3:
                return TextStyle.heading3.textRepresentation
            case .paragraph:
                return TextStyle.paragraph.textRepresentation
            default:
                return nil
            }
        }

        var titleFont: UIFont? {
            switch self {
            case .heading1:
                return TextStyle.heading1.font
            case .heading2:
                return TextStyle.heading2.font
            case .heading3:
                return TextStyle.heading3.font
            case .paragraph:
                return TextStyle.paragraph.font
            default:
                return nil
            }
        }
    }

    enum TextStyle: String, CaseIterable {
        case heading1
        case heading2
        case heading3
        case paragraph

        var font: UIFont {
            switch self {
            case .heading1:
                return .systemFont(ofSize: 25, weight: .bold)
            case .heading2:
                return .systemFont(ofSize: 20, weight: .bold)
            case .heading3:
                return .systemFont(ofSize: 17, weight: .semibold)
            case .paragraph:
                return .systemFont(ofSize: 15, weight: .regular)
            }
        }

        var textRepresentation: String {
            rawValue.capitalized
        }
    }
}
