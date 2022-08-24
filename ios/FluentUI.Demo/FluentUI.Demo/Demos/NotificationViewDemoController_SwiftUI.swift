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
        self.title = "Notification View Vnext (SwiftUI)"
    }
}

struct NotificationDemoView: View {
    @State var style: MSFNotificationStyle = .primaryToast
    @State var title: String = ""
    @State var message: String = "Mail Archived"
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
    @State var showFromBottom: Bool = true

    public var body: some View {
        let hasAttribute = hasBlueStrikethroughAttribute || hasLargeRedPapyrusFontAttribute
        let bothAttributes = [NSAttributedString.Key.strikethroughStyle: 1, NSAttributedString.Key.strikethroughColor: UIColor.blue, .font: UIFont.init(name: "Papyrus", size: 30.0)!, .foregroundColor: UIColor.red] as [NSAttributedString.Key: Any]
        let blueStrikethroughAttribute = [.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.strikethroughStyle: 1, NSAttributedString.Key.strikethroughColor: UIColor.blue] as [NSAttributedString.Key: Any]
        let redPapyrusFontAttribute = [.font: UIFont.init(name: "Papyrus", size: 30.0)!, .foregroundColor: UIColor.red] as [NSAttributedString.Key: Any]
        let attributedMessage = NSMutableAttributedString(string: message, attributes: (hasLargeRedPapyrusFontAttribute && hasBlueStrikethroughAttribute) ? bothAttributes : (hasLargeRedPapyrusFontAttribute ? redPapyrusFontAttribute : blueStrikethroughAttribute))
        let attributedTitle = NSMutableAttributedString(string: title, attributes: (hasLargeRedPapyrusFontAttribute && hasBlueStrikethroughAttribute) ? bothAttributes : (hasLargeRedPapyrusFontAttribute ? redPapyrusFontAttribute : blueStrikethroughAttribute))

        let image = showImage ? UIImage(named: "play-in-circle-24x24") : nil
        let trailingImage = showTrailingImage ? UIImage(named: "Placeholder_24") : nil
        let trailingImageLabel = showTrailingImage ? "Circle" : nil
        let actionButtonAction = hasActionButtonAction ? { showAlert = true } : nil
        let messageButtonAction = hasMessageAction ? { showAlert = true } : nil
        let hasMessage = !message.isEmpty
        let hasTitle = !title.isEmpty

        VStack {
            Rectangle()
                .foregroundColor(.clear)
                .presentNotification(style: style,
                                     isFlexibleWidthToast: $isFlexibleWidthToast.wrappedValue,
                                     message: hasMessage ? message : nil,
                                     attributedMessage: hasAttribute && hasMessage ? attributedMessage : nil,
                                     isBlocking: false,
                                     isPresented: .constant(true),
                                     title: hasTitle ? title : nil,
                                     attributedTitle: hasAttribute && hasTitle ? attributedTitle : nil,
                                     image: image,
                                     trailingImage: trailingImage,
                                     trailingImageAccessibilityLabel: trailingImageLabel,
                                     actionButtonTitle: actionButtonTitle,
                                     actionButtonAction: actionButtonAction,
                                     messageButtonAction: messageButtonAction,
                                     overrideTokens: $overrideTokens.wrappedValue ? notificationOverrideTokens : nil)
                .frame(maxWidth: .infinity, maxHeight: 150, alignment: .center)
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Button tapped"))
                })

            FluentButton(style: .secondary,
                         size: .small,
                         text: "Show") {
                if isPresented == false {
                    isPresented = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        isPresented = false
                    }
                }
            }
                .fixedSize()
                .padding()

            ScrollView {
                Group {
                    Group {
                        VStack(spacing: 0) {
                            Text("Content")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title)
                            FluentDivider()
                        }

                        TextField("Title", text: $title)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        TextField("Message", text: $message)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        TextField("Action Button Title", text: $actionButtonTitle)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        FluentUIDemoToggle(titleKey: "Has Attributed Text: Strikethrough", isOn: $hasBlueStrikethroughAttribute)
                        FluentUIDemoToggle(titleKey: "Has Attributed Text: Large Red Papyrus Font", isOn: $hasLargeRedPapyrusFontAttribute)
                        FluentUIDemoToggle(titleKey: "Set image", isOn: $showImage)
                        FluentUIDemoToggle(titleKey: "Set trailing image", isOn: $showTrailingImage)
                    }

                    Group {
                        VStack(spacing: 0) {
                            Text("Action")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title)
                            FluentDivider()
                        }
                        FluentUIDemoToggle(titleKey: "Has Action Button Action", isOn: $hasActionButtonAction)
                        FluentUIDemoToggle(titleKey: "Show Default Dismiss Button", isOn: $showDefaultDismissActionButton)
                        FluentUIDemoToggle(titleKey: "Has Message Action", isOn: $hasMessageAction)
                    }

                    Group {
                        VStack(spacing: 0) {
                            Text("Style")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title)
                            FluentDivider()
                        }

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

                        FluentUIDemoToggle(titleKey: "Override Tokens (Image Color and Horizontal Spacing)", isOn: $overrideTokens)
                        FluentUIDemoToggle(titleKey: "Flexible Width Toast", isOn: $isFlexibleWidthToast)
                        FluentUIDemoToggle(titleKey: "Present From Bottom", isOn: $showFromBottom)
                    }
                }
                .padding()
            }
        }
        .presentNotification(style: style,
                             isFlexibleWidthToast: $isFlexibleWidthToast.wrappedValue,
                             message: hasMessage ? message : nil,
                             attributedMessage: hasAttribute && hasMessage ? attributedMessage : nil,
                             isBlocking: false,
                             isPresented: $isPresented,
                             title: hasTitle ? title : nil,
                             attributedTitle: hasAttribute && hasTitle ? attributedTitle : nil,
                             image: image,
                             trailingImage: trailingImage,
                             trailingImageAccessibilityLabel: trailingImageLabel,
                             actionButtonTitle: actionButtonTitle,
                             actionButtonAction: actionButtonAction,
                             showDefaultDismissActionButton: showDefaultDismissActionButton,
                             messageButtonAction: messageButtonAction,
                             showFromBottom: showFromBottom,
                             overrideTokens: $overrideTokens.wrappedValue ? notificationOverrideTokens : nil)
    }

    private var notificationOverrideTokens: [NotificationTokenSet.Tokens: ControlTokenValue] {
        return [
            .imageColor: .dynamicColor {
                return DynamicColor(light: GlobalTokens().sharedColors[.orange][.primary])
            },
            .horizontalSpacing: .float {
                return 5.0
            },
            .shadow: .shadowInfo {
                return ShadowInfo(colorOne: DynamicColor(light: GlobalTokens().sharedColors[.hotPink][.primary]),
                                  blurOne: 10.0,
                                  xOne: 10.0,
                                  yOne: 10.0,
                                  colorTwo: DynamicColor(light: GlobalTokens().sharedColors[.teal][.primary]),
                                  blurTwo: 100.0,
                                  xTwo: -10.0,
                                  yTwo: -10.0)
            }
        ]
    }
}
