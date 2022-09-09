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
}

/// View that represents the Divider.
public struct FluentDivider: View, TokenizedControlView {
    public typealias TokenSetKeyType = DividerTokenSet.Tokens
    @ObservedObject public var tokenSet: DividerTokenSet

    /// Creates and initializes a SwiftUI Divider
    /// - Parameters:
    ///   - orientation: The DividerOrientation used by the Divider.
    ///   - spacing: The DividerSpacing used by the Divider.
    public init (orientation: MSFDividerOrientation = .horizontal,
                 spacing: MSFDividerSpacing = .none) {
        let state = MSFDividerStateImpl(orientation: orientation, spacing: spacing)

        self.state = state
        self.tokenSet = DividerTokenSet(spacing: { state.spacing })
    }

    public var body: some View {
        let isHorizontal = state.orientation == .horizontal
        let color = Color(dynamicColor: tokenSet[.color].dynamicColor)
        let padding = tokenSet[.padding].float

        return Rectangle()
            .fill(color)
            .frame(width: isHorizontal ? nil : state.thickness,
                   height: isHorizontal ? state.thickness : nil)
            .padding(isHorizontal ?
                     EdgeInsets(top: padding,
                                leading: 0,
                                bottom: padding,
                                trailing: 0)
                     : EdgeInsets(top: 0,
                                  leading: padding,
                                  bottom: 0,
                                  trailing: padding))
            .fluentTokens(tokenSet, fluentTheme)
    }

    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFDividerStateImpl
}

/// Properties available to customize the Divider.

class MSFDividerStateImpl: ControlState, MSFDividerState {
    @Published var orientation: MSFDividerOrientation

    @Published var spacing: MSFDividerSpacing

    let thickness: CGFloat = DividerTokenSet.thickness

    init(orientation: MSFDividerOrientation,
         spacing: MSFDividerSpacing) {
        self.orientation = orientation
        self.spacing = spacing

        super.init()
    }
}
