//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit
import SwiftUI

class AvatarGroupDemoControllerSwiftUI: UIHostingController<AvatarGroupDemoView> {
    override init?(coder aDecoder: NSCoder, rootView: AvatarGroupDemoView) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    init() {
        super.init(rootView: AvatarGroupDemoView())
        self.title = "Avatar Group Vnext (SwiftUI)"
    }
}

struct AvatarGroupDemoView: View {
    // AvatarGroup properties
    @State var avatarCount: Int = 5
    @State var style: MSFAvatarGroupStyle = .stack
    @State var maxDisplayedAvatars: Int = 5
    @State var overflowCount: Int = 0

    // Avatar properties
    @State var useAlternateBackground: Bool = false
    @State var isRingVisible: Bool = true
    @State var isTransparent: Bool = true
    @State var hasRingInnerGap: Bool = true
    @State var showImageBasedRingColor: Bool = false
    @State var size: MSFAvatarSize = .xxlarge

    // TODO: Switch to Fluent button once it's available in SwiftUI
    struct AvatarCountButtonStyle: SwiftUI.ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(width: 32, height: 32)
                .foregroundColor(Color(Colors.communicationBlue))
                .background(
                    RoundedRectangle(cornerRadius: 8.0)
                        .strokeBorder(Color(Colors.communicationBlue))
                )
        }
    }

    @ViewBuilder
    var groupSettings: some View {
        Group {
            DemoHeading(title: "Group Settings")

            Picker(selection: $style, label: EmptyView(), content: {
                Text(".pile").tag(MSFAvatarGroupStyle.pile)
                Text(".stack").tag(MSFAvatarGroupStyle.stack)
            })
            .pickerStyle(SegmentedPickerStyle())
            .labelsHidden()
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Text("Avatar Count: \(avatarCount)")
                Spacer()

                Button(action: {
                    if avatarCount > 0 {
                        avatarCount -= 1
                    }
                }, label: {
                    Image(systemName: "minus")
                })
                .disabled(avatarCount <= 0)
                .buttonStyle(AvatarCountButtonStyle())

                Button(action: {
                    if avatarCount < samplePersonas.capacity - 1 {
                        avatarCount += 1
                    }
                }, label: {
                    Image(systemName: "plus")
                })
                .disabled(avatarCount >= samplePersonas.count - 1)
                .buttonStyle(AvatarCountButtonStyle())
            }

            HStack {
                Text("Max Displayed Avatars")
                Spacer()
                TextField("Max Displayed Avatars", value: $maxDisplayedAvatars, formatter: NumberFormatter())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .multilineTextAlignment(.trailing)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
            }

            HStack {
                Text("Overflow Count")
                Spacer()
                TextField("Overflow Count", value: $overflowCount, formatter: NumberFormatter())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .multilineTextAlignment(.trailing)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
            }
        }
    }

    @ViewBuilder
    var avatarSettings: some View {
        Group {
            DemoHeading(title: "Content")

            FluentUIDemoToggle(titleKey: "Set alternate background", isOn: $useAlternateBackground)
            FluentUIDemoToggle(titleKey: "Transparency", isOn: $isTransparent)
        }

        Group {
            DemoHeading(title: "Ring")
            FluentUIDemoToggle(titleKey: "Ring visible", isOn: $isRingVisible)
            FluentUIDemoToggle(titleKey: "Ring inner gap", isOn: $hasRingInnerGap)
            FluentUIDemoToggle(titleKey: "Set image based ring color", isOn: $showImageBasedRingColor)
        }

        Group {
            DemoHeading(title: "Size")

            Picker("Size", selection: $size) {
                Text(".xxlarge").tag(MSFAvatarSize.xxlarge)
                Text(".xlarge").tag(MSFAvatarSize.xlarge)
                Text(".large").tag(MSFAvatarSize.large)
                Text(".medium").tag(MSFAvatarSize.medium)
                Text(".small").tag(MSFAvatarSize.small)
                Text(".xsmall").tag(MSFAvatarSize.xsmall)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }

    }

    public var body: some View {
        VStack {
            AvatarGroup(style: style, size: size, avatars: avatars)
                .maxDisplayedAvatars(maxDisplayedAvatars)
                .overflowCount(overflowCount)
                .background(useAlternateBackground ? Color.gray : Color.clear)
                .padding(.vertical, 8)

            ScrollView {
                Group {
                    groupSettings
                    avatarSettings
                }
                .padding()
            }
        }
    }

    /// Lazily converts the first `avatarCount` elements of `samplePersonas` into `AvatarGroupAvatarState` instances.
    private var avatars: [AvatarGroupAvatarState] {
        samplePersonas.prefix(avatarCount).map { persona in
            let avatar = AvatarGroupAvatarState()
            avatar.image = persona.image
            avatar.primaryText = persona.name
            avatar.secondaryText = persona.email
            avatar.isRingVisible = isRingVisible
            avatar.hasRingInnerGap = hasRingInnerGap
            avatar.imageBasedRingColor = showImageBasedRingColor ? AvatarDemoController.colorfulCustomImage : nil
            avatar.isTransparent = isTransparent
            return avatar
        }
    }
}

struct AvatarGroupDemoView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarGroupDemoView()
    }
}
