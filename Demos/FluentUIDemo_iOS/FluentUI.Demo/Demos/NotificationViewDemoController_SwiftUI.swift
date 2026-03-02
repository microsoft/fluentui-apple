//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI

class NotificationViewDemoControllerSwiftUI: UIHostingController<NotificationDemoView> {
    override init?(coder aDecoder: NSCoder, rootView: NotificationDemoView) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    init() {
        super.init(rootView: NotificationDemoView())
        self.title = "NotificationView (SwiftUI)"
    }

    override func willMove(toParent parent: UIViewController?) {
        guard let parent,
              let window = parent.view.window else {
            return
        }

        rootView.fluentTheme = window.fluentTheme
    }
}

struct NotificationDemoView: View {
    @State var style: MSFNotificationStyle = .primaryToast
    @State var title: String = ""
    @State var message: String = "Mail Archived"
    @State var messageLineLimit: Int = 0
    @State var actionButtonTitle: String = "Undo"
    @State var hasActionButtonAction: Bool = true
    @State var hasBlueStrikethroughAttribute: Bool = false
    @State var hasLargeRedPapyrusFontAttribute: Bool = false
    @State var hasMessageAction: Bool = false
    @State var showImage: Bool = false
    @State var showTrailingImage: Bool = false
    @State var showAlert: Bool = false
    @State var isPresented: Bool = false
    @State var overrideTokens: Bool = false
    @State var isFlexibleWidthToast: Bool = false
    @State var showDefaultDismissActionButton: Bool = true
    @State var showActionButtonAndDismissButton: Bool = false
    @State var swipeToDismissEnabled: Bool = false
    @State var showFromBottom: Bool = true
    @State var showBackgroundGradient: Bool = false
    @State var useCustomTheme: Bool = false
    @State var verticalOffset: CGFloat = 0.0
    @State var previewPresented: Bool = true
    @State var notificationID: UUID = UUID()
    @State var autoReappear: Bool = true
    @ObservedObject var fluentTheme: FluentTheme = .shared
    private var triggerModel = FluentNotificationTriggerModel()
    let customTheme: FluentTheme = {
        let foregroundColor = UIColor(light: GlobalTokens.sharedColor(.lavender, .shade30),
                                      dark: GlobalTokens.sharedColor(.lavender, .tint40))
        let colorOverrides = [
            FluentTheme.ColorToken.brandBackgroundTint: UIColor(light: GlobalTokens.sharedColor(.lavender, .tint40),
                                                                dark: GlobalTokens.sharedColor(.lavender, .shade30)),
            FluentTheme.ColorToken.brandForeground1: foregroundColor,
            FluentTheme.ColorToken.brandForegroundTint: foregroundColor
        ]
        return FluentTheme(colorOverrides: colorOverrides)
    }()
    private let integerFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // Handles thousands separators (e.g., 1,000)
        formatter.allowsFloats = false // Rejects decimals (e.g., "12.3")
        formatter.minimum = 0 // No negative numbers
        return formatter
    }()

    public var body: some View {
        let font = UIFont(descriptor: .init(name: "Papyrus", size: 30.0), size: 30.0)
        let hasAttribute = hasBlueStrikethroughAttribute || hasLargeRedPapyrusFontAttribute

        let bothAttributes = [
            NSAttributedString.Key.strikethroughStyle: 1,
            NSAttributedString.Key.strikethroughColor: UIColor.blue,
            .font: font,
            .foregroundColor: UIColor.red
        ] as [NSAttributedString.Key: Any]

        let blueStrikethroughAttribute = [
            .font: UIFont.preferredFont(forTextStyle: .body),
            NSAttributedString.Key.strikethroughStyle: 1,
            NSAttributedString.Key.strikethroughColor: UIColor.blue
        ] as [NSAttributedString.Key: Any]

        let redPapyrusFontAttribute = [.font: font, .foregroundColor: UIColor.red] as [NSAttributedString.Key: Any]

        let attributedMessage = NSMutableAttributedString(string: message, attributes: (hasLargeRedPapyrusFontAttribute && hasBlueStrikethroughAttribute) ? bothAttributes : (hasLargeRedPapyrusFontAttribute ? redPapyrusFontAttribute : blueStrikethroughAttribute))

        let attributedTitle = NSMutableAttributedString(string: title, attributes: (hasLargeRedPapyrusFontAttribute && hasBlueStrikethroughAttribute) ? bothAttributes : (hasLargeRedPapyrusFontAttribute ? redPapyrusFontAttribute : blueStrikethroughAttribute))

        let image = showImage ? UIImage(named: "play-in-circle-24x24") : nil
        let trailingImage = showTrailingImage ? UIImage(named: "Placeholder_24") : nil
        let trailingImageLabel = showTrailingImage ? "Circle" : nil
        let actionButtonAction = hasActionButtonAction ? { showAlert = true } : nil
        let dismissButtonAction = {
            previewPresented = false
            showAlert = true
        }
        let messageButtonAction = hasMessageAction ? { showAlert = true } : nil
        let hasMessage = !message.isEmpty
        let hasTitle = !title.isEmpty
        let theme = useCustomTheme ? customTheme : fluentTheme

#if DEBUG
        let accessibilityIdentifier: String = {
            var identifier: String = "Notification View with"

            if hasTitle {
                if hasAttribute {
                    identifier += " attributed title \"\(title)\""
                } else {
                    identifier += " title \"\(title)\""
                }
            } else {
                identifier += " no title"
            }

            if hasMessage {
                if hasAttribute {
                    identifier += ", attributed message \"\(message)\""
                } else {
                    identifier += ", message \"\(message)\""
                }
            } else {
                identifier += ", no message"
            }

            if image != nil {
                identifier += ", an image"
            }

            if actionButtonTitle != "" {
                identifier += ", and an action button titled \"\(actionButtonTitle)\""
            } else {
                if trailingImage != nil {
                    identifier += ", and a trailing image"
                } else {
                    identifier += ", and a dismiss button"
                }
            }

            identifier += " in style \(style.rawValue)"

            if !(MSFNotificationStyle.primaryBar.rawValue...MSFNotificationStyle.neutralBar.rawValue ~= style.rawValue) {
                if isFlexibleWidthToast {
                    identifier += " that is flexible in width"
                } else {
                    identifier += " that is not flexible in width"
                }
            }

            return identifier
        }()
 #endif

        VStack {
            if previewPresented {
                Rectangle()
                    .foregroundColor(.clear)
#if DEBUG
                    .accessibilityIdentifier(accessibilityIdentifier)
#endif
                    .presentNotification(isPresented: $previewPresented, isBlocking: false) {
                        FluentNotification(style: style,
                                           isFlexibleWidthToast: $isFlexibleWidthToast.wrappedValue,
                                           message: hasMessage ? message : nil,
                                           attributedMessage: hasAttribute && hasMessage ? attributedMessage : nil,
                                           messageLineLimit: messageLineLimit,
                                           title: hasTitle ? title : nil,
                                           attributedTitle: hasAttribute && hasTitle ? attributedTitle : nil,
                                           image: image,
                                           trailingImage: trailingImage,
                                           trailingImageAccessibilityLabel: trailingImageLabel,
                                           actionButtonTitle: actionButtonTitle,
                                           actionButtonAction: actionButtonAction,
                                           showDefaultDismissActionButton: showDefaultDismissActionButton,
                                           showActionButtonAndDismissButton: showActionButtonAndDismissButton,
                                           defaultDismissButtonAction: dismissButtonAction,
                                           messageButtonAction: messageButtonAction,
                                           swipeToDismissEnabled: swipeToDismissEnabled,
                                           showFromBottom: showFromBottom,
                                           triggerModel: triggerModel)
                        .backgroundGradient(showBackgroundGradient ? backgroundGradient : nil)
                        .overrideTokens($overrideTokens.wrappedValue ? notificationOverrideTokens : nil)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 100, alignment: .center)
                    .alert(isPresented: $showAlert, content: {
                        Alert(title: Text("Button tapped"))
                    })
            }

            Button("Show Notification") {
                if isPresented == false {
                    notificationID = UUID() // Force recreation
                    isPresented = true

                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        isPresented = false
                    }
                }
            }
            .buttonStyle(FluentButtonStyle(style: .accent))
            .fixedSize()
            .padding()

            notificationSettings
        }
        .id(notificationID)
        .onChange(of: previewPresented) { _, isPresented in
            if !isPresented && autoReappear {
                // Wait 2 seconds after dismissal, then show again
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    if autoReappear && !previewPresented {
                        previewPresented = true
                    }
                }
            }
        }
        .presentNotification(isPresented: $isPresented, isBlocking: false) {
            FluentNotification(style: style,
                               isFlexibleWidthToast: $isFlexibleWidthToast.wrappedValue,
                               message: hasMessage ? message : nil,
                               attributedMessage: hasAttribute && hasMessage ? attributedMessage : nil,
                               messageLineLimit: messageLineLimit,
                               isPresented: $isPresented,
                               title: hasTitle ? title : nil,
                               attributedTitle: hasAttribute && hasTitle ? attributedTitle : nil,
                               image: image,
                               trailingImage: trailingImage,
                               trailingImageAccessibilityLabel: trailingImageLabel,
                               actionButtonTitle: actionButtonTitle,
                               actionButtonAction: actionButtonAction,
                               showDefaultDismissActionButton: showDefaultDismissActionButton,
                               showActionButtonAndDismissButton: showActionButtonAndDismissButton,
                               messageButtonAction: messageButtonAction,
                               swipeToDismissEnabled: swipeToDismissEnabled,
                               showFromBottom: showFromBottom,
                               verticalOffset: verticalOffset,
                               triggerModel: triggerModel)
            .backgroundGradient(showBackgroundGradient ? backgroundGradient : nil)
            .overrideTokens($overrideTokens.wrappedValue ? notificationOverrideTokens : nil)
        }
        .fluentTheme(theme)
        .tint(Color(theme.color(.brandForeground1)))
    }

    @ViewBuilder
    var notificationSettings: some View {
        FluentList {
            FluentListSection("Content") {
                LabeledContent {
                    TextField("Title", text: $title)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .multilineTextAlignment(.trailing)
                } label: {
                    Text("Title")
                }

                LabeledContent {
                    TextField("Message", text: $message)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .multilineTextAlignment(.trailing)
                } label: {
                    Text("Message")
                }

                LabeledContent {
                    TextField("Line Limit", value: $messageLineLimit, formatter: integerFormatter)
                        .keyboardType(.numberPad)
                } label: {
                    Text("Message Line Limit")
                }

                LabeledContent {
                    TextField("Action Button Title", text: $actionButtonTitle)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .multilineTextAlignment(.trailing)
                } label: {
                    Text("Action Button Title")
                }

                LabeledContent {
                    TextField("Offset", value: $verticalOffset, format: FloatingPointFormatStyle())
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                } label: {
                    Text("Vertical Offset")
                }

                Toggle("Has Attributed Text: Strikethrough", isOn: $hasBlueStrikethroughAttribute)
                Toggle("Has Attributed Text: Large Red Papyrus Font", isOn: $hasLargeRedPapyrusFontAttribute)
                Toggle("Set image", isOn: $showImage)
                Toggle("Set trailing image", isOn: $showTrailingImage)
                Button("Perform Bump") {
                    triggerModel.shouldBump = true
                }
            }

            FluentListSection("Action") {
                Toggle("Has Action Button Action", isOn: $hasActionButtonAction)
                Toggle("Show Default Dismiss Button", isOn: $showDefaultDismissActionButton)
                Toggle("Can Show Action & Dismiss Buttons", isOn: $showActionButtonAndDismissButton)
                Toggle("Has Message Action", isOn: $hasMessageAction)
                Toggle("Swipe to Dismiss Enabled", isOn: $swipeToDismissEnabled)
            }

            FluentListSection("Style") {

                Picker(selection: $style, label: EmptyView()) {
                    Text(".primaryToast").tag(MSFNotificationStyle.primaryToast)
                    Text(".neutralToast").tag(MSFNotificationStyle.neutralToast)
                    Text(".primaryBar").tag(MSFNotificationStyle.primaryBar)
                    Text(".primaryOutlineBar").tag(MSFNotificationStyle.primaryOutlineBar)
                    Text(".neutralBar").tag(MSFNotificationStyle.neutralBar)
                    Text(".dangerToast").tag(MSFNotificationStyle.dangerToast)
                    Text(".warningToast").tag(MSFNotificationStyle.warningToast)
                }
                .labelsHidden()
                .frame(maxWidth: .infinity, alignment: .leading)

                Toggle("Override Tokens (Image Color and Horizontal Spacing)", isOn: $overrideTokens)
                Toggle("Flexible Width Toast", isOn: $isFlexibleWidthToast)
                Toggle("Present From Bottom", isOn: $showFromBottom)
                Toggle("Background Gradient", isOn: $showBackgroundGradient)
                Toggle("Custom theme", isOn: $useCustomTheme)
            }
        }
        .fluentListStyle(.insetGrouped)
    }

    private var backgroundGradient: LinearGradientInfo {
        // It's a lovely blue-to-pink gradient
        let colors: [Color] = [Color(light: GlobalTokens.sharedSwiftUIColor(.pink, .tint50),
                                     dark: GlobalTokens.sharedSwiftUIColor(.pink, .shade40)),
                               Color(light: GlobalTokens.sharedSwiftUIColor(.cyan, .tint50),
                                     dark: GlobalTokens.sharedSwiftUIColor(.cyan, .shade40))]
        return LinearGradientInfo(colors: colors,
                                  startPoint: .init(x: 0.0, y: 1.0),
                                  endPoint: .init(x: 1.0, y: 0.0))
    }

    private var notificationOverrideTokens: [NotificationTokenSet.Tokens: ControlTokenValue] {
        return [
            .imageColor: .uiColor {
                return GlobalTokens.sharedColor(.orange, .primary)
            },
            .shadow: .shadowInfo {
                return ShadowInfo(keyColor: GlobalTokens.sharedSwiftUIColor(.hotPink, .primary),
                                  keyBlur: 10.0,
                                  xKey: 10.0,
                                  yKey: 10.0,
                                  ambientColor: GlobalTokens.sharedSwiftUIColor(.teal, .primary),
                                  ambientBlur: 100.0,
                                  xAmbient: -10.0,
                                  yAmbient: -10.0)
            }
        ]
    }
}
