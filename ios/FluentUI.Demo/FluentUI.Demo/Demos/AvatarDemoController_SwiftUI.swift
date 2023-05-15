//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit
import SwiftUI

class AvatarDemoControllerSwiftUI: UIHostingController<AvatarDemoView> {
    override init?(coder aDecoder: NSCoder, rootView: AvatarDemoView) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    init() {
        super.init(rootView: AvatarDemoView())
        self.title = "Avatar Fluent 2 (SwiftUI)"
    }

    override func willMove(toParent parent: UIViewController?) {
        guard let parent,
              let window = parent.view.window else {
            return
        }

        rootView.fluentTheme = window.fluentTheme
    }
}

struct AvatarDemoView: View {
    @State var useAlternateBackground: Bool = false
    @State var isAnimated: Bool = true
    @State var isOutOfOffice: Bool = false
    @State var isRingVisible: Bool = true
    @State var isTransparent: Bool = true
    @State var hasPointerInteraction: Bool = false
    @State var hasRingInnerGap: Bool = true
    @State var primaryText: String = "Kat Larsson"
    @State var secondaryText: String = ""
    @State var presence: MSFAvatarPresence = .none
    @State var activityStyle: MSFAvatarActivityStyle = .none
    @State var showActivityImage: Bool = false
    @State var showImage: Bool = false
    @State var showImageBasedRingColor: Bool = false
    @State var size: MSFAvatarSize = .size72
    @State var style: MSFAvatarStyle = .default
    @ObservedObject var fluentTheme: FluentTheme = .shared

    public var body: some View {
        VStack {
            Avatar(style: style,
                   size: size,
                   image: showImage ? UIImage(named: "avatar_kat_larsson") : nil,
                   primaryText: primaryText,
                   secondaryText: secondaryText)
                .isRingVisible(showImageBasedRingColor || isRingVisible)
                .hasRingInnerGap(hasRingInnerGap)
                .imageBasedRingColor(showImageBasedRingColor ? AvatarDemoController.colorfulCustomImage : nil)
                .isTransparent(isTransparent)
                .presence(presence)
                .activity(activityStyle, showActivityImage ? (activityStyle == .circle ? UIImage(named: "thumbs_up_3d_default") : UIImage(named: "excelIcon")) : nil)
                .isOutOfOffice(isOutOfOffice)
                .hasPointerInteraction(hasPointerInteraction)
                .isAnimated(isAnimated)
                .frame(maxWidth: .infinity, minHeight: 150, alignment: .center)
                .background(useAlternateBackground ? Color.gray : Color.clear)

            ScrollView {
                Group {
                    Group {
                        VStack(spacing: 0) {
                            Text("Content")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title)
                            Divider()
                        }

                        TextField("Primary Text", text: $primaryText)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        TextField("Secondary Text", text: $secondaryText)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        FluentUIDemoToggle(titleKey: "Set image", isOn: $showImage)
                        FluentUIDemoToggle(titleKey: "Set alternate background", isOn: $useAlternateBackground)
                        FluentUIDemoToggle(titleKey: "Transparency", isOn: $isTransparent)
                        FluentUIDemoToggle(titleKey: "iPad Pointer interaction", isOn: $hasPointerInteraction)
                        FluentUIDemoToggle(titleKey: "Animate transitions", isOn: $isAnimated)
                    }

                    Group {
                        VStack(spacing: 0) {
                            Text("Ring")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title)
                            Divider()
                        }
                        FluentUIDemoToggle(titleKey: "Ring visible", isOn: $isRingVisible)
                        FluentUIDemoToggle(titleKey: "Ring inner gap", isOn: $hasRingInnerGap)
                        FluentUIDemoToggle(titleKey: "Set image based ring color", isOn: $showImageBasedRingColor)
                    }

                    Group {
                        VStack(spacing: 0) {
                            Text("Presence")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title)
                            Divider()
                        }

                        Picker(selection: $presence, label: EmptyView()) {
                            Text(".none").tag(MSFAvatarPresence.none)
                            Text(".available").tag(MSFAvatarPresence.available)
                            Text(".away").tag(MSFAvatarPresence.away)
                            Text(".blocked").tag(MSFAvatarPresence.blocked)
                            Text(".busy").tag(MSFAvatarPresence.busy)
                            Text(".doNotDisturb").tag(MSFAvatarPresence.doNotDisturb)
                            Text(".offline").tag(MSFAvatarPresence.offline)
                            Text(".unknown").tag(MSFAvatarPresence.unknown)
                        }
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)

                        FluentUIDemoToggle(titleKey: "Out of office", isOn: $isOutOfOffice)
                    }

                    Group {
                        VStack(spacing: 0) {
                            Text("Activity")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title)
                            Divider()
                        }

                        Picker(selection: $activityStyle, label: EmptyView()) {
                            Text(".none").tag(MSFAvatarActivityStyle.none)
                            Text(".circle").tag(MSFAvatarActivityStyle.circle)
                            Text(".square").tag(MSFAvatarActivityStyle.square)
                        }
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)

                        FluentUIDemoToggle(titleKey: "Show image", isOn: $showActivityImage)
                    }

                    Group {
                        VStack(spacing: 0) {
                            Text("Style")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title)
                            Divider()
                        }

                        Picker(selection: $style, label: EmptyView()) {
                            Text(".default").tag(MSFAvatarStyle.default)
                            Text(".accent").tag(MSFAvatarStyle.accent)
                            Text(".group").tag(MSFAvatarStyle.group)
                            Text(".outlined").tag(MSFAvatarStyle.outlined)
                            Text(".outlinedPrimary").tag(MSFAvatarStyle.outlinedPrimary)
                            Text(".overflow").tag(MSFAvatarStyle.overflow)
                        }
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Group {
                        VStack(spacing: 0) {
                            Text("Size")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title)
                            Divider()
                        }

                        Picker(selection: $size, label: EmptyView()) {
                            Text(".size72").tag(MSFAvatarSize.size72)
                            Text(".size56").tag(MSFAvatarSize.size56)
                            Text(".size40").tag(MSFAvatarSize.size40)
                            Text(".size32").tag(MSFAvatarSize.size32)
                            Text(".size24").tag(MSFAvatarSize.size24)
                            Text(".size20").tag(MSFAvatarSize.size20)
                            Text(".size16").tag(MSFAvatarSize.size16)
                        }
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
            }
        }
        .fluentTheme(fluentTheme)
        .tint(Color(fluentTheme.color(.brandForeground1)))
    }
}
