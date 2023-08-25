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
        self.hostingController = hostingController
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
                                     hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)])

        readmeString = "A list item displays a single row of data in a list.\n\nUse list items for displaying rows of data in a single column."
    }

    override func didMove(toParent parent: UIViewController?) {
        guard let parent,
              let window = parent.view.window,
              let hostingController else {
            return
        }

        hostingController.rootView.fluentTheme = window.fluentTheme
    }

    var hostingController: ListItemDemoControllerSwiftUI?
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
            .cellBackgroundGroupedColor: .uiColor {
                // "Berry"
                return UIColor(light: GlobalTokens.sharedColor(.berry, .tint50),
                               dark: GlobalTokens.sharedColor(.berry, .shade40))
            }
        ]
    }

    private var perControlOverrideListItemTokens: [ListItemTokenSet.Tokens: ControlTokenValue] {
        return [
            .cellBackgroundGroupedColor: .uiColor {
                // "Brass"
                return UIColor(light: GlobalTokens.sharedColor(.brass, .tint50),
                               dark: GlobalTokens.sharedColor(.brass, .shade40))
            },
            .accessoryDisclosureIndicatorColor: .uiColor {
                // "Forest"
                return UIColor(light: GlobalTokens.sharedColor(.forest, .tint10),
                               dark: GlobalTokens.sharedColor(.forest, .shade40))
            }
        ]
    }
}
