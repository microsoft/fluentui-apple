//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Configuration struct to populate the `MessageBarView` structure.
public struct MessageBarConfiguration {

    /// Configuration struct to describe the action buttons in a `MessageBarView`.
    public struct ActionButtonConfiguration {
        
        /// Creates an `ActionButtonConfiguration` with one action button.
        /// - Parameters:
        ///   - actionButton1Title: The title for the sole action button in the `MessageBarView`.
        ///   - callback: Handler for when the action button is activated.
        public init(actionButton1Title: String,
                    callback: @escaping ((UInt8) -> Void)) {
            self.actionButton1Title = actionButton1Title
            self.actionButton2Title = nil
            self.actionButton3Title = nil
            self.callback = callback
        }

        /// Creates an `ActionButtonConfiguration` with two action buttons.
        /// - Parameters:
        ///   - actionButton1Title: The title for the first action button in the `MessageBarView`.
        ///   - actionButton2Title: The title for the second action button in the `MessageBarView`.
        ///   - callback: Handler for when an action button is activated.
        public init(actionButton1Title: String,
                    actionButton2Title: String,
                    callback: @escaping ((UInt8) -> Void)) {
            self.actionButton1Title = actionButton1Title
            self.actionButton2Title = actionButton2Title
            self.actionButton3Title = nil
            self.callback = callback
        }

        /// Creates an `ActionButtonConfiguration` with three action buttons.
        /// - Parameters:
        ///   - actionButton1Title: The title for the first action button in the `MessageBarView`.
        ///   - actionButton2Title: The title for the second action button in the `MessageBarView`.
        ///   - actionButton3Title: The title for the third action button in the `MessageBarView`.
        ///   - callback: Handler for when an action button is activated.
        public init(actionButton1Title: String,
                    actionButton2Title: String,
                    actionButton3Title: String,
                    callback: @escaping ((UInt8) -> Void)) {
            self.actionButton1Title = actionButton1Title
            self.actionButton2Title = actionButton2Title
            self.actionButton3Title = actionButton3Title
            self.callback = callback
        }

        var actionButtons: [String] {
            var actionButtons: [String] = []
            if let actionButton1Title {
                actionButtons.append(actionButton1Title)
                if let actionButton2Title {
                    actionButtons.append(actionButton2Title)
                    if let actionButton3Title {
                        actionButtons.append(actionButton3Title)
                    }
                }
            }
            return actionButtons
        }

        let callback: ((UInt8) -> Void)?

        private let actionButton1Title: String?
        private let actionButton2Title: String?
        private let actionButton3Title: String?
    }
    
    /// Creates a `MessageBarConfiguration` to describe the `MessageBarView`.
    /// - Parameters:
    ///   - title: The primary title of the message bar.
    ///   - message: Additional information to be portrayed in the message bar.
    ///   - actionButtonConfiguration: Describes the action buttons in the message bar. Optional.
    public init(title: String,
                message: String,
                actionButtonConfiguration: ActionButtonConfiguration? = nil,
                hasCloseButton: Bool,
                onCloseCallback: @escaping () -> Void) {
        self.title = title
        self.message = message
        self.actionButtonConfiguration = actionButtonConfiguration
        self.onCloseCallback = onCloseCallback
    }

    let title: String
    let message: String
    let actionButtonConfiguration: ActionButtonConfiguration?
    let hasCloseButton: Bool

    let onCloseCallback: () -> Void
}

/// A horizontal `MessageBar`.
public struct MessageBar: View, TokenizedControlView {
    public typealias TokenSetKeyType = MessageBarTokenSet.Tokens
    @ObservedObject public var tokenSet: MessageBarTokenSet = .init()

    public init(_ configuration: MessageBarConfiguration) {
        self.configuration = configuration
    }

    public var body: some View {
        HStack(alignment: .center, spacing: GlobalTokens.spacing(.size80)) {

            leadingImage
            title
            message

            Spacer(minLength: 0.0)

            actionButtons
            closeButton
        }
        .foregroundStyle(fluentTheme.swiftUIColor(.foreground1))
        .padding([.horizontal], GlobalTokens.spacing(.size120))
        .frame(height: GlobalTokens.spacing(.size280))
        .background(tokenSet[.backgroundColor].color)
    }

    @ViewBuilder
    private var leadingImage: some View {
        Image(systemName: "exclamationmark.triangle")
    }

    @ViewBuilder
    private var title: Text {
        Text(configuration.title)
            .font(tokenSet[.titleFont].font)
    }

    @ViewBuilder
    private var message: Text {
        Text(configuration.message)
            .font(tokenSet[.messageFont].font)
    }

    @ViewBuilder
    private var actionButtons: (some View)? {
        let actionButtonConfiguration = configuration.actionButtonConfiguration
        if let actionButtons = actionButtonConfiguration?.actionButtons {
            ForEach(actionButtons.indices, id: \.self) { buttonIndex in
                SwiftUI.Button(actionButtons[buttonIndex]) {
                    actionButtonConfiguration?.callback?(UInt8(buttonIndex))
                }
                    .controlSize(.small)
            }
        }
    }

    @ViewBuilder
    private var closeButton: some View {
        SwiftUI.Button("Close", systemImage: "xmark.circle.fill") {
            configuration.onCloseCallback()
        }
            .buttonStyle(.plain)
            .labelStyle(.iconOnly)
    }

    @Environment(\.fluentTheme) private var fluentTheme: FluentTheme
    private let configuration: MessageBarConfiguration
}

#Preview {
    let actionButtonConfiguration = MessageBarConfiguration.ActionButtonConfiguration(
        actionButton1Title: "Label1",
        actionButton2Title: "Label2",
        actionButton3Title: "Label3") { buttonIndex in
            print("Pressed button \(buttonIndex)")
        }
    let messageBarConfiguration = MessageBarConfiguration(
        title: "Descriptive Title",
        message: "Message providing information to the user with actionable insights.",
        actionButtonConfiguration: actionButtonConfiguration,
        onCloseCallback: {
            print("Closing the message bar")
        }
    )

    MessageBar(messageBarConfiguration)
}
