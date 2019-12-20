//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class MSNotificationViewDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MSColors.background2

        addTitle(text: "Primary Toast")
        container.addArrangedSubview(createNotificationView(style: .primaryToast, message: "Mail Archived", actionTitle: "Undo", action: { [unowned self] in self.showMessage("`Undo` tapped") }))
        addTitle(text: "Primary Toast with image and title")
        container.addArrangedSubview(createNotificationView(style: .primaryToast, title: "Kat's iPhoneX", message: "Listen to Emails • 7 mins", image: UIImage(named: "play-in-circle-24x24"), messageAction: { [unowned self] in self.showMessage("`Listen to emails` tapped") }))
        addTitle(text: "Neutral Toast")
        container.addArrangedSubview(createNotificationView(style: .neutralToast, message: "Some items require you to sign in to view them", actionTitle: "Sign in", action: { [unowned self] in self.showMessage("`Sign in` tapped") }))
        addTitle(text: "Primary Bar")
        container.addArrangedSubview(createNotificationView(style: .primaryBar, message: "Updating..."))
        addTitle(text: "Neutral Bar")
        container.addArrangedSubview(createNotificationView(style: .neutralBar, message: "No internet connection"))
    }

    private func createNotificationView(style: MSNotificationView.Style, title: String = "", message: String, image: UIImage? = nil, actionTitle: String = "", action: (() -> Void)? = nil, messageAction: (() -> Void)? = nil) -> MSNotificationView {
        let view = MSNotificationView()
        view.setup(style: style, title: title, message: message, image: image, actionTitle: actionTitle, action: action ?? { [unowned self] in self.showMessage("`Dismiss` tapped") }, messageAction: messageAction)
        return view
    }
}
