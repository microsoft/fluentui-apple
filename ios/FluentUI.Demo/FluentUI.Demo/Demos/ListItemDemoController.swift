//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class ListItemDemoController: DemoController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let hostingController = ListItemDemoControllerSwiftUI()
        addChild(hostingController)
        hostingController.didMove(toParent: self)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
                                     hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)])

        readmeString = "A list item displays a single row of data in a list.\n\nUse list items for displaying rows of data in a single column."
    }
}

extension ListItemDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }

        fluentTheme.register(tokenSetType: ListItemTokenSet.self,
                             tokenSet: isOverrideEnabled ? themeWideOverrideListItemTokens : nil)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }

        fluentTheme.register(tokenSetType: ListItemTokenSet.self,
                             tokenSet: isOverrideEnabled ? perControlOverrideListItemTokens : nil)
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: ListItemTokenSet.self) != nil
    }

    // MARK: - Custom tokens
    private var themeWideOverrideListItemTokens: [ListItemTokenSet.Tokens: ControlTokenValue] {
        return [
            .cellBackgroundColor: .uiColor {
                // "Berry"
                return UIColor(light: GlobalTokens.sharedColor(.berry, .tint50),
                               dark: GlobalTokens.sharedColor(.berry, .shade40))
            }
        ]
    }

    private var perControlOverrideListItemTokens: [ListItemTokenSet.Tokens: ControlTokenValue] {
        return [
            .cellBackgroundColor: .uiColor {
                // "Brass"
                return UIColor(light: GlobalTokens.sharedColor(.brass, .tint50),
                               dark: GlobalTokens.sharedColor(.brass, .shade40))
            },
            .accessoryDisclosureIndicatorColor: .uiColor {
                // "Forest"
                return UIColor(light: GlobalTokens.sharedColor(.forest, .tint10),
                               dark: GlobalTokens.sharedColor(.forest, .shade40))
            },
            .customViewTrailingMargin: .float {
                return 0
            }
        ]
    }
}
