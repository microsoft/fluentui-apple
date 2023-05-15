//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class NotificationViewDemoController: DemoController {
    enum Variant: Int, CaseIterable {
        case primaryToast
        case primaryToastWithImageAndTitle
        case neutralToast
        case dangerToast
        case warningToast
        case primaryBar
        case primaryOutlineBar
        case neutralBar
        case persistentBarWithAction
        case persistentBarWithCancel
        case primaryToastWithStrikethroughAttribute
        case neutralBarWithFontAttribute
        case neutralBarFromTop
        case neutralToastWithOverriddenTokens
        case neutralToastWithGradientBackground
        case warningToastWithFlexibleWidth

        var displayText: String {
            switch self {
            case .primaryToast:
                return "Primary Toast with auto-hide"
            case .primaryToastWithImageAndTitle:
                return "Primary Toast with image and title"
            case .neutralToast:
                return "Neutral Toast"
            case .dangerToast:
                return "Danger Toast"
            case .warningToast:
                return "Warning Toast"
            case .primaryBar:
                return "Primary Bar"
            case .primaryOutlineBar:
                return "Primary Outline Bar"
            case .neutralBar:
                return "Neutral Bar"
            case .persistentBarWithAction:
                return "Persistent Bar with Action"
            case .persistentBarWithCancel:
                return "Persistent Bar with Cancel"
            case .primaryToastWithStrikethroughAttribute:
                return "Primary Toast with Strikethrough Attribute"
            case .neutralBarWithFontAttribute:
                return "Neutral Bar with Font Attribute"
            case .neutralBarFromTop:
                return "Neutral Bar Presented from Top"
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
        readmeString = "Notifications deliver helpful messages related to the action someone is taking. They should communicate information people can use right away.\n\nNotifications are great for giving people feedback or communicating a task’s status. If you need to show recommendations or upsell features of your app, try a card nudge instead."
        view.backgroundColor = view.fluentTheme.color(.background4)

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
        case .primaryToast:
            let notification = MSFNotification(style: .primaryToast)
            notification.state.message = "Mail Archived"
            notification.state.actionButtonTitle = "Undo"
            notification.state.actionButtonAction = { [weak self] in
                self?.showMessage("`Undo` tapped")
                notification.hide()
            }
            return notification
        case .primaryToastWithImageAndTitle:
            let notification = MSFNotification(style: .primaryToast)
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
        case .primaryBar:
            let notification = MSFNotification(style: .primaryBar)
            notification.state.message = "Updating..."
            return notification
        case .primaryOutlineBar:
            let notification = MSFNotification(style: .primaryOutlineBar)
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
        case .primaryToastWithStrikethroughAttribute:
            let notification = MSFNotification(style: .primaryToast)
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
            let font = UIFont(descriptor: .init(name: "Papyrus", size: 30.0),
                              size: 30.0)
            notification.state.attributedMessage = NSAttributedString(string: "This is a bar with red Papyrus font attribute.",
                                                                      attributes: [.font: font,
                                                                                   .foregroundColor: UIColor.red])
            notification.state.actionButtonAction = { [weak self] in
                self?.showMessage("`Dismiss` tapped")
                notification.hide()
            }
            return notification
        case .neutralBarFromTop:
            let notification = MSFNotification(style: .neutralBar)
            notification.state.message = "This is a bar presented from the top."
            notification.state.showFromBottom = false
            notification.state.actionButtonAction = { [weak self] in
                self?.showMessage("`Dismiss` tapped")
                notification.hide()
            }
            return notification
        case .neutralToastWithOverriddenTokens:
            let notification = MSFNotification(style: .neutralToast)
            notification.state.message = "The image color and spacing between the elements of this notification have been customized with override tokens."
            notification.state.image = UIImage(named: "play-in-circle-24x24")
            notification.tokenSet.replaceAllOverrides(with: notificationOverrideTokens)
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
            let colors: [UIColor] = [UIColor(light: GlobalTokens.sharedColor(.pink, .tint50),
                                             dark: GlobalTokens.sharedColor(.pink, .shade40)),
                                     UIColor(light: GlobalTokens.sharedColor(.cyan, .tint50),
                                             dark: GlobalTokens.sharedColor(.cyan, .shade40))]
            notification.state.backgroundGradient = LinearGradientInfo(colors: colors,
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
            notification.tokenSet.replaceAllOverrides(with: notificationOverrideTokens)
            notification.state.actionButtonAction = { [weak self] in
                self?.showMessage("`Dismiss` tapped")
                notification.hide()
            }
            return notification
        }
    }

    private var notificationOverrideTokens: [NotificationTokenSet.Tokens: ControlTokenValue] {
        return [
            .imageColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.orange, .primary))
            },
            .shadow: .shadowInfo {
                return ShadowInfo(keyColor: GlobalTokens.sharedColor(.hotPink, .primary),
                                  keyBlur: 10.0,
                                  xKey: 10.0,
                                  yKey: 10.0,
                                  ambientColor: GlobalTokens.sharedColor(.teal, .primary),
                                  ambientBlur: 100.0,
                                  xAmbient: -10.0,
                                  yAmbient: -10.0)
            }
        ]
    }

    @objc private func showNotificationView(sender: UIButton) {
        guard let index = container.arrangedSubviews.filter({ $0 is UIButton }).firstIndex(of: sender), let variant = Variant(rawValue: index - 1) else {
            preconditionFailure("showNotificationView is used for a button in the wrong container")
        }

        let notification = createNotificationView(forVariant: variant)
        notification.tokenSet.replaceAllOverrides(with: overrideTokens)
        notification.show(in: view) { [weak self] in
            $0.hide(after: 3.0) {
                self?.currentNotification = nil
            }
        }
        currentNotification = notification
    }

    @objc private func showSwiftUIDemo() {
        navigationController?.pushViewController(NotificationViewDemoControllerSwiftUI(),
                                                 animated: true)
    }

    private var currentNotification: MSFNotification?
    private var overrideTokens: [NotificationTokenSet.Tokens: ControlTokenValue]?
}

extension NotificationViewDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }

        fluentTheme.register(tokenSetType: NotificationTokenSet.self,
                             tokenSet: isOverrideEnabled ? themeWideOverrideNotificationTokens : nil)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        overrideTokens = isOverrideEnabled ? perControlOverrideNotificationTokens : nil
        if let currentNotification {
            currentNotification.tokenSet.replaceAllOverrides(with: overrideTokens)
        }
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: NotificationTokenSet.self) != nil
    }

    // MARK: - Custom tokens

    private var themeWideOverrideNotificationTokens: [NotificationTokenSet.Tokens: ControlTokenValue] {
        return [
            .backgroundColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.marigold, .shade30),
                               dark: GlobalTokens.sharedColor(.marigold, .tint40))
            },
            .foregroundColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.marigold, .tint40),
                               dark: GlobalTokens.sharedColor(.marigold, .shade30))
            }
        ]
    }

    private var perControlOverrideNotificationTokens: [NotificationTokenSet.Tokens: ControlTokenValue] {
        return [
            .backgroundColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.orchid, .shade30),
                               dark: GlobalTokens.sharedColor(.orchid, .tint40))
            },
            .foregroundColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.orchid, .tint40),
                               dark: GlobalTokens.sharedColor(.orchid, .shade30))
            }
        ]
    }
}
