//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

@objc public protocol PersonaCellProtocol: MSFListCellProtocol {
    @objc var persona: MSFAvatar? { get set }
}

@objc public class MSFPersonaCellState: NSObject, ObservableObject, PersonaCellProtocol {
    @objc @Published public var persona: MSFAvatar?
    @objc @Published public var titleTrailingAccessoryView: UIView?
    @objc @Published public var subtitleTrailingAccessoryView: UIView?
    @objc public var onTapAction: (() -> Void)?
}

struct MSFPersonaCellView: View {
    @ObservedObject var state: MSFPersonaCellState
    @ObservedObject var tokens: MSFListCellTokens

    init(state: MSFPersonaCellState, windowProvider: FluentUIWindowProvider?) {
        self.state = state
        self.tokens = MSFListCellTokens(cellLeadingViewSize: .large, style: .persona)
        self.tokens.windowProvider = windowProvider
    }

    var body: some View {
        Button(action: state.onTapAction ?? { }, label: {
            HStack(spacing: 0) {
                let labelAccessoryInterspace = tokens.labelAccessoryInterspace
                let labelAccessorySize = tokens.labelAccessorySize
                let sublabelAccessorySize = tokens.sublabelAccessorySize

                if let leadingView = state.persona?.view {
                    UIViewAdapter(leadingView)
                        .frame(width: tokens.leadingViewSize, height: tokens.leadingViewSize)
                        .padding(.trailing, tokens.iconInterspace)
                }

                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        if let title = state.persona?.state.primaryText {
                            Text(title)
                                .font(Font(tokens.labelFont))
                                .foregroundColor(Color(tokens.labelColor))
                        }
                        if let titleTrailingAccessoryView = state.titleTrailingAccessoryView {
                            UIViewAdapter(titleTrailingAccessoryView)
                                .frame(width: labelAccessorySize, height: labelAccessorySize)
                                .padding(.leading, labelAccessoryInterspace)
                        }
                    }

                    HStack(spacing: 0) {
                        if let subtitle = state.persona?.state.secondaryText {
                            Text(subtitle)
                                .font(Font(tokens.footnoteFont))
                                .foregroundColor(Color(tokens.sublabelColor))
                        }
                        if let subtitleTrailingAccessoryView = state.subtitleTrailingAccessoryView {
                            UIViewAdapter(subtitleTrailingAccessoryView)
                                .frame(width: sublabelAccessorySize, height: sublabelAccessorySize)
                                .padding(.leading, labelAccessoryInterspace)
                        }
                    }
                }

                Spacer()
            }
        })
        .buttonStyle(PersonaCellButtonStyle(tokens: tokens))
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
@objc open class MSFPersona: NSObject, FluentUIWindowProvider {
    @objc public init(state: MSFPersonaCellState, theme: FluentUIStyle? = nil) {
        let personaView = MSFPersonaCellView(state: state, windowProvider: nil)
        hostingController = UIHostingController(rootView: theme != nil ? AnyView(personaView.usingTheme(theme!)) : AnyView(personaView))

        super.init()

        personaView.tokens.windowProvider = self
        view.backgroundColor = UIColor.clear
    }

    @objc public convenience init(state: MSFPersonaCellState) {
        self.init(state: state, theme: nil)
    }

    @objc open var view: UIView {
        return hostingController.view
    }

    @objc open var state: MSFPersonaCellState {
        return personaView.state
    }

    var window: UIWindow? {
        return self.view.window
    }

    private var hostingController: UIHostingController<AnyView>!

    private var personaView: MSFPersonaCellView!
}
