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
        self.title = "Avatar Vnext (SwiftUI)"
    }
}

struct AvatarDemoView: View {
    @State var useAlternateBackground: Bool = false
    @State var isOutOfOffice: Bool = false
    @State var isRingVisible: Bool = true
    @State var isTransparent: Bool = true
    @State var hasPointerInteraction: Bool = false
    @State var hasRingInnerGap: Bool = true
    @State var primaryText: String = "Kat Larrson"
    @State var secondaryText: String = ""
    @State var presence: MSFAvatarPresence = .none
    @State var showImage: Bool = false
    @State var showImageBasedRingColor: Bool = false
    @State var size: MSFAvatarSize = .xxlarge
    @State var style: MSFAvatarStyle = .default

    public var body: some View {
        VStack {
            AvatarView(style: .default,
                       size: .xxlarge,
                       image: nil,
                       primaryText: primaryText,
                       secondaryText: secondaryText)
                .size(size)
                .style(style)
                .image(showImage ? UIImage(named: "avatar_kat_larsson") : nil)
                .isRingVisible(isRingVisible)
                .hasRingInnerGap(hasRingInnerGap)
                .imageBasedRingColor(showImageBasedRingColor ? AvatarDemoController.colorfulCustomImage : nil)
                .isTransparent(isTransparent)
                .presence(presence)
                .isOutOfOffice(isOutOfOffice)
                .hasPointerInteraction(hasPointerInteraction)
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

                        Toggle("Set image", isOn: $showImage)
                        Toggle("Set alternate background", isOn: $useAlternateBackground)
                        Toggle("Transparency", isOn: $isTransparent)
                        Toggle("iPad Pointer interaction", isOn: $hasPointerInteraction)
                    }

                    Group {
                        VStack(spacing: 0) {
                            Text("Ring")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title)
                            Divider()
                        }
                        Toggle("Ring visible", isOn: $isRingVisible)
                        Toggle("Ring inner gap", isOn: $hasRingInnerGap)
                        Toggle("Set image based ring color", isOn: $showImageBasedRingColor)
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

                        Toggle("Out of office", isOn: $isOutOfOffice)
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
                            Text(".xxlarge").tag(MSFAvatarSize.xxlarge)
                            Text(".xlarge").tag(MSFAvatarSize.xlarge)
                            Text(".large").tag(MSFAvatarSize.large)
                            Text(".medium").tag(MSFAvatarSize.medium)
                            Text(".small").tag(MSFAvatarSize.small)
                            Text(".xsmall").tag(MSFAvatarSize.xsmall)
                        }
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
            }
        }
    }
}
