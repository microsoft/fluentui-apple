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
@objc public protocol MSFDividerState {
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
public struct FluentDivider: View, TokenizedControlInternal {

    /// Creates and initializes a SwiftUI Divider
    /// - Parameters:
    ///   - orientation: The DividerOrientation used by the Divider.
    ///   - spacing: The DividerSpacing used by the Divider.
    public init (orientation: MSFDividerOrientation = .horizontal,
                 spacing: MSFDividerSpacing = .none) {
        let state = MSFDividerStateImpl(orientation: orientation, spacing: spacing)

        self.state = state
    }

    public var body: some View {
        let isHorizontal = state.orientation == .horizontal
        let color = Color(dynamicColor: tokens.color)

        return Rectangle()
            .fill(color)
            .frame(width: isHorizontal ? nil : state.thickness,
                   height: isHorizontal ? state.thickness : nil)
            .padding(isHorizontal ?
                     EdgeInsets(top: tokens.padding,
                                leading: 0,
                                bottom: tokens.padding,
                                trailing: 0)
                     : EdgeInsets(top: 0,
                                  leading: tokens.padding,
                                  bottom: 0,
                                  trailing: tokens.padding))
            .resolveTokens(self)
    }

    var tokens: DividerTokens { state.tokens }
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFDividerStateImpl
}

/// Properties available to customize the Divider.
class MSFDividerStateImpl: NSObject, ObservableObject, ControlConfiguration, MSFDividerState {
    @Published var overrideTokens: DividerTokens?
    @Published var tokens: DividerTokens {
        didSet {
            tokens.spacing = spacing
        }
    }

    @Published var orientation: MSFDividerOrientation

    @Published var spacing: MSFDividerSpacing {
        didSet {
            tokens.spacing = spacing
        }
    }

    let thickness: CGFloat = UIScreen.main.devicePixel

    init(orientation: MSFDividerOrientation,
         spacing: MSFDividerSpacing) {
        self.orientation = orientation
        self.spacing = spacing

        let tokens = DividerTokens()
        tokens.spacing = spacing
        self.tokens = tokens

        super.init()
    }
}
