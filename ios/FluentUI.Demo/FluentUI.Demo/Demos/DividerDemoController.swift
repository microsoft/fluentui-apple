//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class DividerDemoController: DemoController {
    override init (nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        for demo in DividerDemoCases.allCases {
            let spacing = demo.spacing
            let color = demo == .custom ? UIColor.black : nil
            addTitle(text: demo.description)
            let divider1 = MSFDivider(spacing: spacing)
            divider1.state.color = color
            let divider2 = MSFDivider(spacing: spacing)
            divider2.state.color = color
            container.addArrangedSubview(divider1.view)
            container.addArrangedSubview(divider2.view)

            let horizontalStack = UIStackView()
            horizontalStack.axis = .horizontal
            let text1 = Label(style: .subhead, colorStyle: .regular)
            text1.text = "Text 1"
            horizontalStack.addArrangedSubview(text1)
            let divider3 = MSFDivider(orientation: .vertical, spacing: spacing)
            divider3.state.color = color
            horizontalStack.addArrangedSubview(divider3.view)
            let text2 = Label(style: .subhead, colorStyle: .regular)
            text2.text = "Text 2"
            horizontalStack.addArrangedSubview(text2)
            container.addArrangedSubview(horizontalStack)
        }
    }

    private enum DividerDemoCases: CaseIterable {
        case defaultNone
        case defaultMedium
        case custom

        var spacing: MSFDividerSpacing {
            switch self {
            case .defaultNone,
                    .custom:
                return .none
            case .defaultMedium:
                return .medium
            }
        }

        var description: String {
            switch self {
            case .defaultNone:
                return "No Spacing"
            case .defaultMedium:
                return "Medium Spacing"
            case .custom:
                return "Custom Color"
            }
        }
    }
}
