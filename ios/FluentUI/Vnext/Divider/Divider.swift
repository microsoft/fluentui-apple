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
    /// Sets a custom color for the Divider.
    var color: UIColor? { get set }

    /// Defines the orientation of the Divider.
    var orientation: MSFDividerOrientation { get set }

    /// Defines the spacing of the Divider.
    var spacing: MSFDividerSpacing { get set }

    /// Defines the thickness of the Divider.
    var thickness: CGFloat { get }
}

/// View that represents the Divider.
public struct FluentDivider: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var state: MSFDividerStateImpl
    @ObservedObject var tokens: MSFDividerTokens

    /// Creates and initializes a SwiftUI Divider
    /// - Parameters:
    ///   - orientation: The DividerOrientation used by the Divider.
    ///   - spacing: The DividerSpacing used by the Divider.
    public init (orientation: MSFDividerOrientation = .horizontal,
                 spacing: MSFDividerSpacing = .none) {
        let state = MSFDividerStateImpl(orientation: orientation, spacing: spacing)

        self.state = state
        self.tokens = state.tokens
    }

    public var body: some View {
        let isHorizontal = state.orientation == .horizontal

        return Rectangle()
            .fill(Color(state.color ?? tokens.color))
            .frame(minWidth: state.thickness,
                   maxWidth: isHorizontal ? .infinity : state.thickness,
                   minHeight: state.thickness,
                   maxHeight: isHorizontal ? state.thickness : .infinity)
            .padding(isHorizontal ?
                     EdgeInsets(top: tokens.padding,
                                leading: 0,
                                bottom: tokens.padding,
                                trailing: 0)
                     : EdgeInsets(top: 0,
                                  leading: tokens.padding,
                                  bottom: 0,
                                  trailing: tokens.padding))
            .designTokens(tokens,
                          from: theme,
                          with: windowProvider)
    }
}

/// Properties available to customize the Divider.
class MSFDividerStateImpl: NSObject, ObservableObject, MSFDividerState {
    @Published var color: UIColor?
    @Published var orientation: MSFDividerOrientation

    var spacing: MSFDividerSpacing {
        get {
            return tokens.spacing
        }
        set {
            tokens.spacing = newValue
        }
    }

    let thickness: CGFloat = UIScreen.main.devicePixel

    var tokens: MSFDividerTokens

    init(orientation: MSFDividerOrientation,
         spacing: MSFDividerSpacing) {
        self.orientation = orientation
        tokens = MSFDividerTokens(spacing: spacing)
        super.init()
    }
}
