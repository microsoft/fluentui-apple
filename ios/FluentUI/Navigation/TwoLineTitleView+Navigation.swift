//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: NavigationBarTitleAccessory enum extensions

extension NavigationBarTitleAccessory: TwoLineTitleViewDelegate {
    public func twoLineTitleViewDidTapOnTitle(_ twoLineTitleView: TwoLineTitleView) {
        guard let delegate = delegate,
              let navigationBar = twoLineTitleView.findSuperview(of: NavigationBar.self) as? NavigationBar else {
            return
        }
        delegate.navigationBarDidTapOnTitle(navigationBar)
    }
}

fileprivate extension NavigationBarTitleAccessory.Location {
    var twoLineTitleViewInteractivePart: TwoLineTitleView.InteractivePart {
        switch self {
        case .title:
            return .title
        case .subtitle:
            return .subtitle
        }
    }
}

fileprivate extension NavigationBarTitleAccessory.Style {
    var twoLineTitleViewAccessoryType: TwoLineTitleView.AccessoryType {
        switch self {
        case .downArrow:
            return .downArrow
        case .disclosure:
            return .disclosure
        case .custom:
            return .custom
        }
    }
}

extension TwoLineTitleView {
    @objc open func setup(navigationItem: UINavigationItem) {
        let title = navigationItem.title ?? ""
        let alignment: Alignment = navigationItem.titleStyle == .system ? .center : .leading

        let interactivePart: InteractivePart
        let accessoryType: AccessoryType
        let animatesWhenPressed: Bool
        if let titleAccessory = navigationItem.titleAccessory {
            // Use the custom action provided by the title accessory specification
            interactivePart = titleAccessory.location.twoLineTitleViewInteractivePart
            accessoryType = titleAccessory.style.twoLineTitleViewAccessoryType
            animatesWhenPressed = true
            delegate = titleAccessory
        } else {
            // Use the default behavior of requesting expansion of the hosting navigation bar
            interactivePart = .all
            accessoryType = .none
            animatesWhenPressed = false
        }

        setup(title: title, titleImage: navigationItem.titleImage, subtitle: navigationItem.subtitle, alignment: alignment, interactivePart: interactivePart, animatesWhenPressed: animatesWhenPressed, accessoryType: accessoryType, customSubtitleTrailingImage: navigationItem.customSubtitleTrailingImage, isTitleImageLeadingForTitleAndSubtitle: navigationItem.isTitleImageLeadingForTitleAndSubtitle)
    }
}
