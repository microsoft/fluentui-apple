//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

public struct CommandBarButtonAppearance {
    public var tintColor: UIColor
    public var backgroundColor: UIColor

    public init(
        tintColor: UIColor = Defaults.tintColor,
        backgroundColor: UIColor = Defaults.backgroundColor
    ) {
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
    }

    public enum Defaults {
        public static let tintColor: UIColor = Colors.gray400
        public static let backgroundColor: UIColor = Colors.surfaceSecondary
    }
}

public struct CommandBarAppearance {
    public var buttonSpacing: CGFloat
    public var insets: UIEdgeInsets
    public var contentHeight: CGFloat?
    public var buttonAppearance: CommandBarButtonAppearance

    public init(
        buttonSpacing: CGFloat = Defaults.buttonSpacing,
        insets: UIEdgeInsets = Defaults.insets,
        contentHeight: CGFloat? = Defaults.contentHeight,
        buttonAppearance: CommandBarButtonAppearance = CommandBarButtonAppearance()
    ) {
        self.buttonSpacing = buttonSpacing
        self.insets = insets
        self.contentHeight = contentHeight
        self.buttonAppearance = buttonAppearance
    }

    public enum Defaults {
        public static let buttonSpacing: CGFloat = 10.0
        public static let insets = UIEdgeInsets(top: 9.0, left: 10.0, bottom: 9.0, right: 10.0)
        public static let contentHeight: CGFloat = 36.0
    }
}
