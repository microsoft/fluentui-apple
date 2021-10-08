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

            }
        }

        var delayForHiding: TimeInterval {
            switch self {
            case .primaryToast, .primaryBar, .primaryOutlineBar, .neutralBar:
                return 2
            default:
                return .infinity
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.surfaceSecondary

        container.addArrangedSubview(createButton(title: "SwiftUI Demo", action: { [weak self] _ in
            self?.navigationController?.pushViewController(NotificationViewDemoControllerSwiftUI(),
                                                           animated: true)
        }).view)

        for (index, variant) in Variant.allCases.enumerated() {
            if index > 0 {
                // spacers
                container.addArrangedSubview(UIView())
                container.addArrangedSubview(UIView())
            }
            addTitle(text: variant.displayText)
            container.addArrangedSubview(createNotificationView(forVariant: variant))

            let showButton = MSFButton(style: .secondary, size: .small, action: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }

                strongSelf.createNotificationView(forVariant: variant).show(in: strongSelf.view) {
                    $0.hide(after: variant.delayForHiding)
                }
            })
            showButton.state.text = "Show"
            container.addArrangedSubview(showButton.view)

            container.alignment = .leading
        }
    }

    private func createNotificationView(forVariant variant: Variant) -> NotificationView {
        let view = NotificationView()
        switch variant {
        case .primaryToast:
            view.setup(style: .primaryToast,
                              message: "Mail Archived",
                              actionTitle: "Undo",
                              action: { [weak self] in self?.showMessage("`Undo` tapped") })
        case .primaryToastWithImageAndTitle:
            view.setup(style: .primaryToast,
                              title: "Kat's iPhoneX",
                              message: "Listen to Emails • 7 mins",
                              image: UIImage(named: "play-in-circle-24x24"),
                              action: { [weak self] in self?.showMessage("`Dismiss` tapped") },
                              messageAction: { [weak self] in self?.showMessage("`Listen to emails` tapped") })
        case .neutralToast:
            view.setup(style: .neutralToast,
                              message: "Some items require you to sign in to view them",
                              actionTitle: "Sign in",
                              action: { [weak self] in self?.showMessage("`Sign in` tapped") })
        case .dangerToast:
            view.setup(style: .dangerToast,
                              message: "There was a problem, and your recent changes may not have saved",
                              actionTitle: "Retry",
                              action: { [weak self] in self?.showMessage("`Retry` tapped") })
        case .warningToast:
            view.setup(style: .warningToast,
                              message: "Read Only",
                              action: { [weak self] in self?.showMessage("`Dismiss` tapped") })
        case .primaryBar:
            view.setup(style: .primaryBar,
                              message: "Updating...")
        case .primaryOutlineBar:
            view.setup(style: .primaryOutlineBar,
                              message: "Mail Sent")
        case .neutralBar:
            view.setup(style: .neutralBar,
                              message: "No internet connection")
        case .persistentBarWithAction:
            view.setup(style: .neutralBar,
                              message: "This error can be taken action on with the action on the right.",
                              actionTitle: "Action",
                              action: { [weak self] in self?.showMessage("`Action` tapped") })
        case .persistentBarWithCancel:
            view.setup(style: .neutralBar,
                              message: "This error can be tapped or dismissed with the icon to the right.",
                              action: { [weak self] in self?.showMessage("`Dismiss` tapped") },
                              messageAction: { [weak self] in self?.showMessage("`Dismiss` tapped") })
        }
        return view
    }
}
