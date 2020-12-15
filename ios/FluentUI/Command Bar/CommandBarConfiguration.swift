//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public struct CommandBarAppearance {
    public var buttonSpacing: CGFloat
    public var insets: UIEdgeInsets
    public var contentHeight: CGFloat?
    public var isHeightConstrainedToToolbarHeight: Bool

    public init(
        buttonSpacing: CGFloat = Defaults.buttonSpacing,
        insets: UIEdgeInsets = Defaults.insets,
        contentHeight: CGFloat? = Defaults.contentHeight,
        isHeightConstrainedToToolbarHeight: Bool = Defaults.isHeightConstrainedToToolbarHeight
    ) {
        self.buttonSpacing = buttonSpacing
        self.insets = insets
        self.contentHeight = contentHeight
        self.isHeightConstrainedToToolbarHeight = isHeightConstrainedToToolbarHeight
    }

    public enum Defaults {
        public static let buttonSpacing: CGFloat = 10.0
        public static let insets = UIEdgeInsets(top: 9.0, left: 10.0, bottom: 9.0, right: 10.0)
        public static let contentHeight: CGFloat = 36.0
        public static let isHeightConstrainedToToolbarHeight: Bool = false
    }
}

public struct CommandBarButtonAppearance {
    public var tintColor: UIColor
    public var backgroundColor: UIColor
    public var highlightedTintColor: UIColor
    public var highlightedBackgroundColor: UIColor
    public var brightBackgroundColor: UIColor

    public init(
        tintColor: UIColor = Defaults.tintColor,
        backgroundColor: UIColor = Defaults.backgroundColor,
        highlightedTintColor: UIColor = Defaults.highlightedTintColor,
        highlightedBackgroundColor: UIColor = Defaults.highlightedBackgroundColor,
        brightBackgroundColor: UIColor = Defaults.brightBackgroundColor
    ) {
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        self.highlightedTintColor = highlightedTintColor
        self.highlightedBackgroundColor = highlightedBackgroundColor
        self.brightBackgroundColor = brightBackgroundColor
    }

    public enum Defaults {
        public static let tintColor: UIColor = Colors.gray400
        public static let backgroundColor: UIColor = Colors.surfaceSecondary
        public static let highlightedTintColor = UIColor(light: Colors.communicationBlue, dark: .black)
        public static let highlightedBackgroundColor = UIColor(light: UIColor(red: 224 / 255, green: 238 / 255, blue: 249 / 255, alpha: 1), dark: Colors.communicationBlue)
        public static let brightBackgroundColor = UIColor(light: .white, dark: Colors.gray800)
    }
}

public struct CommandBarItem {
    public var iconImage: UIImage?
    public var accessibilityLabel: String?

    public init(iconImage: UIImage?, accessbilityLabel: String?) {
        self.iconImage = iconImage
        self.accessibilityLabel = accessbilityLabel
    }
}
