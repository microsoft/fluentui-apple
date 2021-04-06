//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

@objc public protocol PersonaCellProtocol {
    @objc var persona: MSFAvatar? { get set }
    @objc var titleTrailingAccessoryView: UIView? { get set }
    @objc var subtitleTrailingAccessoryView: UIView? { get set }
    @objc var onTapAction: (() -> Void)? { get set }
}

@objc public class MSFPersonaCellState: MSFListCellState, PersonaCellProtocol {
    @objc @Published public var persona: MSFAvatar?
}

struct PersonaView: View {
    @ObservedObject var state: MSFPersonaCellState
    @ObservedObject var tokens: MSFListCellTokens

    init(state: MSFPersonaCellState, windowProvider: FluentUIWindowProvider?) {
        self.state = state
        self.tokens = MSFListCellTokens(cellLeadingViewSize: .xlarge, style: .persona)
        self.tokens.windowProvider = windowProvider
    }

    var body: some View {
        MSFListCellView(state: getCellState(), style: .persona, windowProvider: tokens.windowProvider)
    }

    private func getCellState() -> MSFListCellState {
        let cellState = MSFListCellState()
        cellState.leadingView = state.persona?.view ?? nil
        cellState.leadingViewSize = .xlarge
        cellState.title = state.persona?.state.primaryText ?? ""
        cellState.subtitle = state.persona?.state.secondaryText ?? ""
        cellState.titleTrailingAccessoryView = state.titleTrailingAccessoryView
        cellState.subtitleTrailingAccessoryView = state.subtitleTrailingAccessoryView
        cellState.onTapAction = state.onTapAction
        return cellState
    }
}

struct PersonaCellButtonStyle: ButtonStyle {
    let tokens: MSFListCellTokens

    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .contentShape(Rectangle())
            .padding(.leading, tokens.horizontalCellPadding)
            .padding(.trailing, tokens.horizontalCellPadding)
            .frame(minHeight: tokens.cellHeightThreeLines)
            .background(configuration.isPressed ? Color(tokens.highlightedBackgroundColor) : Color(tokens.backgroundColor))
    }
}

/// UIKit wrapper that exposes the SwiftUI Persona Cell implementation
@objc open class MSFPersonaView: NSObject, FluentUIWindowProvider {
    @objc public init(theme: FluentUIStyle? = nil) {
        let state = MSFPersonaCellState()
        personaView = PersonaView(state: state, windowProvider: nil)
        hostingController = UIHostingController(rootView: theme != nil ? AnyView(personaView.usingTheme(theme!)) : AnyView(personaView))

        super.init()

        personaView.tokens.windowProvider = self
        view.backgroundColor = UIColor.clear
    }

    @objc public convenience override init() {
        self.init(theme: nil)
    }

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc open var state: PersonaCellProtocol {
        return personaView.state
    }

    var window: UIWindow? {
        return self.view.window
    }

    private var hostingController: UIHostingController<AnyView>!

    private var personaView: PersonaView!
}
