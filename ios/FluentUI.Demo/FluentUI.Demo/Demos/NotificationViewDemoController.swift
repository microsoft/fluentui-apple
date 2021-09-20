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
        var view = NotificationView()
        switch variant {
        case .primaryToast:
            view = NotificationView.init(style: .primaryToast, message: "Mail Archived", actionTitle: "Undo", action: { [unowned self] in self.showMessage("`Undo` tapped") })
            view.setup()
        case .primaryToastWithImageAndTitle:
            view = NotificationView.init(style: .primaryToast, title: "Kat's iPhoneX", message: "Listen to Emails • 7 mins", image: UIImage(named: "play-in-circle-24x24"), action: { [unowned self] in self.showMessage("`Dismiss` tapped") }, messageAction: { [unowned self] in self.showMessage("`Listen to emails` tapped") })
            view.setup()
        case .neutralToast:
            view = NotificationView.init(style: .neutralToast, message: "Some items require you to sign in to view them", actionTitle: "Sign in", action: { [unowned self] in self.showMessage("`Sign in` tapped") })
            view.setup()
        case .dangerToast:
            view = NotificationView.init(style: .dangerToast, message: "There was a problem, and your recent changes may not have saved", actionTitle: "Retry", action: { [unowned self] in self.showMessage("`Retry` tapped") })
            view.setup()
        case .warningToast:
            view = NotificationView.init(style: .warningToast, message: "Read Only", action: { [unowned self] in self.showMessage("`Dismiss` tapped") })
            view.setup()
        case .primaryBar:
            view = NotificationView.init(style: .primaryBar, message: "Updating...")
            view.setup()
        case .primaryOutlineBar:
            view = NotificationView.init(style: .primaryOutlineBar, message: "Mail Sent")
            view.setup()
        case .neutralBar:
            view = NotificationView.init(style: .neutralBar, message: "No internet connection")
            view.setup()
        case .persistentBarWithAction:
            view = NotificationView.init(style: .neutralBar, message: "This error can be taken action on with the action on the right.", actionTitle: "Action", action: { [unowned self] in self.showMessage("`Action` tapped") })
            view.setup()
        case .persistentBarWithCancel:
            view = NotificationView.init(style: .neutralBar, message: "This error can be tapped or dismissed with the icon to the right.", action: { [unowned self] in self.showMessage("`Dismiss` tapped") }, messageAction: { [unowned self] in self.showMessage("`Dismiss` tapped") })
            view.setup()
        }
        return view
    }
}
