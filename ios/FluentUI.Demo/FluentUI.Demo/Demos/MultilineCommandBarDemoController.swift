//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class MultilineCommandBarDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let bottomSheetController = BottomSheetController(expandedContentView: multilineCommandBarView)
        bottomSheetController.collapsedContentHeight = 230
        bottomSheetController.shouldAlwaysFillWidth = true
        bottomSheetController.shouldHideCollapsedContent = false
        bottomSheetController.allowsSwipeToHide = true

        addChild(bottomSheetController)
        view.addSubview(bottomSheetController.view)
        bottomSheetController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            bottomSheetController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetController.view.topAnchor.constraint(equalTo: view.topAnchor),
            bottomSheetController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.layoutIfNeeded()
        bottomSheetController.isHidden = false
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

    private lazy var multilineCommandBarView: UIView = {
        func newItem(for command: CommandBarDemoController.Command) -> CommandBarItem {
            switch command {
            case .textStyle:
                return CommandBarItem(iconImage: nil, title: command.title, titleFont: command.titleFont)
            default:
                return CommandBarItem(
                    iconImage: command.iconImage
                )
            }
        }
        let commandRows: [[[CommandBarDemoController.Command]]] = [
            [
                [
                    .textStyle
                ],
                [
                    .textStyle
                ],
                [
                    .textStyle
                ]
            ],
            [
                [
                    .textBold,
                    .textItalic,
                    .textUnderline,
                    .textStrikethrough
                ]
            ],
            [
                [
                    .bulletList,
                    .numberList,
                    .checklist,
                    .link
                ]
            ],
            [
                [
                    .arrowUndo,
                    .arrowRedo
                ],
                [
                    .add
                ]
            ]
        ]

        var rows: [MultilineCommandBarRow] = []
        for commandRow in commandRows {
            let itemGroups: [CommandBarItemGroup] = commandRow.map { commandGroup in
                commandGroup.map { command in
                    newItem(for: command)
                }
            }
            rows.append(MultilineCommandBarRow(itemGroups: itemGroups, isScrollable: commandRow == commandRows.first))
        }

        let multilineCommandBar = MultilineCommandBar(rows: rows)
        multilineCommandBar.tokenSet[.itemBackgroundColorSelected] = .dynamicColor {
            .init(light: GlobalTokens.sharedColors(.purple, .tint50))
        }
        multilineCommandBar.tokenSet[.itemBackgroundColorPressed] = .dynamicColor {
            .init(light: GlobalTokens.sharedColors(.purple, .tint50))
        }
        multilineCommandBar.tokenSet[.itemIconColorSelected] = .dynamicColor {
            .init(light: GlobalTokens.sharedColors(.purple, .tint20))
        }
        multilineCommandBar.tokenSet[.itemIconColorPressed] = .dynamicColor {
            .init(light: GlobalTokens.sharedColors(.purple, .tint20))
        }

        return multilineCommandBar
    }()
}
