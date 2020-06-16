//
//  ContactViewDemoController.swift
//  FluentUI.Demo
//
//  Created by Jonathan Wang on 2020-06-12.
//  Copyright © 2020 Microsoft Corporation. All rights reserved.
//

import FluentUI
import UIKit

class ContactViewDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let contactView: ContactView = createContactView()
        contactView.translatesAutoresizingMaskIntoConstraints = false
        contactView.layer.borderWidth = 1.0
        contactView.layer.borderColor = UIColor.red.cgColor
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.green.cgColor
        view.addSubview(contactView)
    }

    private func createContactView() -> ContactView {
        let avatarView = createAvatarView(size: AvatarSize.extraExtraLarge, name: "Jon Wang", image: UIImage(named: "avatar_kat_larsson"), style: .circle)
        let contactView = ContactView(avatarView: avatarView, firstName: "Jon", lastName: "Wang")
        return contactView
    }

    private func createAvatarView(size: AvatarSize, name: String, image: UIImage? = nil, style: AvatarStyle, withColorfulBorder: Bool = false) -> AvatarView {
        let avatarView = AvatarView(avatarSize: size, withBorder: true, style: style)
        if withColorfulBorder, let customBorderImage = colorfulImageForFrame() {
            avatarView.customBorderImage = customBorderImage
        }

        avatarView.setup(primaryText: name, secondaryText: "", image: image)

        // Using AvatarView
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.layer.borderWidth = 1.0
        avatarView.layer.borderColor = UIColor.red.cgColor
        return avatarView
    }

    private func colorfulImageForFrame() -> UIImage? {
        let gradientColors = [
            UIColor(red: 0.45, green: 0.29, blue: 0.79, alpha: 1).cgColor,
            UIColor(red: 0.18, green: 0.45, blue: 0.96, alpha: 1).cgColor,
            UIColor(red: 0.36, green: 0.80, blue: 0.98, alpha: 1).cgColor,
            UIColor(red: 0.45, green: 0.72, blue: 0.22, alpha: 1).cgColor,
            UIColor(red: 0.97, green: 0.78, blue: 0.27, alpha: 1).cgColor,
            UIColor(red: 0.94, green: 0.52, blue: 0.20, alpha: 1).cgColor,
            UIColor(red: 0.92, green: 0.26, blue: 0.16, alpha: 1).cgColor,
            UIColor(red: 0.45, green: 0.29, blue: 0.79, alpha: 1).cgColor]

        let colorfulGradient = CAGradientLayer()
        let size = CGSize(width: 76, height: 76)
        colorfulGradient.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        colorfulGradient.colors = gradientColors
        colorfulGradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        colorfulGradient.endPoint = CGPoint(x: 0.5, y: 0)
        if #available(iOS 12.0, *) {
            colorfulGradient.type = .conic
        }

        var customBorderImage: UIImage?
        UIGraphicsBeginImageContext(size)
        if let context = UIGraphicsGetCurrentContext() {
            colorfulGradient.render(in: context)
            customBorderImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()

        return customBorderImage
    }
}
