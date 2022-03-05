//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class PillButtonBarDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()
        container.layoutMargins.right = 0
        container.layoutMargins.left = 0
        var items: [PillButtonBarItem] = [PillButtonBarItem(title: "All"),
                                          PillButtonBarItem(title: "Documents"),
                                          PillButtonBarItem(title: "People", isUnread: true),
                                          PillButtonBarItem(title: "Other"),
                                          PillButtonBarItem(title: "Templates"),
                                          PillButtonBarItem(title: "Actions"),
                                          PillButtonBarItem(title: "More")]

        let disableOnBrandSwitchView = UISwitch()
        disableOnBrandSwitchView.isOn = true
        disableOnBrandSwitchView.addTarget(self, action: #selector(toggleOnBrandPills(switchView:)), for: .valueChanged)

        container.addArrangedSubview(createLabelWithText("onBrand"))
        addSectionToggle(toggleTitle: createLabelWithText("Enable/Disable pills in onBrand Pill Bar"), switchView: disableOnBrandSwitchView)
        let onBrandBar = createBar(items: items, style: .onBrand)
        container.addArrangedSubview(onBrandBar)
        self.onBrandBar = onBrandBar
        container.addArrangedSubview(UIView())

        let disableCustomOnBrandSwitchView = UISwitch()
        disableCustomOnBrandSwitchView.isOn = true
        disableCustomOnBrandSwitchView.addTarget(self, action: #selector(toggleCustomOnBrandPills(switchView:)), for: .valueChanged)

        container.addArrangedSubview(createLabelWithText("onBrand With Custom Pills Background"))
        addSectionToggle(toggleTitle: createLabelWithText("Enable/Disable pills in custom onBrand Pill Bar"), switchView: disableCustomOnBrandSwitchView)
        let customBar = createBar(items: items, style: .onBrand, useCustomPillsColors: true)
        container.addArrangedSubview(customBar)
        self.customBar = customBar
        container.addArrangedSubview(UIView())

        let disablePrimarySwitchView = UISwitch()
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let window = view.window {
            onBrandBar?.backgroundColor = UIColor(light: Colors.primary(for: window), dark: Colors.navigationBarBackground)
            customBar?.backgroundColor = UIColor(light: Colors.primary(for: window), dark: Colors.navigationBarBackground)
        }
    }

    func createBar(items: [PillButtonBarItem], style: PillButtonStyle = .primary, centerAligned: Bool = false, disabledItems: Bool = false, useCustomPillsColors: Bool = false) -> UIView {
        let bar = PillButtonBar(pillButtonStyle: style)
        bar.pillButtonOverrideTokens = useCustomPillsColors ? CustomPillButtonTokens() : nil
        bar.items = items
        _ = bar.selectItem(atIndex: 0)
        bar.barDelegate = self
        bar.centerAligned = centerAligned
        bars.append(bar)

        if disabledItems {
            items.forEach { bar.disableItem($0) }
        }

        let backgroundView = UIView()
        if style == .primary {
            backgroundView.backgroundColor = Colors.navigationBarBackground
        }

        backgroundView.addSubview(bar)
        let margins = UIEdgeInsets(top: 16.0, left: 0, bottom: 16.0, right: 0.0)
        fitViewIntoSuperview(bar, margins: margins)
        return backgroundView
    }

    func createLabelWithText(_ text: String = "") -> Label {
        let label = Label(style: .subhead, colorStyle: .regular)
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

    private class CustomPillButtonTokens: PillButtonTokens {
        override var backgroundColor: PillButtonDynamicColors {
            return .init(rest: Colors.textOnAccent.dynamicColor ?? super.backgroundColor.rest,
                         selected: Colors.textPrimary.dynamicColor ?? super.backgroundColor.selected,
                         disabled: Colors.surfaceQuaternary.dynamicColor ?? super.backgroundColor.disabled,
                         selectedDisabled: Colors.surfaceSecondary.dynamicColor ?? super.backgroundColor.selectedDisabled)
        }

        override var titleColor: PillButtonDynamicColors {
            return .init(rest: Colors.textPrimary.dynamicColor ?? super.titleColor.rest,
                         selected: Colors.textOnAccent.dynamicColor ?? super.titleColor.selected,
                         disabled: Colors.textDisabled.dynamicColor ?? super.titleColor.disabled,
                         selectedDisabled: Colors.textDisabled.dynamicColor ?? super.titleColor.disabled)
        }

        override var enabledUnreadDotColor: DynamicColor {
            return Colors.textPrimary.dynamicColor ?? super.enabledUnreadDotColor
        }
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

        var tokensClosure: ((PillButton) -> PillButtonTokens)?
        if isOverrideEnabled {
            tokensClosure = { _ in
                return ThemeWideOverridePillButtonTokens()
            }
        }

        fluentTheme.register(controlType: PillButton.self, tokens: tokensClosure)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        self.bars.forEach({ bar in
            let tokens = isOverrideEnabled ? PerControlOverridePillButtonTokens() : nil
            bar.pillButtonOverrideTokens = tokens
        })
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokenOverride(for: PillButton.self) != nil
    }

    // MARK: - Custom tokens

    private class ThemeWideOverridePillButtonTokens: PillButtonTokens {
        override var font: FontInfo {
            return FontInfo(name: "Times", size: 15.0, weight: .regular)
        }
    }

    private class PerControlOverridePillButtonTokens: PillButtonTokens {
        override var backgroundColor: PillButtonDynamicColors {
            return .init(rest: DynamicColor(light: ColorValue(r: CGFloat.random(in: 0.25...0.5),
                                                              g: CGFloat.random(in: 0.25...0.5),
                                                              b: CGFloat.random(in: 0.25...0.5),
                                                              a: 0.75)),
                         selected: DynamicColor(light: ColorValue(r: CGFloat.random(in: 0.75...1),
                                                                  g: CGFloat.random(in: 0.75...1),
                                                                  b: CGFloat.random(in: 0.75...1),
                                                                  a: 1)),
                         disabled: super.backgroundColor.disabled,
                         selectedDisabled: super.backgroundColor.selectedDisabled)
        }

        override var titleColor: PillButtonDynamicColors {
            return .init(rest: DynamicColor(light: globalTokens.neutralColors[.white]),
                         selected: DynamicColor(light: globalTokens.neutralColors[.black]),
                         disabled: super.titleColor.disabled,
                         selectedDisabled: super.titleColor.selectedDisabled)
        }

        override var font: FontInfo {
            return FontInfo(name: "Papyrus", size: 10.0, weight: .regular)
        }
    }
}
