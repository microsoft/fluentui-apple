//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class PillButtonBarDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        readmeString = "A pill button bar lets someone select one option from a set of two or more pill-shaped buttons aligned horizontally.\n\nPill button bars are ideal for narrowing down the information someone sees on a page, like filtering information. They’re often used in conjunction with search bars. "

        container.layoutMargins.right = 0
        container.layoutMargins.left = 0
        var items: [PillButtonBarItem] = [PillButtonBarItem(title: "All"),
                                          PillButtonBarItem(title: "Documents"),
                                          PillButtonBarItem(title: "People", isUnread: true),
                                          PillButtonBarItem(title: "Other"),
                                          PillButtonBarItem(title: "Templates"),
                                          PillButtonBarItem(title: "Actions"),
                                          PillButtonBarItem(title: "More")]

        let disableOnBrandSwitchView = BrandedSwitch()
        disableOnBrandSwitchView.isOn = true
        disableOnBrandSwitchView.addTarget(self, action: #selector(toggleOnBrandPills(switchView:)), for: .valueChanged)

        container.addArrangedSubview(createLabelWithText("onBrand"))
        addSectionToggle(toggleTitle: createLabelWithText("Enable/Disable pills in onBrand Pill Bar"), switchView: disableOnBrandSwitchView)
        let onBrandBar = createBar(items: items, style: .onBrand)
        container.addArrangedSubview(onBrandBar)
        self.onBrandBar = onBrandBar
        container.addArrangedSubview(UIView())

        let disableCustomOnBrandSwitchView = BrandedSwitch()
        disableCustomOnBrandSwitchView.isOn = true
        disableCustomOnBrandSwitchView.addTarget(self, action: #selector(toggleCustomOnBrandPills(switchView:)), for: .valueChanged)

        container.addArrangedSubview(createLabelWithText("onBrand With Custom Pills Background"))
        addSectionToggle(toggleTitle: createLabelWithText("Enable/Disable pills in custom onBrand Pill Bar"), switchView: disableCustomOnBrandSwitchView)
        let customBar = createBar(items: items, style: .onBrand, useCustomPillsColors: true)
        container.addArrangedSubview(customBar)
        self.customBar = customBar
        container.addArrangedSubview(UIView())

        let disablePrimarySwitchView = BrandedSwitch()
        disablePrimarySwitchView.isOn = true
        disablePrimarySwitchView.addTarget(self, action: #selector(togglePrimaryPills(switchView:)), for: .valueChanged)

        container.addArrangedSubview(createLabelWithText("Primary"))
        addSectionToggle(toggleTitle: createLabelWithText("Enable/Disable pills in Primary Pill bar"), switchView: disablePrimarySwitchView)
        let primaryBar = createBar(items: items)
        container.addArrangedSubview(primaryBar)
        self.primaryBar = primaryBar
        container.addArrangedSubview(UIView())

        // When inserting longer button "Templates" instead of shorter "Other" button as the fourth button, compact layouts (most iPhones)
        // will end up with a button configuration where the last visible button won't be a clear indication that the view is scrollable,
        // so our algorithm to adjust insets and spacings will kick in, making the three first buttons longer than in the previous line.
        let item = items.remove(at: 4)
        items.insert(item, at: 3)

        container.addArrangedSubview(createLabelWithText("Optimized for scrolling visibility"))
        addDescription(text: "On a narrow screen like iPhone Portrait, the default sizes will leave the next button hidden. Spacing and button sizing is changed to make clear that the view can be scrolled")
        container.addArrangedSubview(createBar(items: items))
        container.addArrangedSubview(UIView())

        items = Array(items[0...1])
        container.addArrangedSubview(createLabelWithText("Leading Aligned"))
        container.addArrangedSubview(createBar(items: items))
        container.addArrangedSubview(UIView())

        container.addArrangedSubview(createLabelWithText("Center Aligned"))
        let bar = createBar(items: items, centerAligned: true)
        container.addArrangedSubview(bar)
        container.addArrangedSubview(UIView())
    }

    func createBar(items: [PillButtonBarItem], style: PillButtonStyle = .primary, centerAligned: Bool = false, disabledItems: Bool = false, useCustomPillsColors: Bool = false) -> UIView {
        let bar = PillButtonBar(pillButtonStyle: style)
        bar.pillButtonOverrideTokens = useCustomPillsColors ? customPillButtonTokens : nil
        bar.items = items
        _ = bar.selectItem(atIndex: 0)
        bar.barDelegate = self
        bar.centerAligned = centerAligned
        bars.append(bar)

        if disabledItems {
            items.forEach { bar.disableItem($0) }
        }

        let backgroundStyle: ColoredPillBackgroundStyle = {
            switch style {
            case .primary:
                return .neutralNavBar
            case .onBrand:
                return .brandNavBar
            }
        }()

        let backgroundView = ColoredPillBackgroundView(style: backgroundStyle)
        backgroundView.addSubview(bar)
        let margins = UIEdgeInsets(top: 16.0, left: 0, bottom: 16.0, right: 0.0)
        fitViewIntoSuperview(bar, margins: margins)
        return backgroundView
    }

    func createLabelWithText(_ text: String = "") -> Label {
        let label = Label()
        label.text = text
        label.textAlignment = .center
        return label
    }

    func addSectionToggle(toggleTitle: Label, switchView: UISwitch) {
        toggleTitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        switchView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        addRow(items: [toggleTitle, switchView], itemSpacing: 20, centerItems: true)
    }

    func fitViewIntoSuperview(_ view: UIView, margins: UIEdgeInsets) {
        guard let superview = view.superview else {
            return
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: margins.left),
                           view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -margins.right),
                           view.topAnchor.constraint(equalTo: superview.topAnchor, constant: margins.top),
                           view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -margins.bottom)]

        NSLayoutConstraint.activate(constraints)
    }

    func togglePills(pillBar: PillButtonBar, enable: Bool) {
        if let items = pillBar.items {
            if enable {
                for item in items {
                    pillBar.enableItem(item)
                }
            } else {
                for item in items {
                    pillBar.disableItem(item)
                }
            }
        }
    }

    @objc private func toggleOnBrandPills(switchView: UISwitch) {
        if let pillBar = self.onBrandBar?.subviews.first as? PillButtonBar {
            togglePills(pillBar: pillBar, enable: switchView.isOn)
        }
    }

    @objc private func toggleCustomOnBrandPills(switchView: UISwitch) {
        if let pillBar = self.customBar?.subviews.first as? PillButtonBar {
            togglePills(pillBar: pillBar, enable: switchView.isOn)
        }
    }

    @objc private func togglePrimaryPills(switchView: UISwitch) {
        if let pillBar = self.primaryBar?.subviews.first as? PillButtonBar {
            togglePills(pillBar: pillBar, enable: switchView.isOn)
        }
    }

    private var onBrandBar: UIView?

    private var customBar: UIView?

    private var primaryBar: UIView?

    private var bars: [PillButtonBar] = []

    private var customPillButtonTokens: [PillButtonTokenSet.Tokens: ControlTokenValue] {
        let theme = FluentTheme()
        return [
            .backgroundColor: .uiColor { theme.color(.strokeFocus1) },

            .backgroundColorSelected: .uiColor { theme.color(.strokeFocus2) },

            .backgroundColorDisabled: .uiColor { theme.color(.strokeFocus1) },

            .backgroundColorSelectedDisabled: .uiColor { theme.color(.strokeFocus1) },

            .titleColor: .uiColor { theme.color(.strokeFocus2) },

            .titleColorSelected: .uiColor { theme.color(.strokeFocus1) },

            .titleColorDisabled: .uiColor { theme.color(.strokeFocus2) },

            .titleColorSelectedDisabled: .uiColor { theme.color(.strokeFocus2) },

            .enabledUnreadDotColor: .uiColor { theme.color(.strokeFocus2) }
        ]
    }
}

// MARK: - PillButtonBarDemoController: PillButtonBarDelegate

extension PillButtonBarDemoController: PillButtonBarDelegate {
    func pillBar(_ pillBar: PillButtonBar, didSelectItem item: PillButtonBarItem, atIndex index: Int) {
        let alert = UIAlertController(title: "Item \(item.title) was selected", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension PillButtonBarDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }

        fluentTheme.register(tokenSetType: PillButtonTokenSet.self,
                             tokenSet: isOverrideEnabled ? themeWideOverridePillButtonTokens : nil)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        self.bars.forEach({ bar in
            let tokens = isOverrideEnabled ? perControlOverridePillButtonTokens : nil
            bar.pillButtonOverrideTokens = tokens
        })
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: PillButtonTokenSet.self) != nil
    }

    // MARK: - Custom tokens

    private var themeWideOverridePillButtonTokens: [PillButtonTokenSet.Tokens: ControlTokenValue] {
        return [
            .font: .uiFont {
                return UIFont(descriptor: .init(name: "Times", size: 10.0), size: 10.0)
            }
        ]
    }

    private var perControlOverridePillButtonTokens: [PillButtonTokenSet.Tokens: ControlTokenValue] {
        return [
            .backgroundColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.steel, .tint40),
                               dark: GlobalTokens.sharedColor(.steel, .shade30))
            },

            .backgroundColorSelected: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.pumpkin, .tint40),
                               dark: GlobalTokens.sharedColor(.pumpkin, .shade30))
            },

            .backgroundColorDisabled: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.darkTeal, .tint40),
                               dark: GlobalTokens.sharedColor(.darkTeal, .shade30))
            },

            .backgroundColorSelectedDisabled: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.orchid, .tint40),
                               dark: GlobalTokens.sharedColor(.orchid, .shade30))
            },

            .titleColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.steel, .shade30),
                               dark: GlobalTokens.sharedColor(.steel, .tint40))
            },

            .titleColorSelected: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.pumpkin, .shade30),
                               dark: GlobalTokens.sharedColor(.pumpkin, .tint40))
            },

            .titleColorDisabled: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.darkTeal, .shade30),
                               dark: GlobalTokens.sharedColor(.darkTeal, .tint40))
            },

            .titleColorSelectedDisabled: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.orchid, .shade30),
                               dark: GlobalTokens.sharedColor(.orchid, .tint40))
            },

            .font: .uiFont {
                return UIFont(descriptor: .init(name: "Papyrus", size: 10.0), size: 10.0)
            }
        ]
    }
}
