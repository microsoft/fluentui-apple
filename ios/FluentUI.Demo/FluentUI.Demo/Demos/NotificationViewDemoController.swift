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
        case neutralToastWithOverriddenTokens
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
            case .neutralToastWithOverriddenTokens:
                return "Neutral Toast With Overridden Tokens"
            case .warningToastWithFlexibleWidth:
                return "Warning Toast With Flexible Width"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.surfaceSecondary

        addTitle(text: "SwiftUI Demo")
        container.addArrangedSubview(createButton(title: "Show", action: { [weak self] _ in
            self?.navigationController?.pushViewController(NotificationViewDemoControllerSwiftUI(),
                                                           animated: true)
        }))

        for (index, variant) in Variant.allCases.enumerated() {
            if index > 0 {
                // spacers
                container.addArrangedSubview(UIView())
                container.addArrangedSubview(UIView())
            }
            addTitle(text: variant.displayText)

            let showButton = MSFButton(style: .secondary, size: .small, action: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }

                strongSelf.createNotificationView(forVariant: variant).show(in: strongSelf.view) {
                    $0.hide(after: 3.0)
                }
            })
            showButton.state.text = "Show"
            container.addArrangedSubview(showButton)

            container.alignment = .leading
        }
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
            notification.tokenSet.replaceAllOverrides(with: notificationOverrideTokens)
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
            .imageColor: .dynamicColor {
                return DynamicColor(light: GlobalTokens().sharedColors[.orange][.primary])
            },
            .horizontalSpacing: .float {
                return 5.0
            },
            .shadow: .shadowInfo {
                return ShadowInfo(colorOne: DynamicColor(light: GlobalTokens().sharedColors[.hotPink][.primary]),
                                  blurOne: 10.0,
                                  xOne: 10.0,
                                  yOne: 10.0,
                                  colorTwo: DynamicColor(light: GlobalTokens().sharedColors[.teal][.primary]),
                                  blurTwo: 100.0,
                                  xTwo: -10.0,
                                  yTwo: -10.0)
            }
        ]
    }
}
