//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

@objc public enum MSFDividerOrientation: Int {
    case horizontal
    case vertical
}

/// Properties that can be used to customize the appearance of the Divider.
@objc public protocol MSFDividerConfiguration {
    /// Defines the orientation of the Divider.
    var orientation: MSFDividerOrientation { get set }

    /// Defines the spacing of the Divider.
    var spacing: MSFDividerSpacing { get set }

    /// Defines the thickness of the Divider.
    var thickness: CGFloat { get }

    /// Custom design token set for this control
    var overrideTokens: DividerTokens? { get set }
}

/// View that represents the Divider.
public struct FluentDivider: View, ConfigurableTokenizedControl {

    /// Creates and initializes a SwiftUI Divider
    /// - Parameters:
    ///   - orientation: The DividerOrientation used by the Divider.
    ///   - spacing: The DividerSpacing used by the Divider.
    public init (orientation: MSFDividerOrientation = .horizontal,
                 spacing: MSFDividerSpacing = .none) {
        let configuration = MSFDividerConfigurationImpl(orientation: orientation, spacing: spacing)

        self.configuration = configuration
    }

    public var body: some View {
        let isHorizontal = configuration.orientation == .horizontal
        let color = Color(dynamicColor: tokens.color)

        return Rectangle()
            .fill(color)
            .frame(width: isHorizontal ? nil : configuration.thickness,
                   height: isHorizontal ? configuration.thickness : nil)
            .padding(isHorizontal ?
                     EdgeInsets(top: tokens.padding,
                                leading: 0,
                                bottom: tokens.padding,
                                trailing: 0)
                     : EdgeInsets(top: 0,
                                  leading: tokens.padding,
                                  bottom: 0,
                                  trailing: tokens.padding))
    }

    let defaultTokens: DividerTokens = .init()
    var tokens: DividerTokens {
        let tokens = resolvedTokens
        tokens.spacing = configuration.spacing
        return tokens
    }
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var configuration: MSFDividerConfigurationImpl
}

/// Properties available to customize the Divider.
class MSFDividerConfigurationImpl: NSObject, ObservableObject, ControlConfiguration, MSFDividerConfiguration {
    @Published var overrideTokens: DividerTokens?

    @Published var orientation: MSFDividerOrientation

    @Published var spacing: MSFDividerSpacing

    let thickness: CGFloat = UIScreen.main.devicePixel

    init(orientation: MSFDividerOrientation,
         spacing: MSFDividerSpacing) {
        self.orientation = orientation
        self.spacing = spacing

        super.init()
    }
}
