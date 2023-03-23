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

    private lazy var multilineCommandBarView: UIView = {
        let portraitCommandRows: [[[Command]]] = [
            [
                [
                    .heading1
                ],
                [
                    .heading2
                ],
                [
                    .heading3
                ],
                [
                    .paragraph
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
        let portraitRows: [MultilineCommandBarRow] = portraitCommandRows.map { commandGroups in
            MultilineCommandBarRow(itemGroups: (commandGroups.map { commandGroup in
                commandGroup.map { command in
                    newItem(for: command)
                }
            }), isScrollable: commandGroups == portraitCommandRows.first)
        }

        let landscapeCommandRows: [[[Command]]] = [
            [
                [
                    .heading1
                ],
                [
                    .heading2
                ],
                [
                    .heading3
                ],
                [
                    .paragraph
                ]
            ],
            [
                [
                    .textBold,
                    .textItalic,
                    .textUnderline,
                    .textStrikethrough
                ],
                [
                    .bulletList,
                    .numberList,
                    .checklist,
                    .link
                ],
                [
                    .arrowUndo,
                    .arrowRedo
                ],
                [
                    .add
                ]
            ]
        ]
        let landscapeRows: [MultilineCommandBarRow] = landscapeCommandRows.map { commandGroups in
            MultilineCommandBarRow(itemGroups: (commandGroups.map { commandGroup in
                commandGroup.map { command in
                    newItem(for: command)
                }
            }), isScrollable: commandGroups == landscapeCommandRows.first)
        }

        multilineCommandBar = MultilineCommandBar(portraitRows: portraitRows, landscapeRows: landscapeRows)
        return MultilineCommandBar(portraitRows: portraitRows, landscapeRows: landscapeRows)
    }()

    private var multilineCommandBar: MultilineCommandBar?

    private func newItem(for command: Command) -> CommandBarItem {
        switch command {
        case .heading1, .heading2, .heading3, .paragraph:
            return CommandBarItem(iconImage: nil, title: command.title, titleFont: command.titleFont)
        default:
            return CommandBarItem(
                iconImage: command.iconImage
            )
        }
    }

    enum Command {
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

extension MultilineCommandBarDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }
        fluentTheme.register(tokenSetType: CommandBarTokenSet.self,
                             tokenSet: isOverrideEnabled ? themeWideOverrideCommandBarTokens : nil)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        multilineCommandBar?.tokenSet.replaceAllOverrides(with: isOverrideEnabled ? perControlOverrideCommandBarTokens : nil)
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: CommandBarTokenSet.self)?.isEmpty == false
    }

    // MARK: - Custom tokens
    private var themeWideOverrideCommandBarTokens: [CommandBarTokenSet.Tokens: ControlTokenValue] {
        return [
            .itemBackgroundColorSelected: .dynamicColor {
                return DynamicColor(light: GlobalTokens.sharedColors(.purple, .tint50))
            },
            .itemBackgroundColorPressed: .dynamicColor {
                return DynamicColor(light: GlobalTokens.sharedColors(.purple, .tint50))
            },
            .itemIconColorSelected: .dynamicColor {
                return DynamicColor(light: GlobalTokens.sharedColors(.purple, .tint20))
            },
            .itemIconColorPressed: .dynamicColor {
                return DynamicColor(light: GlobalTokens.sharedColors(.purple, .tint20))
            }
        ]
    }
    private var perControlOverrideCommandBarTokens: [CommandBarTokenSet.Tokens: ControlTokenValue] {
        return [
            .itemBackgroundColorSelected: .dynamicColor {
                return DynamicColor(light: GlobalTokens.sharedColors(.purple, .tint50))
            },
            .itemBackgroundColorPressed: .dynamicColor {
                return DynamicColor(light: GlobalTokens.sharedColors(.purple, .tint50))
            },
            .itemIconColorSelected: .dynamicColor {
                return DynamicColor(light: GlobalTokens.sharedColors(.purple, .tint20))
            },
            .itemIconColorPressed: .dynamicColor {
                return DynamicColor(light: GlobalTokens.sharedColors(.purple, .tint20))
            }
        ]
    }
}
