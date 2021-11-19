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
            let style = demo.style
            let spacing = demo.spacing
            addTitle(text: demo.description)
            container.addArrangedSubview(MSFDivider(style: style, spacing: spacing).view)
            container.addArrangedSubview(MSFDivider(style: style, spacing: spacing).view)

            let horizontalStack = UIStackView()
            horizontalStack.axis = .horizontal
            let text1 = Label(style: .subhead, colorStyle: .regular)
            text1.text = "Text 1"
            horizontalStack.addArrangedSubview(text1)
            horizontalStack.addArrangedSubview(MSFDivider(style: style, orientation: .vertical, spacing: spacing).view)
            let text2 = Label(style: .subhead, colorStyle: .regular)
            text2.text = "Text 2"
            horizontalStack.addArrangedSubview(text2)
            container.addArrangedSubview(horizontalStack)
        }
    }

    private enum DividerDemoCases: CaseIterable {
        case defaultNone
        case defaultMedium
        case shadowNone
        case shadowMedium

        var style: MSFDividerStyle {
            switch self {
            case .defaultNone,
                    .defaultMedium:
                return .default
            case .shadowNone,
                    .shadowMedium:
                return .shadow
            }
        }

        var spacing: MSFDividerSpacing {
            switch self {
            case .defaultNone,
                    .shadowNone:
                return .none
            case .defaultMedium,
                    .shadowMedium:
                return .medium
            }
        }

        var description: String {
            switch self {
            case .defaultNone:
                return "Default (none)"
            case .defaultMedium:
                return "Default (medium)"
            case .shadowNone:
                return "Shadow (none)"
            case .shadowMedium:
                return "Shadow (medium)"
            }
        }
    }
}
