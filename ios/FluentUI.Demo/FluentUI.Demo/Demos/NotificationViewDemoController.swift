//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class NotificationViewDemoController: DemoController {
    enum Variant: Int, CaseIterable {
        case accentToast
        case accentToastWithImageAndTitle
        case neutralToast
        case dangerToast
        case warningToast
        case accentBar
        case subtleBar
        case neutralBar
        case persistentBarWithAction
        case persistentBarWithCancel
        case accentToastWithStrikethroughAttribute
        case neutralBarWithFontAttribute
        case neutralToastWithOverriddenTokens
        case neutralToastWithGradientBackground
        case warningToastWithFlexibleWidth

        var displayText: String {
            switch self {
            case .accentToast:
                return "Accent Toast with auto-hide"
            case .accentToastWithImageAndTitle:
                return "Accent Toast with image and title"
            case .neutralToast:
                return "Neutral Toast"
            case .dangerToast:
                return "Danger Toast"
            case .warningToast:
                return "Warning Toast"
            case .accentBar:
                return "Accent Bar"
            case .subtleBar:
                return "Subtle Bar"
            case .neutralBar:
                return "Neutral Bar"
            case .persistentBarWithAction:
                return "Persistent Bar with Action"
            case .persistentBarWithCancel:
                return "Persistent Bar with Cancel"
            case .accentToastWithStrikethroughAttribute:
                return "Accent Toast with Strikethrough Attribute"
            case .neutralBarWithFontAttribute:
                return "Neutral Bar with Font Attribute"
            case .neutralToastWithOverriddenTokens:
                return "Neutral Toast With Overridden Tokens"
            case .neutralToastWithGradientBackground:
                return "Neutral Toast With Gradient Background"
            case .warningToastWithFlexibleWidth:
                return "Warning Toast With Flexible Width"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.surfaceSecondary

        addTitle(text: "SwiftUI Demo")
        container.addArrangedSubview(createButton(title: "Show", action: #selector(showSwiftUIDemo)))

        for (index, variant) in Variant.allCases.enumerated() {
            if index > 0 {
                // spacers
                container.addArrangedSubview(UIView())
                container.addArrangedSubview(UIView())
            }
            addTitle(text: variant.displayText)
            container.addArrangedSubview(createButton(title: "Show", action: #selector(showNotificationView)))
        }
        container.alignment = .leading
    }

    private func createNotificationView(forVariant variant: Variant) -> MSFNotification {
        switch variant {
        case .accentToast:
            let notification = MSFNotification(style: .accentToast)
            notification.state.message = "Mail Archived"
            notification.state.actionButtonTitle = "Undo"
            notification.state.actionButtonAction = { [weak self] in
                self?.showMessage("`Undo` tapped")
                notification.hide()
            }
            return notification
        case .accentToastWithImageAndTitle:
            let notification = MSFNotification(style: .accentToast)
            notification.state.message = "Listen to Emails • 7 mins"
            notification.state.title = "Kat's iPhoneX"
            notification.state.image = UIImage(named: "play-in-circle-24x24")
            notification.state.actionButtonAction = { [weak self] in
                self?.showMessage("`Dismiss` tapped")
                notification.hide()
            }
            notification.state.messageButtonAction = { [weak self] in
                self?.showMessage("`Listen to emails` tapped")
                notification.hide()
            }
            return notification
        case .neutralToast:
            let notification = MSFNotification(style: .neutralToast)
            notification.state.message = "Some items require you to sign in to view them"
            notification.state.actionButtonTitle = "Sign in"
            notification.state.actionButtonAction = { [weak self] in
                self?.showMessage("`Sign in` tapped")
                notification.hide()
            }
            return notification
        case .dangerToast:
            let notification = MSFNotification(style: .dangerToast)
            notification.state.message = "There was a problem, and your recent changes may not have saved"
            notification.state.actionButtonTitle = "Retry"
            notification.state.actionButtonAction = { [weak self] in
                self?.showMessage("`Retry` tapped")
                notification.hide()
            }
            return notification
        case .warningToast:
            let notification = MSFNotification(style: .warningToast)
            notification.state.message = "Read Only"
            notification.state.actionButtonAction = { [weak self] in
                self?.showMessage("`Dismiss` tapped")
                notification.hide()
            }
            return notification
        case .accentBar:
            let notification = MSFNotification(style: .accentBar)
            notification.state.message = "Updating..."
            return notification
        case .subtleBar:
            let notification = MSFNotification(style: .subtleBar)
            notification.state.message = "Mail Sent"
            return notification
        case .neutralBar:
            let notification = MSFNotification(style: .neutralBar)
            notification.state.message = "No internet connection"
            return notification
        case .persistentBarWithAction:
            let notification = MSFNotification(style: .neutralBar)
            notification.state.message = "This error can be taken action on with the action on the right."
            notification.state.actionButtonTitle = "Action"
            notification.state.actionButtonAction = { [weak self] in
                self?.showMessage("`Action` tapped")
                notification.hide()
            }
            return notification
        case .persistentBarWithCancel:
            let notification = MSFNotification(style: .neutralBar)
            notification.state.message = "This error can be tapped or dismissed with the icon to the right."
            notification.state.actionButtonAction = { [weak self] in
                self?.showMessage("`Dismiss` tapped")
                notification.hide()
            }
            notification.state.messageButtonAction = { [weak self] in
                self?.showMessage("`Dismiss` tapped")
                notification.hide()
            }
            return notification
        case .accentToastWithStrikethroughAttribute:
            let notification = MSFNotification(style: .accentToast)
            notification.state.attributedMessage = NSAttributedString(string: "This is a toast with a blue strikethrough attribute.",
                                                                      attributes: [.font: UIFont.preferredFont(forTextStyle: .body),
                                                                                   .strikethroughStyle: 1,
                                                                                   .strikethroughColor: UIColor.blue])
            notification.state.actionButtonAction = { [weak self] in
                self?.showMessage("`Dismiss` tapped")
                notification.hide()
            }
            return notification
        case .neutralBarWithFontAttribute:
            let notification = MSFNotification(style: .neutralBar)
            notification.state.attributedMessage = NSAttributedString(string: "This is a bar with red Papyrus font attribute.",
                                                                      attributes: [.font: UIFont.init(name: "Papyrus",
                                                                                                      size: 30.0)!,
                                                                                   .foregroundColor: UIColor.red])
            notification.state.actionButtonAction = { [weak self] in
                self?.showMessage("`Dismiss` tapped")
                notification.hide()
            }
            return notification
        case .neutralToastWithOverriddenTokens:
            let notification = MSFNotification(style: .neutralToast)
            notification.state.message = "The image color and spacing between the elements of this notification have been customized with override tokens."
            notification.state.image = UIImage(named: "play-in-circle-24x24")
            notification.state.overrideTokens = NotificationOverrideTokens()
            notification.state.actionButtonAction = { [weak self] in
                self?.showMessage("`Dismiss` tapped")
                notification.hide()
            }
            return notification
        case .neutralToastWithGradientBackground:
            let notification = MSFNotification(style: .neutralToast)
            notification.state.message = "The background of this notification has been customized with a gradient."
            notification.state.image = UIImage(named: "play-in-circle-24x24")
            // It's a lovely blue-to-pink gradient
            let colors: [DynamicColor] = [DynamicColor(light: GlobalTokens.sharedColors(.pink, .tint50),
                                                       dark: GlobalTokens.sharedColors(.pink, .shade40)),
                                          DynamicColor(light: GlobalTokens.sharedColors(.cyan, .tint50),
                                                       dark: GlobalTokens.sharedColors(.cyan, .shade40))]
            notification.state.backgroundGradient = GradientInfo(colors: colors,
                                                                 startPoint: .init(x: 0.0, y: 1.0),
                                                                 endPoint: .init(x: 1.0, y: 0.0))
            notification.state.actionButtonAction = { [weak self] in
                self?.showMessage("`Dismiss` tapped")
                notification.hide()
            }
            return notification
        case .warningToastWithFlexibleWidth:
            let notification = MSFNotification(style: .warningToast,
                                               isFlexibleWidthToast: true)
            notification.state.message = "This toast has a flexible width which means the width is based on the content rather than the screen size."
            notification.state.overrideTokens = NotificationOverrideTokens()
            notification.state.actionButtonAction = { [weak self] in
                self?.showMessage("`Dismiss` tapped")
                notification.hide()
            }
            return notification
        }
    }

    private class NotificationOverrideTokens: NotificationTokens {
        override var imageColor: DynamicColor {
            return DynamicColor(light: GlobalTokens.sharedColors(.orange, .primary))
        }

        override var horizontalSpacing: CGFloat {
            return 5.0
        }
    }

    @objc private func showNotificationView(sender: UIButton) {
        guard let index = container.arrangedSubviews.filter({ $0 is UIButton }).firstIndex(of: sender), let variant = Variant(rawValue: index - 1) else {
            preconditionFailure("showNotificationView is used for a button in the wrong container")
        }

        createNotificationView(forVariant: variant).show(in: view) { $0.hide(after: 3.0) }
    }

    @objc private func showSwiftUIDemo() {
        navigationController?.pushViewController(NotificationViewDemoControllerSwiftUI(),
                                                 animated: true)
    }
}
