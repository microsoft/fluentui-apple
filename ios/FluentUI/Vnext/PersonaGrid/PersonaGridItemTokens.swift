//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

/// Pre-defined sizes of the avatar
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

/// Representation of design tokens to buttons at runtime which interfaces with the Design Token System auto-generated code.
/// Updating these properties causes the SwiftUI button to update its view automatically.
class MSFPersonaGridItemTokens: MSFTokensBase, ObservableObject {
    @Published public var avatarInterspace: CGFloat!
    @Published public var backgroundColor: UIColor!
    @Published public var bottomPadding: CGFloat!
    @Published public var labelColor: UIColor!
    @Published public var labelFont: UIFont!
    @Published public var sublabelColor: UIColor!
    @Published public var sublabelFont: UIFont!
    @Published public var topPadding: CGFloat!

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
        bottomPadding = appearanceProxy.bottomPadding
        labelColor = appearanceProxy.labelColor
        sublabelColor = appearanceProxy.sublabelColor
        sublabelFont = appearanceProxy.sublabelFont
        topPadding = appearanceProxy.topPadding

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
