//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Pre-defined sizes of the persona grid item
@objc public enum MSFPersonaGridSize: Int, CaseIterable {
    case small
    case large

    var avatarSize: MSFAvatarSize {
        switch self {
        case .large:
            return .xxlarge
        case .small:
            return .xlarge
        }
    }

    var canShowSubtitle: Bool {
        switch self {
        case .large:
            return true
        case .small:
            return false
        }
    }
}

/// Representation of design tokens to persona grid items at runtime which interfaces with the Design Token System auto-generated code.
/// Updating these properties causes the SwiftUI button to update its view automatically.
class MSFPersonaGridItemTokens: MSFTokensBase, ObservableObject {
    @Published public var avatarInterspace: CGFloat!
    @Published public var backgroundColor: UIColor!
    @Published public var labelColor: UIColor!
    @Published public var labelFont: UIFont!
    @Published public var padding: CGFloat!
    @Published public var sublabelColor: UIColor!
    @Published public var sublabelFont: UIFont!

    var size: MSFPersonaGridSize {
        didSet {
            if oldValue != size {
                updateForCurrentTheme()
            }
        }
    }

    init(size: MSFPersonaGridSize) {
        self.size = size

        super.init()

        self.themeAware = true

        updateForCurrentTheme()
    }

    @objc open func didChangeAppearanceProxy() {
        updateForCurrentTheme()
    }

    override func updateForCurrentTheme() {
        let currentTheme = theme
        let appearanceProxy = currentTheme.MSFPersonaGridItemTokens

        backgroundColor = appearanceProxy.backgroundColor
        labelColor = appearanceProxy.labelColor
        padding = appearanceProxy.padding
        sublabelColor = appearanceProxy.sublabelColor
        sublabelFont = appearanceProxy.sublabelFont

        switch size {
        case .small:
            avatarInterspace = appearanceProxy.avatarInterspace.small
            labelFont = appearanceProxy.labelFont.small
        case .large:
            avatarInterspace = appearanceProxy.avatarInterspace.large
            labelFont = appearanceProxy.labelFont.large
        }
    }
}
