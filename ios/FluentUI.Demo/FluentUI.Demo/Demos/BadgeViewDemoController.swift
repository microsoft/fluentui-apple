//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class BadgeViewDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addBadgeSection(title: "Default badge", style: .default)
        addBadgeSection(title: "Error badge", style: .error)
        addBadgeSection(title: "Warning badge", style: .warning)
        addBadgeSection(title: "Disabled badge", style: .default, isEnabled: false)
        addBadgeSection(title: "Custom badge", style: .default, overrideColor: true)
        addBadgeSection(title: "Custom disabled badge", style: .default, isEnabled: false, overrideColor: true)

        addCustomBadgeSections()
    }

    func createBadge(
        text: String,
        style: BadgeView.Style,
        size: BadgeView.Size,
        isEnabled: Bool,
        customView: UIView? = nil,
        customViewVerticalPadding: NSNumber? = nil,
        customViewLeftPadding: NSNumber? = nil,
        customViewRightPadding: NSNumber? = nil
    ) -> BadgeView {
        let dataSource = BadgeViewDataSource(
            text: text,
            style: style,
            size: size,
            customView: customView,
            customViewVerticalPadding: customViewVerticalPadding,
            customViewPaddingLeft: customViewLeftPadding,
            customViewPaddingRight: customViewRightPadding
        )

        let badge = BadgeView(dataSource: dataSource)
        badge.delegate = self
        badge.isActive = isEnabled
        return badge
    }

    func addBadgeSection(title: String, style: BadgeView.Style, isEnabled: Bool = true, overrideColor: Bool = false) {
        addTitle(text: title)
        for size in BadgeView.Size.allCases.reversed() {
            let badge = createBadge(text: "Kat Larsson", style: style, size: size, isEnabled: isEnabled)
            if overrideColor {
                if isEnabled {
                    badge.backgroundColor = Colors.Palette.blueMagenta20.color
                    badge.selectedBackgroundColor = Colors.Palette.cyanBlue20.color
                    badge.labelTextColor = Colors.Palette.gray50.color
                    badge.selectedLabelTextColor = Colors.Palette.gray100.color
                } else {
                    badge.disabledBackgroundColor = Colors.Palette.gray100.color
                    badge.disabledLabelTextColor = Colors.Palette.gray600.color
                }
            }
            addRow(text: size.description, items: [badge])
        }
        container.addArrangedSubview(UIView())
    }

    func addCustomBadgeSections() {
        addTitle(text: "Badge with custom view")

        let imageView = UIImageView(image: UIImage(named: "ic_fluent_add_20_regular")?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .white
        imageView.frame.size = CGSize(width: 20, height: 20)

        let avatar = MSFAvatar(style: .default, size: .xsmall)
        avatar.configuration.image = UIImage(named: "avatar_kat_larsson")

        let dataSource: [(BadgeView.Size, UIView)] = [
            (.medium, imageView),
            (.small, avatar.view)
        ]

        for (size, customView) in dataSource {
            let badge = createBadge(
                text: "Kat Larsson",
                style: .default,
                size: size,
                isEnabled: false,
                customView: customView,
                customViewVerticalPadding: 3
            )
            badge.disabledBackgroundColor = Colors.Palette.blueMagenta20.color
            badge.disabledLabelTextColor = .white

            addRow(text: size.description, items: [badge])
        }

        container.addArrangedSubview(UIView())
    }
}

extension BadgeViewDemoController: BadgeViewDelegate {
    func didSelectBadge(_ badge: BadgeView) { }

    func didTapSelectedBadge(_ badge: BadgeView) {
        badge.isSelected = false
        let alert = UIAlertController(title: "A selected badge was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension BadgeView.Size {
    var description: String {
        switch self {
        case .small:
            return "Small"
        case .medium:
            return "Medium"
        }
    }
}
