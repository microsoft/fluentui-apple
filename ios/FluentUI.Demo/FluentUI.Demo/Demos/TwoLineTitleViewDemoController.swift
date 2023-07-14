//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class TwoLineTitleViewDemoController: DemoController {
    private typealias UINavigationItemModifier = (UINavigationItem) -> Void
    private typealias TwoLineTitleViewFactory = (_ forBottomSheet: Bool) -> TwoLineTitleView

    private static func createDemoTitleView(forBottomSheet: Bool) -> TwoLineTitleView {
        let twoLineTitleView = TwoLineTitleView()

        if !forBottomSheet {
            // Give it a visible margin so we can confirm it centers properly
            twoLineTitleView.widthAnchor.constraint(equalToConstant: 200).isActive = true
            twoLineTitleView.layer.borderWidth = GlobalTokens.stroke(.width10)
            twoLineTitleView.layer.borderColor = GlobalTokens.neutralColor(.grey50).cgColor
        }

        return twoLineTitleView
    }

    // Return a function that returns the title view because we may end up calling it multiple times in case of bottom sheets
    private static func makeStandardTitleView(title: String,
                                              titleImage: UIImage? = nil,
                                              subtitle: String? = nil,
                                              alignment: TwoLineTitleView.Alignment = .center,
                                              interactivePart: TwoLineTitleView.InteractivePart = .none,
                                              animatesWhenPressed: Bool = true,
                                              accessoryType: TwoLineTitleView.AccessoryType = .none,
                                              customSubtitleTrailingImage: UIImage? = nil,
                                              isTitleImageLeadingForTitleAndSubtitle: Bool = false) -> TwoLineTitleViewFactory {
        return {
            let twoLineTitleView = createDemoTitleView(forBottomSheet: $0)
            twoLineTitleView.setup(title: title,
                                   titleImage: titleImage,
                                   subtitle: subtitle,
                                   alignment: alignment,
                                   interactivePart: interactivePart,
                                   animatesWhenPressed: animatesWhenPressed,
                                   accessoryType: accessoryType,
                                   customSubtitleTrailingImage: customSubtitleTrailingImage,
                                   isTitleImageLeadingForTitleAndSubtitle: isTitleImageLeadingForTitleAndSubtitle)
            return twoLineTitleView
        }
    }

    private static func makeExampleNavigationItem(_ initializer: UINavigationItemModifier) -> UINavigationItem {
        let navigationItem = UINavigationItem()
        initializer(navigationItem)
        return navigationItem
    }

    private let exampleSetupFactories: [TwoLineTitleViewFactory] = [
        makeStandardTitleView(title: "Title here", subtitle: "Optional subtitle", animatesWhenPressed: false),
        makeStandardTitleView(title: "Custom image", titleImage: UIImage(named: "ic_fluent_star_16_regular"), animatesWhenPressed: false),
        makeStandardTitleView(title: "This one", subtitle: "can be tapped", interactivePart: .all),
        makeStandardTitleView(title: "All the bells", titleImage: UIImage(named: "ic_fluent_star_16_regular"), subtitle: "and whistles", alignment: .leading, interactivePart: .subtitle, accessoryType: .downArrow),
        makeStandardTitleView(title: "Leading title", subtitle: "Custom icon", alignment: .leading, interactivePart: .subtitle, accessoryType: .custom, customSubtitleTrailingImage: UIImage(named: "ic_fluent_star_16_regular")),
        makeStandardTitleView(title: "Centered title", subtitle: "Custom icon", alignment: .center, interactivePart: .subtitle, accessoryType: .custom, customSubtitleTrailingImage: UIImage(named: "ic_fluent_star_16_regular")),
        makeStandardTitleView(title: "Centered title", titleImage: UIImage(named: "ic_fluent_star_24_regular"), subtitle: "Custom icon", alignment: .center, interactivePart: .subtitle, accessoryType: .custom, customSubtitleTrailingImage: UIImage(named: "ic_fluent_star_16_regular"), isTitleImageLeadingForTitleAndSubtitle: true),
        makeStandardTitleView(title: "Leading title", titleImage: UIImage(named: "ic_fluent_star_24_regular"), subtitle: "Subtitle", alignment: .leading, interactivePart: .title, accessoryType: .disclosure, customSubtitleTrailingImage: UIImage(named: "ic_fluent_star_16_regular"), isTitleImageLeadingForTitleAndSubtitle: true)
    ]

    private let exampleNavigationItems: [UINavigationItem] = [
        makeExampleNavigationItem {
            $0.title = "Title here"
        },
        makeExampleNavigationItem {
            $0.title = "Another title"
            $0.subtitle = "With a subtitle"
        },
        makeExampleNavigationItem {
            $0.title = "This one"
            $0.subtitle = "has an image"
            $0.titleImage = UIImage(named: "ic_fluent_star_16_regular")
        },
        makeExampleNavigationItem {
            $0.title = "This one"
            $0.subtitle = "has a disclosure chevron"
            $0.titleAccessory = .init(location: .title, style: .disclosure)
        },
        makeExampleNavigationItem {
            $0.title = "They can also be"
            $0.subtitle = "leading-aligned"
            $0.titleStyle = .leading
        },
        makeExampleNavigationItem {
            $0.title = "Leading Title"
            $0.titleStyle = .leading
            $0.subtitle = "Custom icon"
            $0.titleImage = UIImage(named: "ic_fluent_star_16_regular")
            $0.customSubtitleTrailingImage = UIImage(named: "ic_fluent_star_16_regular")
            $0.titleAccessory = .init(location: .subtitle, style: .custom)
        },
        makeExampleNavigationItem {
            $0.title = "Centered Title"
            $0.titleStyle = .system
            $0.subtitle = "Custom icon"
            $0.titleImage = UIImage(named: "ic_fluent_star_16_regular")
            $0.customSubtitleTrailingImage = UIImage(named: "ic_fluent_star_16_regular")
            $0.titleAccessory = .init(location: .subtitle, style: .custom)
        },
        makeExampleNavigationItem {
            $0.title = "Centered Title"
            $0.titleStyle = .system
            $0.subtitle = "Custom icon"
            $0.titleImage = UIImage(named: "ic_fluent_star_24_regular")
            $0.customSubtitleTrailingImage = UIImage(named: "ic_fluent_star_16_regular")
            $0.titleAccessory = .init(location: .subtitle, style: .custom)
            $0.isTitleImageLeadingForTitleAndSubtitle = true
        },
        makeExampleNavigationItem {
            $0.title = "Leading Title"
            $0.titleStyle = .leading
            $0.subtitle = "Subtitle"
            $0.titleImage = UIImage(named: "ic_fluent_star_24_regular")
            $0.customSubtitleTrailingImage = UIImage(named: "ic_fluent_star_16_regular")
            $0.titleAccessory = .init(location: .title, style: .downArrow)
            $0.isTitleImageLeadingForTitleAndSubtitle = true
        }
    ]

    private var allExamples: [TwoLineTitleView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        readmeString = "TwoLineTitleView is intended to be used in a navigation bar or the title of a sheet. It features the ability to show custom icons, a disclosure chevron, and other things.\n\nYou can also populate a bottom sheet with a TwoLineTitleView."

        container.alignment = .leading

        addTitle(text: "Made by calling TwoLineTitleView.setup(...)")
        exampleSetupFactories.enumerated().forEach {
            (offset, element) in
            let twoLineTitleView = element(false)
            allExamples.append(twoLineTitleView)

            let button = Button()
            button.tag = offset
            button.setTitle("Show", for: .normal)
            button.addTarget(self, action: #selector(setupButtonWasTapped), for: .primaryActionTriggered)

            addRow(items: [twoLineTitleView, button])
        }

        addTitle(text: "Made from UINavigationItem")
        addTitle(text: "(requires Navigation subspec)")
        exampleNavigationItems.enumerated().forEach {
            (offset, navigationItem) in
            let twoLineTitleView = Self.createDemoTitleView(forBottomSheet: false)
            twoLineTitleView.setup(navigationItem: navigationItem)
            allExamples.append(twoLineTitleView)

            let button = Button()
            button.tag = offset
            button.setTitle("Show", for: .normal)
            button.addTarget(self, action: #selector(navigationButtonWasTapped), for: .primaryActionTriggered)

            addRow(items: [twoLineTitleView, button])
        }
    }

    @objc private func navigationButtonWasTapped(sender: UIButton) {
        let titleView = TwoLineTitleView()
        titleView.setup(navigationItem: exampleNavigationItems[sender.tag])
        showBottomSheet(with: titleView)
    }

    @objc private func setupButtonWasTapped(sender: UIButton) {
        let titleView = exampleSetupFactories[sender.tag](true)
        showBottomSheet(with: titleView)
    }

    private func showBottomSheet(with titleView: TwoLineTitleView) {
        let sheetContentView = UIView()

        // This is the bottom sheet that will temporarily be displayed after tapping the "Show transient sheet" button.
        // There can be multiple of these on screen at the same time. All the currently presented transient sheets
        // are tracked in presentedTransientSheets.
        let secondarySheetController = BottomSheetController(headerContentView: titleView, expandedContentView: sheetContentView)
        secondarySheetController.headerContentHeight = 44
        secondarySheetController.collapsedContentHeight = 100
        secondarySheetController.isHidden = true
        secondarySheetController.shouldAlwaysFillWidth = false
        secondarySheetController.shouldHideCollapsedContent = false
        secondarySheetController.isFlexibleHeight = true
        secondarySheetController.allowsSwipeToHide = true

        let dismissButton = Button(primaryAction: UIAction(title: "Dismiss", handler: { _ in
            secondarySheetController.setIsHidden(true, animated: true)
        }))

        dismissButton.style = .accent
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        sheetContentView.addSubview(dismissButton)

        addChild(secondarySheetController)
        view.addSubview(secondarySheetController.view)
        secondarySheetController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            secondarySheetController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            secondarySheetController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            secondarySheetController.view.topAnchor.constraint(equalTo: view.topAnchor),
            secondarySheetController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dismissButton.leadingAnchor.constraint(equalTo: sheetContentView.leadingAnchor, constant: 18),
            dismissButton.trailingAnchor.constraint(equalTo: sheetContentView.trailingAnchor, constant: -18),
            dismissButton.bottomAnchor.constraint(equalTo: sheetContentView.safeAreaLayoutGuide.bottomAnchor)
        ])

        // We need to layout before unhiding to ensure the sheet controller
        // has a meaningful initial frame to use for the animation.
        view.layoutIfNeeded()
        secondarySheetController.isHidden = false
    }
}

extension TwoLineTitleViewDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }

        fluentTheme.register(tokenSetType: TwoLineTitleViewTokenSet.self,
                             tokenSet: isOverrideEnabled ? themeWideOverrideTokens : nil)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        allExamples.forEach {
            $0.tokenSet.replaceAllOverrides(with: isOverrideEnabled ? perControlOverrideTokens : nil)
        }
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: TwoLineTitleViewTokenSet.self) != nil
    }

    private var themeWideOverrideTokens: [TwoLineTitleViewTokenSet.Tokens: ControlTokenValue] {
        return [
            .titleColor: .uiColor {
                UIColor(light: GlobalTokens.sharedColor(.green, .primary),
                        dark: GlobalTokens.sharedColor(.green, .tint30))
            },
            .titleFont: .uiFont { UIFont(descriptor: .init(name: "Verdana", size: 17), size: 17) },
            .subtitleColor: .uiColor {
                UIColor(light: GlobalTokens.sharedColor(.red, .primary),
                        dark: GlobalTokens.sharedColor(.red, .tint30))
            }
        ]
    }

    private var perControlOverrideTokens: [TwoLineTitleViewTokenSet.Tokens: ControlTokenValue] {
        return [
            .titleColor: .uiColor {
                UIColor(light: GlobalTokens.sharedColor(.blue, .primary),
                        dark: GlobalTokens.sharedColor(.blue, .tint30))
            },
            .titleFont: .uiFont { UIFont(descriptor: .init(name: "Papyrus", size: 12), size: 12) },
            .subtitleColor: .uiColor {
                UIColor(light: GlobalTokens.sharedColor(.orange, .primary),
                        dark: GlobalTokens.sharedColor(.orange, .tint30))
            },
            .subtitleFont: .uiFont { UIFont(descriptor: .init(name: "Papyrus", size: 10), size: 10) }
        ]
    }
}
