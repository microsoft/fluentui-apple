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

/// UIKit wrapper that exposes the SwiftUI Divider implementation.
@objc open class MSFDivider: NSObject, FluentUIWindowProvider {

    /// The UIView representing the Fluent Divider.
    @objc open var view: UIView {
        return hostingController.view
    }

    /// The object that groups properties that allow control over the Divider appearance.
    @objc open var state: MSFDividerState {
        return divider.state
    }

    /// Creates a new MSFDivider instance.
    ///  - Parameters:
    ///   - style: The DividerStyle value used by the Divider.
    ///   - orientation: The DividerOrientation used by the Divider.
    ///   - spacing: The DividerSpacing used by the Divider.
    @objc public init(style: MSFDividerStyle = .default, orientation: MSFDividerOrientation = .horizontal, spacing: MSFDividerSpacing = .none) {
        super.init()

        divider = FluentDivider(style: style, orientation: orientation, spacing: spacing)
        hostingController = FluentUIHostingController(rootView: AnyView(divider.windowProvider(self)))
    }

    var window: UIWindow? {
        return self.window
    }

    private var hostingController: FluentUIHostingController!

    private var divider: FluentDivider!
}

/// Properties that can be used to customize the appearance of the Divider.
@objc public protocol MSFDividerState {
    /// Sets a custom color for the Divider.
    var color: UIColor? {get set}

    /// Defines the orientation of the Divider.
    var orientation: MSFDividerOrientation {get set}

    /// Defines the style of the Divider.
    var style: MSFDividerStyle {get set}

    /// Defines the spacing of the Divider.
    var spacing: MSFDividerSpacing {get set}
}

/// View that represents the Divider.
public struct FluentDivider: View {
    @Environment(\.theme) var theme: FluentUIStyle
    @Environment(\.windowProvider) var windowProvider: FluentUIWindowProvider?
    @ObservedObject var state: MSFDividerStateImpl
    @ObservedObject var tokens: MSFDividerTokens

    /// Creates and initializes a SwiftUI Divider
    /// - Parameters:
    ///   - style: The DividerStyle value used by the Divider.
    ///   - orientation: The DividerOrientation used by the Divider.
    ///   - spacing: The DividerSpacing used by the Divider.
    public init (style: MSFDividerStyle = .default, orientation: MSFDividerOrientation = .horizontal, spacing: MSFDividerSpacing = .none) {
        let state = MSFDividerStateImpl(style: style, orientation: orientation, spacing: spacing)

        self.state = state
        self.tokens = state.tokens
    }

    public var body: some View {
        @ViewBuilder
        var dividerBackground: some View {
            Rectangle()
                .fill(Color(state.color ?? tokens.color))
        }

        @ViewBuilder
        var divider: some View {
            switch state.orientation {
            case .horizontal:
                dividerBackground.frame(height: thickness)
                    .padding(EdgeInsets(top: tokens.padding, leading: 0, bottom: tokens.padding, trailing: 0))
            case .vertical:
                dividerBackground.frame(width: thickness)
                    .padding(EdgeInsets(top: 0, leading: tokens.padding, bottom: 0, trailing: tokens.padding))
            }
        }

        return divider
    }

    private let thickness: CGFloat = UIScreen.main.devicePixel
}

/// Properties available to customize the Divider.
class MSFDividerStateImpl: NSObject, ObservableObject, MSFDividerState {
    @Published var color: UIColor?
    @Published var orientation: MSFDividerOrientation

    var style: MSFDividerStyle {
        get {
            return tokens.style
        }
        set {
            tokens.style = newValue
        }
    }

    var spacing: MSFDividerSpacing {
        get {
            return tokens.spacing
        }
        set {
            tokens.spacing = newValue
        }
    }

    var tokens: MSFDividerTokens

    init(style: MSFDividerStyle, orientation: MSFDividerOrientation, spacing: MSFDividerSpacing) {
        self.orientation = orientation
        tokens = MSFDividerTokens(style: style, spacing: spacing)
        super.init()
    }
}
